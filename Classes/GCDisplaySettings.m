//
//  gcalAppDisplaySettings.m
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCDisplaySettings.h"
#import "BalaCalAppDelegate.h"

@implementation GCDisplaySettings



-(id)init
{
	NSLog(@"app setts init");
	if ((self = [super init]) != nil)
	{
		[self setDefaultValues];
	}
	
	return self;
}

+(GCDisplaySettings *)sharedSettings
{
    return ((BalaCalAppDelegate *)[[UIApplication sharedApplication] delegate]).dispSettings;
}

-(void)setDefaultValues
{
    self.note_bf_today = NO;
    self.note_bf_tomorrow = YES;
    self.note_fd_today = NO;
    self.note_fd_tomorrow = YES;
    self.caturmasya = 1;
    self.t_core = YES;
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary * dv = [NSDictionary dictionaryWithObjectsAndKeys:@YES, @"note_fd_tomorrow",
                         @NO, @"note_fd_today",
                         @YES, @"note_bf_tomorrow",
                         @NO, @"note_bf_today",
                         @YES, @"t_brahma",
                         @YES, @"t_riseinfo",
                         @YES, @"t_sandhya",
                         @YES, @"t_sunrise",
                         @YES, @"t_core",
                         @1, @"caturmasya",
                         @NO, @"extendedFunctionality",
                         @0, @"viewMode",
                         @1.6, @"calendarspeed",
                         nil];
    [ud registerDefaults:dv];

	self.arun_tithi= NO;
	self.arunodaya = NO;
	self.sunrise   = NO;
	self.sunset    = NO;
	self.moonrise  = NO;
	self.moonset   = NO;
	self.festivals = YES;
	self.ksaya     = NO;
	self.sun_long  = NO;
	self.vriddhi   = YES;
	self.moon_long = NO;
	self.ayanamsa  = NO;
	self.julian    = NO;
	self.sankranti = YES;
	self.ekadasi   = YES;
	self.hdr_masa  = YES;
	self.hdr_month = NO;
	self.hide_empty= NO;
	self.change_masa = YES;
	self.cls0      = YES;
	self.cls1 = YES;
	self.cls2 = YES;
	self.cls3 = YES;
	self.cls4 = YES;
	self.cls5 = YES;
	self.cls6 = YES;
	self.t_sunrise = YES;
	self.t_sunset  = YES;
	self.t_noon    = YES;
	self.t_sandhya = NO;
	self.t_riseinfo = YES;
	self.t_brahma  = YES;
	self.noon = NO;
	self.change_dst = YES;
	self.naksatra = YES;
	self.yoga     = YES;
	self.fast     = YES;
	self.paksa    = YES;
	self.rasi     = NO;
	self.old_style = NO;
	self.childSylables = NO;
	self.first_weekday = 0;
	self.app_celebs = 3;
	self.ical_ekadasi = YES;
	self.ical_ekad_date = [NSDate date];
	self.ical_ekad_alarm = 1;
	self.ical_parana = YES;
	self.ical_parana_date = [NSDate date];
	self.ical_parana_alarm = 1;
	self.ical_changemasa = YES;
	self.ical_changedst = YES;
	self.ical_title = @"Gaurabda Calendar";
	
	self.h1textSize = @"14pt";
	self.h2textSize = @"12pt";
	self.h3textSize = @"10pt";
	self.bodyTextSize = @"9pt";
	self.h1color = @"white";
	self.h2color = @"white";
	self.h3color = @"white";
	self.bodyTextColor = @"white";
	self.specialTextColor = @"#ddffdd";
	self.bkgColor = @"#4A4A4A";
	
	self.locCity = @"Mayapur";
	self.locCountry = @"India";
	self.locLatitude = 23.4382755;
	self.locLongitude = 88.3928686;
	self.locTimeZone = @"Asia/Kolkata";
    
    NSMutableDictionary * md = [NSMutableDictionary new];
    
    [md setObject:[NSArray arrayWithObjects:@"Purnima", @"Pratipat (Default)", @"Ekadasi", @"Not observed", nil] forKey:@"caturmasya"];
    [md setObject:[NSArray arrayWithObjects:@"Today Screen (default)", @"Calendar View", nil]
           forKey:@"viewmodes"];
    
    self.namedValues = md;
}

-(IBAction)onSetDefault:(id)sender
{
	[self setDefaultValues];
}

-(BOOL)canShowFestivalClass:(int)n
{
	if (n < 0) return YES;
	switch (n) {
		case 0: return self.cls0;
		case 1: return self.cls1;
		case 2: return self.cls2;
		case 3: return self.cls3;
		case 4: return self.cls4;
		case 5: return self.cls5;
		case 6: return self.cls6;
		default: return YES;
	}
}

-(void)setHdr_type:(int)a
{
	switch(a)
	{
		case 0:
			self.hdr_month = NO;
			self.hdr_masa = YES;
			break;
		default:
			self.hdr_month = YES;
			self.hdr_masa = NO;
			break;
	}
}

-(int)hdr_type
{
	if (self.hdr_month) return 1;
	return 0;
}

