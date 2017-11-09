//
//  DayResultsView.m
//  GCAL
//
//  Created by Peter Kollath on 24/02/15.
//
//

#import "DayResultsView.h"
#import "GCCalculatedDaysPage.h"
#import "GCEngine.h"
#import "GCStrings.h"
#import "GcLocation.h"
#import "GCGregorianTime.h"
#import "GCCanvas.h"
#import "GCCalendarDay.h"
#import "GCCoreEvent.h"

@implementation DayResultsView


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initMyOwn];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initMyOwn];
    }
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

-(void)initMyOwn
{
//    self.viewState = DRV_MODE_FREE;
    self.userInteractionEnabled = NO;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    SEL paneDidMoveSelector = sel_registerName("paneDidMove:");
    
    if ([self.superview respondsToSelector:paneDidMoveSelector])
    {
        [self.superview performSelector:paneDidMoveSelector withObject:self];
    }
    
}


-(CGSize)calculateContentSize
{
    GCCanvas * canvas = [GCCanvas new];
    CGRect rect = self.frame;
    canvas.suppressDrawing = YES;
    
    canvas.styles = self.engine.styles;
    canvas.leftMargin = 20;
    canvas.currX = 20;
    canvas.rightMargin = rect.size.width - 20;
    canvas.engine = self.engine;
    
    [self drawGregorianDate:canvas];
    [self drawVedicDate:canvas];
    [self drawSpecialFestivals:canvas];
    [self drawSunTimes:canvas];
    [self drawFestivals:canvas];
    [self drawSunriseInfo:canvas];
    [self drawCoreEvents:canvas];
    
    return CGSizeMake(rect.size.width, ceil(canvas.currY) + 80);

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    GCCanvas * canvas = [GCCanvas new];
    canvas.styles = self.engine.styles;
    canvas.leftMargin = 20;
    canvas.currX = 20;
    canvas.rightMargin = rect.size.width - 20;
    canvas.engine = self.engine;
    
//    if (self.viewState == DRV_MODE_ASSIGNED_CONTAINER || self.viewState == DRV_MODE_ASSIGNED)
//    {
        // draws date and day data
        [self drawGregorianDate:canvas];
        [self drawVedicDate:canvas];
        [self drawSpecialFestivals:canvas];
        [self drawSunTimes:canvas];
        [self drawFestivals:canvas];
        [self drawSunriseInfo:canvas];
        [self drawCoreEvents:canvas];
        
//    }
//    else if (self.viewState == DRV_MODE_ASSIGNED_WAITING || self.viewState == DRV_MODE_ASSIGNED_WAITING_CONTAINER)
//    {
//        // draws only date
//        [self drawGregorianDate:canvas];
//    }

    self.drawBottom = canvas.currY + 40;
}


- (void)drawGregorianDate:(GCCanvas *)canvas
{
    NSString * dateString = [self.attachedDate longDateString];
    NSString * text2 = [self.attachedDate relativeTodayString];
    NSString * text3 = [self.attachedDate longDowString];
    NSString * space = @" ";
    
    CGSize dateStringSize = [canvas sizeOfString:dateString style:@"bold-1.5"];
    CGSize text2Size = [canvas sizeOfString:text2 style:@"normal-1.5"];
    CGSize text3Size = [canvas sizeOfString:text3 style:@"normal-1.5"];
    CGSize spaceSize = [canvas sizeOfString:space style:@"bold-1.5"];

    CGFloat twoLinesWidth = dateStringSize.width + spaceSize.width + text2Size.width;
    CGFloat oneLineWidth = twoLinesWidth + spaceSize.width + text3Size.width;
    
    if (oneLineWidth > (canvas.rightMargin - canvas.leftMargin))
    {
        canvas.currX = (canvas.rightMargin + canvas.leftMargin - twoLinesWidth)/2;
        [canvas drawString:dateString style:@"bold-1.5"];
        [canvas drawString:space style:@"bold-1.5"];
        [canvas drawString:text2 style:@"normal-1.5"];
        [canvas newLine];
        canvas.currX = (canvas.rightMargin + canvas.leftMargin - text3Size.width) / 2;
        [canvas drawString:text3 style:@"normal-1.5"];
        [canvas newLine];
    }
    else
    {
        canvas.currX = (canvas.rightMargin + canvas.leftMargin - oneLineWidth) / 2;
        [canvas drawString:dateString style:@"bold-1.5"];
        [canvas drawString:space style:@"bold-1.5"];
        [canvas drawString:text2 style:@"normal-1.5"];
        [canvas drawString:space style:@"bold-1.5"];
        [canvas drawString:text3 style:@"normal-1.5"];
        [canvas newLine];
    }

    
    // first line
    [canvas drawCenterString:[self.engine.myLocation fullName] style:@"location-subtitle"
                        left:canvas.leftMargin right:canvas.rightMargin];
    
    [canvas drawCenterString:[self.engine.myLocation timeZoneNameForDate:self.attachedDate]
                       style:@"location-subtitle" left:canvas.leftMargin right:canvas.rightMargin];
    
    
    return;
}

