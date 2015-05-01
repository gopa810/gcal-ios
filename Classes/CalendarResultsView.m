//
//  CalendarResultsView.m
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import "CalendarResultsView.h"
#import "GCCalculatedDaysPage.h"
#import "GCEngine.h"
#import "GCStrings.h"
#import "GcLocation.h"
#import "GCGregorianTime.h"
#import "GCCanvas.h"
#import "GCCalendarDay.h"
#import "GCCoreEvent.h"
#import "VUScrollView.h"

@implementation CalendarResultsView


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

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    
//    if ([self.superview respondsToSelector:(@selector(paneDidMove:))])
//    {
//        [self.superview performSelector:@selector(paneDidMove:) withObject:self];
//    }
//    
//}

- (void)drawMasaDelimiter:(GCCanvas *)canvas {
    CalendarResultsView * prevCal = (CalendarResultsView *)self.prevPane;
    if (prevCal.data.calendarDay.astrodata.nMasa != self.data.calendarDay.astrodata.nMasa)
    {
        GCStrings * gstrings = [GCStrings shared];
        GCCalendarDay * p = self.data.calendarDay;
        NSString * str = [NSString stringWithFormat:@"%@ %@", [gstrings string:22], [gstrings GetMasaName:p.astrodata.nMasa]];
        [canvas drawCenterString:str style:@"bold-1.5" left:canvas.leftMargin right:canvas.rightMargin];
        str = [NSString stringWithFormat:@"%d Gaurabda", p.astrodata.nGaurabdaYear];
        [canvas drawCenterString:str style:@"bold-1" left:canvas.leftMargin right:canvas.rightMargin];
        
        [canvas drawCenterString:[self.engine.myLocation fullName] style:@"location-subtitle"
                            left:canvas.leftMargin right:canvas.rightMargin];
        
        [canvas drawCenterString:[self.engine.myLocation timeZoneNameForDate:self.attachedDate]
                           style:@"location-subtitle" left:canvas.leftMargin right:canvas.rightMargin];
        
        [canvas addY:20];
        
    }
}

-(CGSize)calculateContentSize
{
    CGRect rect = self.frame;
 
    GCCanvas * canvas = [GCCanvas new];
    canvas.suppressDrawing = YES;
    canvas.styles = self.engine.styles;
    canvas.dispSettings = [GCDisplaySettings sharedSettings];
    canvas.leftMargin = 20;
    canvas.currX = 20;
    canvas.rightMargin = rect.size.width - 20;
    canvas.engine = self.engine;
    
    [canvas addY:10];
    
    if (self.prevPane != nil && canvas.dispSettings.extendedFunctionality == YES)
    {
        [self drawMasaDelimiter:canvas];
        
    }
    
    // draws date and day data
    [self drawGregorianDate:canvas];
    
    if (canvas.dispSettings.extendedFunctionality == YES)
    {
        [self drawVedicDate:canvas];
        
        [self drawFestivals:canvas];
    }
    else
    {
        [self drawExtensionText:canvas];
    }
    
    CGFloat newBottom = floor(canvas.currY + 5);
    
    return CGSizeMake(rect.size.width, newBottom);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    GCCanvas * canvas = [GCCanvas new];
    canvas.styles = self.engine.styles;
    canvas.dispSettings = [GCDisplaySettings sharedSettings];
    canvas.leftMargin = 20;
    canvas.currX = 20;
    canvas.rightMargin = rect.size.width - 20;
    canvas.engine = self.engine;
    canvas.subLinesIndent = 32;
    
//    if (self.viewState == DRV_MODE_ASSIGNED_CONTAINER || self.viewState == DRV_MODE_ASSIGNED)
//    {
        [canvas addY:10];
        
        if (self.prevPane != nil /*&& (self.prevPane.viewState == DRV_MODE_ASSIGNED_CONTAINER || self.prevPane.viewState == DRV_MODE_ASSIGNED)*/ && canvas.dispSettings.extendedFunctionality == YES)
        {
            [self drawMasaDelimiter:canvas];
            
        }
        
        // draws date and day data
        [self drawGregorianDate:canvas];

        if (canvas.dispSettings.extendedFunctionality == YES)
        {
            [self drawVedicDate:canvas];

            [self drawFestivals:canvas];
        }
        else
        {
            [self drawExtensionText:canvas];
        }

        
//    }
//    else if (self.viewState == DRV_MODE_ASSIGNED_WAITING || self.viewState == DRV_MODE_ASSIGNED_WAITING_CONTAINER)
//    {
//        // draws only date
//        [self drawGregorianDate:canvas];
//        
//        if (canvas.dispSettings.extendedFunctionality == NO)
//        {
//            [self drawExtensionText:canvas];
//        }
//        
//        [canvas addY:30];
//    }
    
    CGFloat newBottom = floor(canvas.currY + 5);
    self.drawBottom = newBottom;

    //if (!self.alignedHeight /*&& (self.viewState == DRV_MODE_ASSIGNED_CONTAINER || self.viewState == DRV_MODE_ASSIGNED)*/)
//    if (abs(newBottom - self.frame.size.height) > 2)
//    {
//        self.alignedHeight = YES;
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newBottom);
//        //[self setNeedsDisplay];
//        [self.scrollParent postRearrange];
//    }
}


