//
//  GCEngine.m
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import "GCEngine.h"
#import "GCCalculatedDaysPage.h"
#import "GCTodayInfoData.h"
#import "ResultsViewBase.h"
#import "GcResultCalendar.h"
#import "GCGregorianTime.h"

@implementation GCEngine

-(id)init
{
    self = [super init];
    if (self) {
        self.pagesLock = [NSLock new];
        self.pages = [NSMutableArray new];
        self.styles = [NSMutableDictionary new];
        [self initStyles:self.styles];
    }
    return self;
}

-(void)initStyles:(NSMutableDictionary *)S
{
    CGFloat systemFontSize = [UIFont systemFontSize];
    UIColor * baseColor = [UIColor blackColor];
    UIColor * invertColor = [UIColor whiteColor];
    UIColor * highlightColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.2 alpha:1.0];
    
    self.invertedText = invertColor;
    self.basicText = baseColor;
    self.highlightedText = highlightColor;
    
    self.h1Background = [UIColor colorWithRed:1.0 green:1.0 blue:0.5 alpha:1.0];
    self.h2Background = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
    self.h3Background = [UIColor colorWithRed:0.5 green:1.0 blue:1.0 alpha:1.0];
    self.sunTimesBackground = [UIColor colorWithRed:1.0 green:0.95 blue:0.9 alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.subheaderBackground = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    
    UIFont * boldSystem1_5 = [UIFont boldSystemFontOfSize:systemFontSize*1.5];
    UIFont * boldSystem1 = [UIFont boldSystemFontOfSize:systemFontSize];
    UIFont * normalSystem1 = [UIFont fontWithName:@"Helvetica Light" size:systemFontSize];
    UIFont * normalSystem1_5 = [UIFont fontWithName:@"Helvetica Light" size:systemFontSize*1.5];
    UIFont * normalSystem0_75 = [UIFont fontWithName:@"Helvetica Light" size:systemFontSize*0.75];
    
    NSDictionary * d = [NSDictionary dictionaryWithObjectsAndKeys:baseColor, NSForegroundColorAttributeName,
                        boldSystem1_5, NSFontAttributeName, nil];
    
    [S setValue:d forKey:@"bold-1.5"];

    // normal, 1.5
    d = [NSDictionary dictionaryWithObjectsAndKeys:baseColor, NSForegroundColorAttributeName,
         normalSystem1_5, NSFontAttributeName, nil];
    [S setValue:d forKey:@"normal-1.5"];

    // normal, 1
    [S setValue:[NSDictionary dictionaryWithObjectsAndKeys:normalSystem1, NSFontAttributeName,
                 baseColor, NSForegroundColorAttributeName, nil]
         forKey:@"normal-1"];

    [S setValue:[NSDictionary dictionaryWithObjectsAndKeys:normalSystem1, NSFontAttributeName,
                 invertColor, NSForegroundColorAttributeName, nil]
         forKey:@"normal-invert-1"];

    [S setValue:[NSDictionary dictionaryWithObjectsAndKeys:normalSystem1_5, NSFontAttributeName,
                 highlightColor, NSForegroundColorAttributeName, nil]
         forKey:@"normal-highlight-1.5"];
    
    // normal, 1
    [S setValue:[NSDictionary dictionaryWithObjectsAndKeys:boldSystem1, NSFontAttributeName,
                 baseColor, NSForegroundColorAttributeName, nil]
         forKey:@"bold-1"];

    // location, subtitle
    d = [NSDictionary dictionaryWithObjectsAndKeys:baseColor, NSForegroundColorAttributeName,
         normalSystem0_75, NSFontAttributeName,nil];
    [S setValue:d forKey:@"location-subtitle"];
    
    
}

-(GCTodayInfoData *)requestPage:(int)pageNo view:(ResultsViewBase *)view itemIndex:(int)index
{
    GCTodayInfoData * data = nil;
    GCCalculatedDaysPage * newPage = nil;
    
    [self.pagesLock lock];
    
    for (GCCalculatedDaysPage * page in self.pages) {
        if (page.pageNo == pageNo)
        {
            if (page.done == YES)
            {
                data = [page objectAtIndex:index];
                page.usage = 0;
            }
            else
            {
                [page addObserverView:view forIndex:index];
            }
            newPage = page;
        }
        else
        {
            page.usage = page.usage + 1;
        }
    }

    if (newPage == nil)
    {
        newPage = [GCCalculatedDaysPage new];
        newPage.usage = 0;
        newPage.done = NO;
        newPage.pageNo = pageNo;
        [newPage addObserverView:view forIndex:index];
        [self.pages addObject:newPage];

        [self calculatePage:newPage];
        newPage.done = YES;
        
        data = [newPage objectAtIndex:index];
        //NSLog(@"Requested to calculate calendar page %d", newPage.pageNo);
        //[self performSelectorInBackground:@selector(calculatePage:) withObject:newPage];
    }
    
    [self.pagesLock unlock];
    
    return data;
}

-(GCTodayInfoData *)requestPageSynchronous:(int)pageNo itemIndex:(int)index
{
    GCTodayInfoData * data = nil;
    GCCalculatedDaysPage * newPage = nil;
    
    [self.pagesLock lock];
    
    for (GCCalculatedDaysPage * page in self.pages) {
        if (page.pageNo == pageNo)
        {
            data = [page objectAtIndex:index];
            break;
        }
    }
    
    if (data == nil)
    {
        newPage = [GCCalculatedDaysPage new];
        newPage.usage = 0;
        newPage.done = NO;
        newPage.pageNo = pageNo;
        [self.pages addObject:newPage];
    }
    
    [self.pagesLock unlock];

    if (data != nil)
    {
        return data;
    }
    
    [self calculatePage:newPage];
    
    return [newPage objectAtIndex:index];
}

-(void)reset
{
    [self.pagesLock lock];
    [self.pages removeAllObjects];
    [self.pagesLock unlock];
}

-(void)calculatePage:(GCCalculatedDaysPage *)page
{
   // NSLog(@"Requested to calculate calendar page %d", page.pageNo);
    
    // calculate page
    GCGregorianTime * time = [GCGregorianTime new];
    
    [time setJulian:(page.pageNo * 32)];
    
    GcResultCalendar *rc = [GcResultCalendar new];
    rc.m_Location = self.myLocation;
    rc.gstr = self.myStrings;
    
    [rc CalculateCalendar:time count:32];
    [page.items removeAllObjects];
    for(int i = 0; i < 32; i++)
    {
        GCCalendarDay * day = [rc dayAtIndex:i];
        GCTodayInfoData * tid = [[GCTodayInfoData alloc] initWithCalendarDay:day];
        [page.items addObject:tid];
    }
    
//    // finish everything
//    [self.pagesLock lock];
//    
//    page.done = YES;
//    for (GCCalculatedDaysPageObserver * obs in page.observers) {
//        obs.view.data = [page objectAtIndex:obs.index];
//        //NSLog(@"get back to %@", [obs.view class]);
//        [obs.view performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//    }
//    [page.observers removeAllObjects];
//    
//    [self.pagesLock unlock];
    
}


@end