-(void)drawVedicDate:(GCCanvas *)canvas
{
    GCStrings * gstr = [GCStrings shared];
    GCCalendarDay * p = self.data.calendarDay;
    
    [canvas addY:10];
    
    NSString * text1 = [gstr GetTithiName:p.astrodata.nTithi];
    NSString * text2 = [NSString stringWithFormat:@", %@ %@", [gstr GetPaksaName:p.astrodata.nPaksa],
                        [gstr string:20]];
    CGSize size1 = [canvas sizeOfString:text1 style:@"bold-1.5"];
    CGSize size2 = [canvas sizeOfString:text2 style:@"normal-1.5"];
    
    canvas.currX = (canvas.leftMargin + canvas.rightMargin - size1.width - size2.width)/2;
    
    [canvas drawString:text1 style:@"bold-1.5"];
    [canvas drawString:text2 style:@"normal-1.5"];
    [canvas newLine];
    [canvas addY:5];
    
    NSString * str = [p resolveSpecialEkadasiMessage];
    if (str.length > 0)
    {
        [canvas drawCenterString:str style:@"normal-1.5" left:canvas.leftMargin right:canvas.rightMargin];
        [canvas addY:5];
    }
    
    str = [NSString stringWithFormat:@"%@ %@, %d Gaurabda",
     [gstr GetMasaName:p.astrodata.nMasa], [gstr string:22], p.astrodata.nGaurabdaYear];
    
    [canvas drawCenterString:str style:@"normal-1" left:canvas.leftMargin right:canvas.rightMargin];
//    [canvas newLine];
    canvas.currY += 8;
    
}

/*
 @YES, @"t_brahma",
 @YES, @"t_sandhya",
 @YES, @"t_sunrise",
 */