-(BOOL)validateHdr_type:(id *)inValue error:(NSError **)outError
{
	return YES;
}

-(BOOL)validateCatur_type:(id *)inValue error:(NSError **)outError
{
	return YES;
}

-(void)writeToFile
{

    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:self.note_fd_tomorrow forKey:@"note_fd_tomorrow"];
    [ud setBool:self.note_fd_today forKey:@"note_fd_today"];
    [ud setBool:self.note_bf_tomorrow forKey:@"note_bf_tomorrow"];
    [ud setBool:self.note_bf_today forKey:@"note_bf_today"];
    [ud setBool:self.caturmasya forKey:@"caturmasya"];
    [ud setBool:self.t_core forKey:@"t_core"];
    [ud setBool:self.extendedFunctionality forKey:@"extendedFunctionality"];

    [ud setBool:self.arun_tithi forKey:@"arun_tithi"];
	[ud setBool:self.arunodaya forKey:@"arunodaya"];
	[ud setBool:self.sunrise forKey:@"sunrise"];
	[ud setBool:self.sunset forKey:@"sunset"];
	[ud setBool:self.moonrise forKey:@"moonrise"];
	[ud setBool:self.moonset forKey:@"moonset"];
	[ud setBool:self.festivals forKey:@"festivals"];
	[ud setBool:self.ksaya forKey:@"ksaya"];
	[ud setBool:self.sun_long forKey:@"sun_long"];
	[ud setBool:self.vriddhi forKey:@"vriddhi"];
	[ud setBool:self.moon_long forKey:@"moon_long"];
	[ud setBool:self.ayanamsa forKey:@"ayanamsa"];
	[ud setBool:self.julian forKey:@"julian"];
	[ud setBool:self.sankranti forKey:@"sankranti"];
	[ud setBool:self.ekadasi forKey:@"ekadasi"];
	[ud setBool:self.hdr_masa forKey:@"hdr_masa"];
	[ud setBool:self.hdr_month forKey:@"hdr_month"];
	[ud setBool:self.hide_empty forKey:@"hide_empty"];
	[ud setBool:self.change_masa forKey:@"change_masa"];
	[ud setBool:self.cls0 forKey:@"cls0"];
	[ud setBool:self.cls1 forKey:@"cls1"];
	[ud setBool:self.cls2 forKey:@"cls2"];
	[ud setBool:self.cls3 forKey:@"cls3"];
	[ud setBool:self.cls4 forKey:@"cls4"];
	[ud setBool:self.cls5 forKey:@"cls5"];
	[ud setBool:self.cls6 forKey:@"cls6"];
	[ud setBool:self.t_sunrise forKey:@"t_sunrise"];
	[ud setBool:self.t_sunset forKey:@"t_sunset"];
	[ud setBool:self.t_noon forKey:@"t_noon"];
	[ud setBool:self.t_sandhya forKey:@"t_sandhya"];
	[ud setBool:self.t_riseinfo forKey:@"t_riseinfo"];
	[ud setBool:self.t_brahma forKey:@"t_brahma"];
	[ud setBool:self.t_det_tithi forKey:@"t_det_tithi"];
	[ud setBool:self.t_det_naksatra forKey:@"t_det_naksatra"];
	[ud setBool:self.noon forKey:@"noon"];
	[ud setBool:self.change_dst forKey:@"change_dst"];
	[ud setBool:self.naksatra forKey:@"naksatra"];
	[ud setBool:self.yoga forKey:@"yoga"];
	[ud setBool:self.fast forKey:@"fast"];
	[ud setBool:self.paksa forKey:@"paksa"];
	[ud setBool:self.rasi forKey:@"rasi"];
	[ud setBool:self.old_style forKey:@"old_style"];
	[ud setBool:self.childSylables forKey:@"childSylables"];
	[ud setInteger:self.first_weekday forKey:@"first_weekday"];
	[ud setInteger:self.app_celebs forKey:@"app_celebs"];
	
	[ud setBool:self.ical_ekadasi forKey:@"ical_ekadasi"];
	[ud setObject:self.ical_ekad_date forKey:@"ical_ekad_date"];
	[ud setInteger:self.ical_ekad_alarm forKey:@"ical_ekad_alarm"];
	[ud setBool:self.ical_parana forKey:@"ical_parana"];
	[ud setObject:self.ical_parana_date forKey:@"ical_parana_date"];
	[ud setInteger:self.ical_parana_alarm forKey:@"ical_parana_alarm"];
	[ud setBool:self.ical_changedst forKey:@"ical_changedst"];
	[ud setBool:self.ical_changemasa forKey:@"ical_changemasa"];
	
	[ud setDouble:self.locLatitude forKey:@"loc_latitude"];
	[ud setDouble:self.locLongitude forKey:@"loc_longitude"];
	[ud setObject:self.locCity forKey:@"loc_city"];
	[ud setObject:self.locCountry forKey:@"loc_country"];
	[ud setObject:self.locTimeZone forKey:@"loc_timezone"];
	
    [ud synchronize];
}

