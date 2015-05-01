//
//  GCCalculatedDaysPage.h
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import <Foundation/Foundation.h>

@class GCTodayInfoData;
@class ResultsViewBase;

@interface GCCalculatedDaysPage : NSObject

@property (assign) int pageNo;
@property (assign) BOOL done;
@property (assign) int usage;
@property (strong) NSMutableArray * items;
@property (strong) NSMutableArray * observers;

-(GCTodayInfoData *)objectAtIndex:(NSInteger)index;
-(void)addObserverView:(ResultsViewBase *)view forIndex:(int)index;

@end


@interface GCCalculatedDaysPageObserver : NSObject

@property (strong) ResultsViewBase * view;
@property (assign) int index;

@end