-(void)drawSunTimes:(GCCanvas *)canvas
{
    gc_daytime tdA, tdB;
    GCStrings * gstr = [GCStrings shared];
    GCCalendarDay * p = self.data.calendarDay;
    CGFloat mA = (canvas.leftMargin * 2 + canvas.rightMargin) / 3;
    CGFloat mB = (canvas.leftMargin + canvas.rightMargin * 2) / 3;
    CGFloat y;
    
    NSString * str = [gstr string:51];
    CGSize s1 = [str sizeWithAttributes:[self.engine.styles objectForKey:@"normal-1"]];
    CGSize s2 = [str sizeWithAttributes:[self.engine.styles objectForKey:@"bold-1.5"]];

    
    CGRect fillArea = CGRectMake(canvas.leftMargin-2, canvas.currY-2, canvas.rightMargin-canvas.leftMargin + 4, 0);

    if (self.engine.theSettings.t_sunrise)
        fillArea.size.height += s1.height + s2.height + 8;
    if (self.engine.theSettings.t_sandhya)
        fillArea.size.height += s1.height + s2.height + 8;
    if (self.engine.theSettings.t_brahma)
        fillArea.size.height += s1.height + 10;

    if (fillArea.size.height > 1)
    {
        [canvas fillRect:fillArea color:self.engine.sunTimesBackground.CGColor];

        
        if (self.engine.theSettings.t_brahma)
        {
            NSString * str;
            gc_daytime tdA = p.astrodata.sun.rise;
            gc_daytime tdB = p.astrodata.sun.rise;
            gc_daytime_sub_minutes(&tdA, 96);
            gc_daytime_sub_minutes(&tdB, 48);
            //str = @"Brahma-muhurta ";
            //[canvas drawString:str style:@"normal-1"];
            str = [NSString stringWithFormat:@"Brahma-muhurta %2d:%02d - %2d:%02d", tdA.hour, tdA.minute, tdB.hour, tdB.minute];
            canvas.currY += 5;
            [canvas drawCenterString:str style:@"normal-1" left:canvas.leftMargin right:canvas.rightMargin];
            canvas.currY += 5;
            //        [canvas newLine];
        }

        if (self.engine.theSettings.t_sunrise)
        {
            y = canvas.currY;
            
            [canvas drawCenterString:[gstr string:51] style:@"normal-1" left:canvas.leftMargin right:mA];
            [canvas drawCenterString:[p shortSunriseTime] style:@"bold-1.5" left:canvas.leftMargin right:mA];

            canvas.currY = y;
            [canvas drawCenterString:[gstr string:857] style:@"normal-1" left:mA right:mB];
            [canvas drawCenterString:[p shortNoonTime] style:@"bold-1.5" left:mA right:mB];

            canvas.currY = y;
            [canvas drawCenterString:[gstr string:52] style:@"normal-1"  left:mB right:canvas.rightMargin];
            [canvas drawCenterString:[p shortSunsetTime] style:@"bold-1.5"  left:mB right:canvas.rightMargin];


            canvas.currX = canvas.leftMargin;
            canvas.currY += 8;
        }
        
        if (self.engine.theSettings.t_sandhya)
        {
            y = canvas.currY;
            
            tdA = p.astrodata.sun.rise;
            tdB = p.astrodata.sun.rise;
            gc_daytime_sub_minutes(&tdA, 24);
            gc_daytime_add_minutes(&tdB, 24);
            [canvas drawCenterString:@"Gayatri" style:@"normal-1" left:canvas.leftMargin right:mA];
            [canvas drawCenterString:[NSString stringWithFormat:@"%02d:%02d - %02d:%02d", tdA.hour, tdA.minute, tdB.hour, tdB.minute]
                         style:@"bold-1" left:canvas.leftMargin right:mA];
            canvas.currY = y;
            tdA = p.astrodata.sun.noon;
            tdB = p.astrodata.sun.noon;
            gc_daytime_sub_minutes(&tdA, 24);
            gc_daytime_add_minutes(&tdB, 24);
            [canvas drawCenterString:@"Savitri" style:@"normal-1" left:mA right:mB];
            [canvas drawCenterString:[NSString stringWithFormat:@"%02d:%02d - %02d:%02d", tdA.hour, tdA.minute, tdB.hour, tdB.minute]
                         style:@"bold-1" left:mA right:mB];
            canvas.currY = y;
            tdA = p.astrodata.sun.set;
            tdB = p.astrodata.sun.set;
            gc_daytime_sub_minutes(&tdA, 24);
            gc_daytime_add_minutes(&tdB, 24);
            [canvas drawCenterString:@"Sarasvati" style:@"normal-1"   left:mB right:canvas.rightMargin];
            [canvas drawCenterString:[NSString stringWithFormat:@"%02d:%02d - %02d:%02d", tdA.hour, tdA.minute, tdB.hour, tdB.minute]
                         style:@"bold-1"   left:mB right:canvas.rightMargin];
            canvas.currX = canvas.leftMargin;
            canvas.currY += 8;
        }
        
        canvas.lineHeight = 4;
    }

}

- (void)drawTextInRoundrect:(GCCanvas *)canvas pdf:(NSString *)pdf
                   bkgColor:(CGColorRef)bkgColor foreColor:(CGColorRef)foreColor
{
    canvas.leftMargin += 8;
    canvas.rightMargin -= 8;
    canvas.currX = canvas.leftMargin;
    CGSize size = [canvas sizeOfLine:pdf style:@"bold-1.5"];
    size.width = canvas.rightMargin - canvas.leftMargin;
    [canvas strokeRoundRect:CGRectMake(canvas.currX - 4, canvas.currY - 4, size.width + 8, size.height + 8)
             cornerDiameter:4 foregroundColor:foreColor backgroundColor:bkgColor];
    [canvas drawLine:pdf style:@"bold-1.5"];
    canvas.leftMargin -= 8;
    canvas.rightMargin += 8;
    canvas.currX = canvas.leftMargin;
    canvas.currY += 8;
}