-(void)readFromFile
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    self.note_fd_tomorrow = [ud boolForKey:@"note_fd_tomorrow"];
    self.note_bf_tomorrow = [ud boolForKey:@"note_bf_tomorrow"];
    self.note_fd_today = [ud boolForKey:@"note_fd_today"];
    self.note_bf_today = [ud boolForKey:@"note_bf_today"];
    self.t_core = [ud boolForKey:@"t_core"];
    self.caturmasya = [ud integerForKey:@"caturmasya"];
    self.extendedFunctionality = [ud boolForKey:@"extendedFunctionality"];
//    self.extendedFunctionality = YES;
    self.arun_tithi= [ud boolForKey:@"arun_tithi"];
    self.arunodaya = [ud boolForKey:@"arunodaya"];
    self.sunrise   = [ud boolForKey:@"sunrise"];
    self.sunset    = [ud boolForKey:@"sunset"];
    self.moonrise  = [ud boolForKey:@"moonrise"];
    self.moonset   = [ud boolForKey:@"moonset"];
    self.festivals = [ud boolForKey:@"festivals"];
    self.ksaya     = [ud boolForKey:@"ksaya"];
    self.sun_long  = [ud boolForKey:@"sun_long"];
    self.vriddhi   = [ud boolForKey:@"vriddhi"];
    self.moon_long = [ud boolForKey:@"moon_long"];
    self.ayanamsa  = [ud boolForKey:@"ayanamsa"];
    self.julian    = [ud boolForKey:@"julian"];
    self.sankranti = [ud boolForKey:@"sankranti"];
    self.ekadasi   = [ud boolForKey:@"ekadasi"];
    self.hdr_masa  = [ud boolForKey:@"hdr_masa"];
    self.hdr_month = [ud boolForKey:@"hdr_month"];
    self.hide_empty= [ud boolForKey:@"hide_empty"];
    self.change_masa = [ud boolForKey:@"change_masa"];
    self.cls0      = [ud boolForKey:@"cls0"];
    self.cls1 = [ud boolForKey:@"cls1"];
    self.cls2 = [ud boolForKey:@"cls2"];
    self.cls3 = [ud boolForKey:@"cls3"];
    self.cls4 = [ud boolForKey:@"cls4"];
    self.cls5 = [ud boolForKey:@"cls5"];
    self.cls6 = [ud boolForKey:@"cls6"];
    self.t_sunrise = [ud boolForKey:@"t_sunrise"];
    self.t_sunset  = [ud boolForKey:@"t_sunset"];
    self.t_noon    = [ud boolForKey:@"t_noon"];
    self.t_sandhya = [ud boolForKey:@"t_sandhya"];
    self.t_riseinfo = [ud boolForKey:@"t_riseinfo"];
    self.t_brahma  = [ud boolForKey:@"t_brahma"];
    self.t_det_tithi  = [ud boolForKey:@"t_det_tithi"];
    self.t_det_naksatra  = [ud boolForKey:@"t_det_naksatra"];
    self.noon = [ud boolForKey:@"noon"];
    self.change_dst = [ud boolForKey:@"change_dst"];
    self.naksatra = [ud boolForKey:@"naksatra"];
    self.yoga     = [ud boolForKey:@"yoga"];
    self.fast     = [ud boolForKey:@"fast"];
    self.paksa    = [ud boolForKey:@"paksa"];
    self.rasi     = [ud boolForKey:@"rasi"];
    self.old_style = [ud boolForKey:@"old_style"];
    self.childSylables = [ud boolForKey:@"childSylables"];
    self.first_weekday = [ud integerForKey:@"first_weekday"];
    self.app_celebs = [ud integerForKey:@"app_celebs"];

    self.ical_ekadasi = [ud boolForKey:@"ical_ekadasi"];
    self.ical_ekad_alarm = [ud integerForKey:@"ical_ekad_alarm"];
    self.ical_parana = [ud boolForKey:@"ical_parana"];
    self.ical_parana_alarm = [ud integerForKey:@"ical_parana_alarm"];
    self.ical_changedst = [ud boolForKey:@"ical_changedst"];
    self.ical_changemasa = [ud boolForKey:@"ical_changemasa"];
    
    self.locLatitude = [ud doubleForKey:@"loc_latitude"];
    self.locLongitude = [ud doubleForKey:@"loc_longitude"];
    self.locCity = [ud stringForKey:@"loc_city"];
    self.locCountry = [ud stringForKey:@"loc_country"];
    self.locTimeZone = [ud stringForKey:@"loc_timezone"];

}


-(NSString *)textForKey:(NSString *)key
{
    if ([key isEqualToString:@"caturmasya"])
    {
        return [self textForKey:key atIndex:self.caturmasya];
    }
    if ([key isEqualToString:@"viewmodes"])
    {
        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        return [self textForKey:@"viewmodes" atIndex:[ud integerForKey:@"viewMode"]];
    }

    NSLog(@"textForKey %@", key);
    return @"";
}


-(NSString *)textForKey:(NSString *)key atIndex:(NSInteger)index
{
    NSArray * a = [self.namedValues valueForKey:key];
    if (a == nil || index >= a.count)
        return @"";
    return [a objectAtIndex:index];
}


@end
