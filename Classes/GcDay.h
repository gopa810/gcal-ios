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
#import "gcalAppDisplaySettings.h"

@class GcResultCalendar;

@interface GcDay : NSObject {
	NSUInteger nCaturmasya;
	int nDST;
	gc_time date;
	// moon data
	gc_daytime moonrise;
	gc_daytime moonset;
	// astronomical data from astro-sub-layer
	gc_astro astrodata;
	// data for vaisnava calculations
	NSMutableArray * festivals;
	// fast data
	int nFastType;
	int nFeasting;
	// ekadasi data
	int nMhdType;
	NSString * ekadasi_vrata_name;
	BOOL ekadasi_parana;
	double eparana_time1;
	double eparana_time2;
	// sankranti data
	int sankranti_zodiac;
	gc_time sankranti_day;
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

@property(assign) NSUInteger nCaturmasya;
@property(assign) int nDST;
@property(assign) gc_time date;
// moon data
@property(assign) gc_daytime moonrise;
@property(assign) gc_daytime moonset;
// astronomical data from astro-sub-layer
@property(assign) gc_astro astrodata;
// data for vaisnava calculations
@property(assign) NSMutableArray * festivals;
// fast data
@property(assign) int nFastType;
@property(assign) int nFeasting;
// ekadasi data
@property(assign) int nMhdType;
@property(copy)   NSString * ekadasi_vrata_name;
@property(assign) BOOL ekadasi_parana;
@property(assign) double eparana_time1;
@property(assign) double eparana_time2;
// sankranti data
@property(assign) int sankranti_zodiac;
@property(assign) gc_time sankranti_day;
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
-(void)AddFestival:(NSString *)text;
-(void)AddFestival:(NSString *)text withClass:(int)nClass;
-(void)setMasa:(int)nMasa;
-(void)setGaurabda:(int)nGaurabdaYear;
-(void)addBiasToTimes:(double)hours;
-(NSString *)getHtmlDayBackground;
-(NSString *)stringWithFormat:(int)iFormat display:(gcalAppDisplaySettings *)disp source:(GCStrings *)gstr;
-(NSString *)getTithiNameComplete:(GCStrings *)gstr;

@end