-(void)drawSpecialFestivals:(GCCanvas *)canvas
{
    GCStrings * gstr = self.engine.myStrings;
    GCCalendarDay * p = self.data.calendarDay;
    CGColorRef bkgColor;
    CGColorRef foreColor = [UIColor blackColor].CGColor;
    int i = 0;
    
    if (p.isEkadasiParana)
    {
        // disp.specialTextColor
        // [p getHtmlDayBackground]
        NSString * text = [p GetTextEP:gstr];
        [self drawTextInRoundrect:canvas pdf:text
                         bkgColor:self.engine.h3Background.CGColor
                        foreColor:foreColor];
        canvas.currY += 4;
        i++;
    }
    
    for(GcDayFestival * pdf in p.festivals)
    {
        if (pdf.highlight == 1)
        {
            bkgColor = self.engine.h1Background.CGColor;
            [self drawTextInRoundrect:canvas pdf:pdf.name bkgColor:bkgColor foreColor:foreColor];
            canvas.currY += 4;
            i++;
        }
        else if (pdf.highlight == 2)
        {
            bkgColor = self.engine.h2Background.CGColor;
            [self drawTextInRoundrect:canvas pdf:pdf.name bkgColor:bkgColor foreColor:foreColor];
            canvas.currY += 4;
            i++;
        }
        else if (pdf.highlight == 3)
        {
            bkgColor = NULL;
            [canvas drawLine:pdf.name style:@"normal-highlight-1.5"];
            i++;
        }

    }
    
    if (i > 0)
    {
        canvas.currY += 10;
    }
}

-(void)drawFestivals:(GCCanvas *)canvas
{
    GCCalendarDay * p = self.data.calendarDay;
    BOOL hdr = NO;
   
    

    for(GcDayFestival * pdf in p.festivals)
    {
        if (pdf.highlight == 0)
        {
            if (hdr == NO)
            {
                [canvas drawSubheader:@"Festivals" style:@"normal-1"];
                hdr = YES;
            }
            [canvas drawLine:pdf.name style:@"bold-1"];
        }
    }

}

-(void)drawSunriseInfo:(GCCanvas *)canvas
{
    
    if (self.engine.theSettings.t_riseinfo)
    {
        GCStrings * gstr = self.engine.myStrings;
        GCCalendarDay * p = self.data.calendarDay;
        NSString * str;
        
        str = [NSString stringWithFormat:@"%@ info", [gstr string:51]];
        [canvas drawSubheader:str style:@"normal-1"];

        str = [NSString stringWithFormat:@"Moon in the %@ %@", [gstr GetNaksatraName:p.astrodata.nNaksatra], [gstr string:15]];
        [canvas drawString:str style:@"normal-1"];
        [canvas newLine];
        str = [NSString stringWithFormat:@"%@ %@", [gstr GetYogaName:p.astrodata.nYoga], [gstr string:104]];
        [canvas drawString:str style:@"normal-1"];
        [canvas newLine];
        str = [NSString stringWithFormat:@"Sun in the %@ %@", [gstr GetSankrantiName:p.astrodata.nRasi], [gstr string:105]];
        [canvas drawString:str style:@"normal-1"];
        [canvas newLine];
    }

}

-(void)drawCoreEvents:(GCCanvas *)canvas
{
    if (self.engine.theSettings.t_core)
    {
        [canvas drawSubheader:@"Core Events" style:@"normal-1"];

        for (GCCoreEvent * ce in self.data.calendarDay.coreEvents) {
            int hr = ce.seconds / 3600;
            int mins = (ce.seconds % 3600) / 60;
            int secs = ce.seconds % 60;
            NSString * str = [NSString stringWithFormat:@"%02d:%02d:%02d %@", hr, mins, secs, ce.text];
            
            [canvas drawString:str style:@"normal-1"];
            if (ce.daylightSavingTime)
            {
                canvas.currX = canvas.rightMargin - 20;
                [canvas drawString:@"DST" style:@"location-subtitle"];
            }
            [canvas newLine];
        }
    }
}

@end