- (void)drawGregorianDate:(GCCanvas *)canvas
{
    NSString * dateString = [self.attachedDate longDateString];
    NSString * text3 = [self.attachedDate longDowString];
    
    CGFloat cx = canvas.currX;
    [canvas drawString:dateString style:@"normal-1.5"];
    [canvas drawString:@"  " style:@"normal-1"];
    [canvas drawString:text3 style:@"normal-1"];
    [canvas newLine];
    canvas.currX = cx;
    
    return;
}

-(void)drawVedicDate:(GCCanvas *)canvas
{
    GCStrings * gstr = [GCStrings shared];
    GCCalendarDay * p = self.data.calendarDay;
    
    NSString * text1 = [NSString stringWithFormat:@"%@ Tithi %@, %@ Paksa", [gstr GetTithiName:p.astrodata.nTithi], [p resolveSpecialEkadasiMessage], [gstr GetPaksaName:p.astrodata.nPaksa]];
    NSString * text2 = [NSString stringWithFormat:@"%@ Naksatra, %@ Yoga",[gstr GetNaksatraName:p.astrodata.nNaksatra], [gstr GetYogaName:p.astrodata.nYoga]];

    canvas.currX = canvas.leftMargin;
    [canvas drawLine:text1 style:@"normal-1"];
    [canvas drawLine:text2 style:@"normal-1"];


    [canvas newLine];
    
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

-(void)drawFestivals:(GCCanvas *)canvas
{
    GCStrings * gstr = self.engine.myStrings;
    GCCalendarDay * p = self.data.calendarDay;
    int i = 0;
    
    if (p.isEkadasiParana)
    {
        // disp.specialTextColor
        // [p getHtmlDayBackground]
        NSString * text = [p GetTextEP:gstr];
        [canvas drawLine:text style:@"normal-1"];
        //[canvas newLine];
        i++;
    }
    
    for(GcDayFestival * pdf in p.festivals)
    {
        [canvas drawLine:pdf.name style:@"normal-1"];
        //[canvas newLine];
        
    }
    
    if (i > 0)
    {
        canvas.currY += 10;
    }
}

-(void)drawExtensionText:(GCCanvas *)canvas
{
    canvas.currX = canvas.leftMargin + canvas.subLinesIndent;
    
    [canvas drawLine:@"Calendar view is available only in extended mode. To activate extended mode, please purchase basic extension package, in menu bar 'Action' -> 'Add Features' " style:@"normal-1"];
    
    canvas.currY += 10;
}

-(void)setData:(GCTodayInfoData *)data
{
    [super setData:data];
    
    if ([data calendarDay] != nil)
    {
        GCCalendarDay * cd = [data calendarDay];
        if (cd.nFastType == FAST_EKADASI)
        {
            self.backgroundColor = self.engine.h1Background;
        }
        else if (cd.nFastType != FAST_NULL)
        {
            self.backgroundColor = self.engine.h2Background;
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
    }
    
    self.alignedHeight = NO;
}

@end
