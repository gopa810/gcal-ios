//
//  GCGregorianTime.h
//  GCAL
//
//  Created by Peter Kollath on 28/02/15.
//
//

#import <Foundation/Foundation.h>

@interface GCGregorianTime : NSObject <NSCopying>
{
    int _dayOfWeek;
}

@property (assign) int year;
@property (assign) int month;
@property (nonatomic,assign) int dayOfWeek;
@property (assign) int day;
@property (assign) double shour;
@property (assign) double tzone;

-(double)julian;
-(double)julianComplete;
-(void)setJulian:(double)jd;
-(int)getJulianInteger;
-(void)setValues:(GCGregorianTime *)gc;


-(NSString *)shortDateString;
-(NSString *)longDateString;
-(NSString *)shortTimeString;
-(NSString *)relativeTodayString;
-(NSString *)shortDowString;
-(NSString *)longDowString;


-(NSDate *)getNSDate;
-(GCGregorianTime *)previousDay;
-(GCGregorianTime *)nextDay;
-(GCGregorianTime *)addDays:(int)days;
-(GCGregorianTime *)addDayHours:(double)dhours;
-(GCGregorianTime *)timeByAddingMinutes:(double)minutes;
+(int)getMaxDaysInYear:(int)year month:(int)month;
+(BOOL)isLeapYear:(int)year;
+(GCGregorianTime *)today;
-(GCGregorianTime *)normalize;

+(void)MoveToPreviousDay:(GCGregorianTime *)day;
+(void)MoveToNextDay:(GCGregorianTime *)day;
-(void)MoveDays:(int)count;

@end
