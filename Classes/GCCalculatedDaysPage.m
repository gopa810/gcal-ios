//
//  GCCalculatedDaysPage.m
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import "GCCalculatedDaysPage.h"
#import "DayResultsView.h"
#import "GCTodayInfoData.h"

@implementation GCCalculatedDaysPageObserver


@end

#pragma mark -

@implementation GCCalculatedDaysPage

-(id)init
{
    self = [super init];
    if (self)
    {
        self.items = [NSMutableArray new];
        self.observers = [NSMutableArray new];
    }
    return self;
}


-(GCTodayInfoData *)objectAtIndex:(NSInteger)index
{
    if (self.items.count <= index)
        return nil;
    return [self.items objectAtIndex:index];
}

-(void)addObserverView:(ResultsViewBase *)view forIndex:(int)index
{
    GCCalculatedDaysPageObserver * observer = [GCCalculatedDaysPageObserver new];
    
    observer.view = view;
    observer.index = index;

    [self.observers addObject:observer];
}


@end
