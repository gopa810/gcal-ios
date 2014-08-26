//
//  gcalAppDisplaySettings.h
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface gcalAppDisplaySettings : NSObject {
	BOOL arun_tithi;
	BOOL arunodaya;
	BOOL sunrise;
	BOOL sunset;
	BOOL moonrise;
	BOOL moonset;
	BOOL festivals;
	BOOL ksaya;
	BOOL vriddhi;
	BOOL sun_long;
	BOOL moon_long;
	BOOL ayanamsa;
	BOOL julian;
	BOOL catur_purn;
	BOOL catur_prat;
	BOOL catur_ekad;
	BOOL sankranti;
	BOOL ekadasi;
	BOOL hdr_masa;
	BOOL hdr_month;
	BOOL hide_empty;
	BOOL change_masa;
	BOOL cls0;
	BOOL cls1;
	BOOL cls2;
	BOOL cls3;
	BOOL cls4;
	BOOL cls5;
	BOOL cls6;
	BOOL t_sunrise;
	BOOL t_sunset;
	BOOL t_noon;
	BOOL t_sandhya;
	BOOL t_riseinfo;
	BOOL t_brahma;
	BOOL t_det_tithi;
	BOOL t_det_naksatra;
	BOOL noon;
	BOOL change_dst;
	BOOL naksatra;
	BOOL yoga;
	BOOL fast;
	BOOL paksa;
	BOOL rasi;
	BOOL old_style; 
	int  first_weekday;
	
	// text sizes for RTF
	int  textSize;
	int  textHeader2Size;
	int  textNoteSize;
	int  textHeaderSize;
	
	// settings for calculations
	int  ayanamsaType;
	int  sankrantiType;
	
	BOOL  childSylables;
	int   app_celebs;
	
	NSString * h1textSize;
	NSString * h2textSize;
	NSString * h3textSize;
	NSString * bodyTextSize;
	NSString * bodyTextColor;
	NSString * h1color;
	NSString * h2color;
	NSString * h3color;
	NSString * specialTextColor;
	
	NSString * locCity;
	NSString * locCountry;
	double locLatitude;
	double locLongitude;
	NSString * locTimeZone;
	
	
	// settings for iCal export
	NSString * ical_title;
	BOOL ical_ekadasi;
	NSUInteger ical_ekad_alarm;
	NSDate * ical_ekad_date;
	BOOL ical_parana;
	NSUInteger ical_parana_alarm;
	NSDate * ical_parana_date;
	BOOL ical_changemasa;
	BOOL ical_changedst;
	
}

@property(assign) BOOL arun_tithi;
@property(assign) BOOL arunodaya;
@property(assign) BOOL sunrise;
@property(assign) BOOL sunset;
@property(assign) BOOL moonrise;
@property(assign) BOOL moonset;
@property(assign) BOOL festivals;
@property(assign) BOOL ksaya;
@property(assign) BOOL vriddhi;
@property(assign) BOOL sun_long;
@property(assign) BOOL moon_long;
@property(assign) BOOL ayanamsa;
@property(assign) BOOL julian;
@property(assign) BOOL catur_purn;
@property(assign) BOOL catur_prat;
@property(assign) BOOL catur_ekad;
@property(assign) BOOL sankranti;
@property(assign) BOOL ekadasi;
@property(assign) BOOL hdr_masa;
@property(assign) BOOL hdr_month;
@property(assign) BOOL hide_empty;
@property(assign) BOOL change_masa;
@property(assign) BOOL cls0;
@property(assign) BOOL cls1;
@property(assign) BOOL cls2;
@property(assign) BOOL cls3;
@property(assign) BOOL cls4;
@property(assign) BOOL cls5;
@property(assign) BOOL cls6;
@property(assign) BOOL t_sunrise;
@property(assign) BOOL t_sunset;
@property(assign) BOOL t_noon;
@property(assign) BOOL t_sandhya;
@property(assign) BOOL t_riseinfo;
@property(assign) BOOL t_brahma;
@property(assign) BOOL t_det_tithi;
@property(assign) BOOL t_det_naksatra;
@property(assign) BOOL noon;
@property(assign) BOOL change_dst;
@property(assign) BOOL naksatra;
@property(assign) BOOL yoga;
@property(assign) BOOL fast;
@property(assign) BOOL paksa;
@property(assign) BOOL rasi;
@property(assign) BOOL old_style; 
@property(assign) int  first_weekday;
@property(nonatomic,retain) NSString * h1textSize;
@property(nonatomic,retain) NSString * h2textSize;
@property(nonatomic,retain) NSString * h3textSize;
@property(nonatomic,retain) NSString * bodyTextSize;
@property(nonatomic,retain) NSString * bkgColor;
@property(nonatomic,retain) NSString * h1color;
@property(nonatomic,retain) NSString * h2color;
@property(nonatomic,retain) NSString * h3color;
@property(nonatomic,retain) NSString * bodyTextColor;
@property(nonatomic,retain) NSString * specialTextColor;

// location
@property(assign) double locLatitude;
@property(assign) double locLongitude;
@property(nonatomic,retain) NSString * locCity;
@property(nonatomic,retain) NSString * locCountry;
@property(nonatomic,retain) NSString * locTimeZone;

// text sizes for RTF
@property(assign) int  textSize;
@property(assign) int  textHeader2Size;
@property(assign) int  textNoteSize;
@property(assign) int  textHeaderSize;

// settings for calculations
@property(assign) int  ayanamsaType;
@property(assign) int  sankrantiType;

@property(assign) BOOL  childSylables;
@property(assign) int   app_celebs;


// settings for iCal export
@property(retain,readwrite) NSString * ical_title;
@property(assign) BOOL ical_ekadasi;
@property(assign) NSUInteger ical_ekad_alarm;
@property(retain,readwrite) NSDate * ical_ekad_date;
@property(assign) BOOL ical_parana;
@property(assign) NSUInteger ical_parana_alarm;
@property(retain,readwrite) NSDate * ical_parana_date;
@property(assign) BOOL ical_changemasa;
@property(assign) BOOL ical_changedst;



-(BOOL)canShowFestivalClass:(int)n;
-(void)readFromFile:(NSString *)path;
-(void)writeToFile:(NSString *)path atomically:(BOOL)batom;
-(IBAction)onSetDefault:(id)sender;
-(void)setDefaultValues;



@end
