//
//  GCTodayInfoData.h
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import <Foundation/Foundation.h>
@class GCCalendarDay;

@interface GCTodayInfoData : NSObject


@property GCCalendarDay * calendarDay;

-(id)initWithCalendarDay:(GCCalendarDay *)cd;


@end
