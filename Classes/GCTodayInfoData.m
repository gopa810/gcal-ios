//
//  GCTodayInfoData.m
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import "GCTodayInfoData.h"

@implementation GCTodayInfoData


-(id)initWithCalendarDay:(GCCalendarDay *)cd
{
    self = [super init];
    
    if (self) {
        self.calendarDay = cd;
    }
    
    return self;
}



@end
