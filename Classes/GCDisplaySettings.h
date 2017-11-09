//
//  gcalAppDisplaySettings.h
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GCDisplaySettings : NSObject {
	
}

@property (assign) BOOL extendedFunctionality;
@property (assign) BOOL t_core;
@property (assign) BOOL note_fd_tomorrow;
@property (assign) BOOL note_fd_today;
@property (assign) BOOL note_bf_tomorrow;
@property (assign) BOOL note_bf_today;
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
@property(assign) int caturmasya;
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
@property(assign) int rasi;
@property(assign) BOOL old_style; 
@property(assign) int  first_weekday;
@property(nonatomic,strong) NSString * h1textSize;
@property(nonatomic,strong) NSString * h2textSize;
@property(nonatomic,strong) NSString * h3textSize;
@property(nonatomic,strong) NSString * bodyTextSize;
@property(nonatomic,strong) NSString * bkgColor;
@property(nonatomic,strong) NSString * h1color;
@property(nonatomic,strong) NSString * h2color;
@property(nonatomic,strong) NSString * h3color;
@property(nonatomic,strong) NSString * bodyTextColor;
@property(nonatomic,strong) NSString * specialTextColor;
@property (strong) NSMutableDictionary * namedValues;

@property NSString * fileName;

// location
@property(assign) double locLatitude;
@property(assign) double locLongitude;
@property(nonatomic,strong) NSString * locCity;
@property(nonatomic,strong) NSString * locCountry;
@property(nonatomic,strong) NSString * locTimeZone;

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
@property(strong,readwrite) NSString * ical_title;
@property(assign) BOOL ical_ekadasi;
@property(assign) NSUInteger ical_ekad_alarm;
@property(strong,readwrite) NSDate * ical_ekad_date;
@property(assign) BOOL ical_parana;
@property(assign) NSUInteger ical_parana_alarm;
@property(strong,readwrite) NSDate * ical_parana_date;
@property(assign) BOOL ical_changemasa;
@property(assign) BOOL ical_changedst;


+(GCDisplaySettings *)sharedSettings;
-(BOOL)canShowFestivalClass:(int)n;
-(void)readFromFile;
-(void)writeToFile;
-(IBAction)onSetDefault:(id)sender;
-(void)setDefaultValues;
-(NSString *)textForKey:(NSString *)key;
-(NSString *)textForKey:(NSString *)key atIndex:(NSInteger)index;

@end
