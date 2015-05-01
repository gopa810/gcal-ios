//
//  GcLocation.h
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gc_dtypes.h"


@class GCGregorianTime;

@interface GcLocation : NSObject {
	  NSString * country;
	  NSString * city;
//	  NSString * timezoneName;
	double longitude;
	double latitude;
//	double tzone; // contains hours 5.5 is 5hr30min
//	double bias; // contains hours 1.0 is 1hr
	/*NSUInteger dstData;
	 int offset;
	 int bias;*/
	int start_month;
	int start_monthday;
	int start_weekday;
	int start_order;
	int end_month;
	int end_monthday;
	int end_weekday;
	int end_order;
	
	NSTimeZone * timeZone;
	NSCalendar * gregCalendar;
	NSDateComponents * dateComponents;
}

@property(copy)   NSString * country;
@property(copy)   NSString * city;
//@property(copy)   NSString * timezoneName;
@property(assign) double longitude;
@property(assign) double latitude;
//property(assign) double tzone; // contains hours 5.5 is 5hr30min
//@property(assign) double bias; // contains hours 1.0 is 1hr
/*@property(assign) NSUInteger dstData;
@property (assign) int offset;
@property (assign) int bias;*/
@property (assign) int start_month;
@property (assign) int start_monthday;
@property (assign) int start_weekday;
@property (assign) int start_order;
@property (assign) int end_month;
@property (assign) int end_monthday;
@property (assign) int end_weekday;
@property (assign) int end_order;
@property (nonatomic, strong) NSTimeZone * timeZone;

-(NSString *)textLatitude;
-(NSString *)textLongitude;
-(NSString *)textTimezone;
-(NSString *)fullName;
-(gc_earth)getEarth;
-(void)empty;
-(BOOL)isDaylightTime:(GCGregorianTime *)date;
-(double)daytimeBiasForDate:(GCGregorianTime *)date;
-(ga_time)getGaurabdaDate:(GCGregorianTime *)vc;
-(GCGregorianTime *)getGregorianDate:(ga_time)va;
-(double)scanEarthPos:(NSString *)str result:(int *)pResult;
//-(NSString *)timeZoneName;
-(double)timeZoneOffset;
-(NSString *)timeNameForDate:(GCGregorianTime *)date;
-(NSDate *)dateFromGcTime:(GCGregorianTime *)vc;
-(NSString *)timeZoneNameForDate:(GCGregorianTime *)gt;
@end
