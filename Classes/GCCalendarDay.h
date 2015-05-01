//
//  GcDay.h
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gc_const.h"
#import "gc_dtypes.h"
#import "GCStrings.h"
#import "GcDayFestival.h"
#import "GCDisplaySettings.h"

@class GCCoreEvent;
@class GCGregorianTime;
@class GcResultCalendar;

@interface GCCalendarDay : NSObject {
	NSUInteger nCaturmasya;
	int nDST;
	//gc_time date;
	// moon data
	gc_daytime moonrise;
	gc_daytime moonset;
	// astronomical data from astro-sub-layer
	gc_astro astrodata;
	// fast data
	int nFastType;
	int nFeasting;
	// ekadasi data
	int nMhdType;
	BOOL isEkadasiParana;
	double hrEkadasiParanaStart;
	double hrEkadasiParanaEnd;
	// sankranti data
	int sankranti_zodiac;
	// ksata data
	BOOL was_ksaya;
	int ksaya_day2;
	int ksaya_day1;
	double ksaya_time1;
	double ksaya_time2;
	// vriddhi data
	BOOL is_vriddhi;
	// flag for validity
	BOOL fDateValid;
	BOOL fAstroValid;
	BOOL fVaisValid;	
}
@property (weak) GCCalendarDay * previousDay;
@property (weak) GCCalendarDay * nextDay;

@property(assign) NSUInteger nCaturmasya;
@property(assign) int nDST;
@property(copy) GCGregorianTime * date;
// moon data
@property(assign) gc_daytime moonrise;
@property(assign) gc_daytime moonset;
// astronomical data from astro-sub-layer
@property(assign) gc_astro astrodata;
// data for vaisnava calculations
@property(strong) NSMutableArray * festivals;
// fast data
@property(assign) int nFastType;
@property(assign) int nFeasting;
// ekadasi data
@property(assign) int nMhdType;
@property(copy)   NSString * ekadasiVrataName;
@property(assign) BOOL isEkadasiParana;
@property(assign) double hrEkadasiParanaStart;
@property(assign) double hrEkadasiParanaEnd;
// sankranti data
@property(assign) int sankranti_zodiac;
@property(copy) GCGregorianTime * sankranti_day;
@property (strong) NSMutableArray * coreEvents;
// ksata data
@property(assign) BOOL was_ksaya;
@property(assign) int ksaya_day2;
@property(assign) int ksaya_day1;
@property(assign) double ksaya_time1;
@property(assign) double ksaya_time2;
// vriddhi data
@property(assign) BOOL is_vriddhi;
// flag for validity
@property(assign) BOOL fDateValid;
@property(assign) BOOL fAstroValid;
@property(assign) BOOL fVaisValid;	


//-(int)GetLineCount;
//-(BOOL)GetTithiTimeRange:(gc_earth *)earth from:(gc_time *)infrom to:(gc_time *)into;
//-(BOOL)GetNaksatraTimeRange:(gc_earth *)earth from:(gc_time *)infrom to:(gc_time *)into;
-(NSString *)GetTextEP:(GCStrings *)gstr;
-(void)Clear;
-(void)AddFestivalRecord:(GcDayFestival *)p;
-(void)AddListText:(NSString *)str toString:(NSMutableString *)dest format:(int)iFormat;
-(void)AddSpecFestival:(int)nSpecialFestival withClass:(int)nClass source:(GcResultCalendar *)gstr;
-(GcDayFestival *)AddFestival:(NSString *)text;
-(GcDayFestival *)AddFestival:(NSString *)text withClass:(int)nClass;
-(void)setMasa:(int)nMasa;
-(void)setGaurabda:(int)nGaurabdaYear;
-(void)addBiasToTimes:(double)hours;
-(NSString *)getHtmlDayBackground;
-(NSString *)stringWithFormat:(int)iFormat display:(GCDisplaySettings *)disp source:(GCStrings *)gstr;
-(NSString *)getTithiNameComplete:(GCStrings *)gstr;
-(NSString *)resolveSpecialEkadasiMessage;
-(void)addCoreEvent:(GCCoreEvent *)ce;
-(NSString *)shortSunriseTime;
-(NSString *)shortNoonTime;
-(NSString *)shortSunsetTime;

@end
