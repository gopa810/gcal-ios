//
//  gcalAppDisplaySettings.m
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "gcalAppDisplaySettings.h"


@implementation gcalAppDisplaySettings

@synthesize arun_tithi;
@synthesize arunodaya;
@synthesize sunrise;
@synthesize sunset;
@synthesize moonrise;
@synthesize moonset;
@synthesize festivals;
@synthesize ksaya;
@synthesize vriddhi;
@synthesize sun_long;
@synthesize moon_long;
@synthesize ayanamsa;
@synthesize julian;
@synthesize catur_purn;
@synthesize catur_prat;
@synthesize catur_ekad;
@synthesize sankranti;
@synthesize ekadasi;
@synthesize hdr_masa;
@synthesize hdr_month;
@synthesize hide_empty;
@synthesize change_masa;
@synthesize cls0;
@synthesize cls1;
@synthesize cls2;
@synthesize cls3;
@synthesize cls4;
@synthesize cls5;
@synthesize cls6;
@synthesize t_sunrise;
@synthesize t_sunset;
@synthesize t_noon;
@synthesize t_sandhya;
@synthesize t_riseinfo;
@synthesize t_brahma;
@synthesize t_det_tithi;
@synthesize t_det_naksatra;
@synthesize noon;
@synthesize change_dst;
@synthesize naksatra;
@synthesize yoga;
@synthesize fast;
@synthesize paksa;
@synthesize rasi;
@synthesize first_weekday;
@synthesize old_style;
@synthesize ical_title;
@synthesize ical_ekadasi;
@synthesize ical_ekad_alarm;
@synthesize ical_ekad_date;
@synthesize ical_parana;
@synthesize ical_parana_alarm;
@synthesize ical_parana_date;
@synthesize ical_changemasa;
@synthesize ical_changedst;

@synthesize h1textSize;
@synthesize h2textSize;
@synthesize h3textSize;
@synthesize bodyTextSize;
@synthesize bodyTextColor;
@synthesize h1color;
@synthesize h2color;
@synthesize h3color;
@synthesize specialTextColor;
@synthesize bkgColor;

//loction
@synthesize locCity;
@synthesize locCountry;
@synthesize locTimeZone;
@synthesize locLatitude;
@synthesize locLongitude;

// text sizes for RTF
@synthesize textSize;
@synthesize textHeader2Size;
@synthesize textNoteSize;
@synthesize textHeaderSize;

// settings for calculations
@synthesize ayanamsaType;
@synthesize sankrantiType;

@synthesize childSylables;
@synthesize app_celebs;

-(id)init
{
	NSLog(@"app setts init");
	if ((self = [super init]) != nil)
	{
		[self setDefaultValues];
	}
	
	return self;
}

-(void)setDefaultValues
{
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
	self.catur_purn = NO;
	self.catur_prat = YES;
	self.catur_ekad = NO;
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
			hdr_month = NO;
			hdr_masa = YES;
			break;
		default:
			hdr_month = YES;
			hdr_masa = NO;
			break;
	}
}

-(int)hdr_type
{
	if (hdr_month) return 1;
	return 0;
}

-(void)setCatur_type:(int)a
{
	if (a == 0) {
		catur_purn = YES;
		catur_prat = NO;
		catur_ekad = NO;
	}
	else if (a == 1) {
		catur_purn = NO;
		catur_prat = YES;
		catur_ekad = NO;
	}
	else {
		catur_purn = NO;
		catur_prat = NO;
		catur_ekad = YES;
	}
}

-(int)catur_type
{
	if (catur_purn) return 0;
	if (catur_prat) return 1;
	return 2;
}

-(BOOL)validateHdr_type:(id *)inValue error:(NSError **)outError
{
	return YES;
}

-(BOOL)validateCatur_type:(id *)inValue error:(NSError **)outError
{
	return YES;
}

-(void)writeToFile:(NSString *)path atomically:(BOOL)batom
{
	NSLog(@"Writing settings to file %@\n", path);
	NSMutableData * data;
	NSKeyedArchiver * coder;
	
	data = [NSMutableData data];
	coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[coder encodeBool:self.arun_tithi forKey:@"arun_tithi"];
	[coder encodeBool:self.arunodaya forKey:@"arunodaya"];
	[coder encodeBool:self.sunrise forKey:@"sunrise"];
	[coder encodeBool:self.sunset forKey:@"sunset"];
	[coder encodeBool:self.moonrise forKey:@"moonrise"];
	[coder encodeBool:self.moonset forKey:@"moonset"];
	[coder encodeBool:self.festivals forKey:@"festivals"];
	[coder encodeBool:self.ksaya forKey:@"ksaya"];
	[coder encodeBool:self.sun_long forKey:@"sun_long"];
	[coder encodeBool:self.vriddhi forKey:@"vriddhi"];
	[coder encodeBool:self.moon_long forKey:@"moon_long"];
	[coder encodeBool:self.ayanamsa forKey:@"ayanamsa"];
	[coder encodeBool:self.julian forKey:@"julian"];
	[coder encodeBool:self.catur_purn forKey:@"catur_purn"];
	[coder encodeBool:self.catur_prat forKey:@"catur_prat"];
	[coder encodeBool:self.catur_ekad forKey:@"catur_ekad"];
	[coder encodeBool:self.sankranti forKey:@"sankranti"];
	[coder encodeBool:self.ekadasi forKey:@"ekadasi"];
	[coder encodeBool:self.hdr_masa forKey:@"hdr_masa"];
	[coder encodeBool:self.hdr_month forKey:@"hdr_month"];
	[coder encodeBool:self.hide_empty forKey:@"hide_empty"];
	[coder encodeBool:self.change_masa forKey:@"change_masa"];
	[coder encodeBool:self.cls0 forKey:@"cls0"];
	[coder encodeBool:self.cls1 forKey:@"cls1"];
	[coder encodeBool:self.cls2 forKey:@"cls2"];
	[coder encodeBool:self.cls3 forKey:@"cls3"];
	[coder encodeBool:self.cls4 forKey:@"cls4"];
	[coder encodeBool:self.cls5 forKey:@"cls5"];
	[coder encodeBool:self.cls6 forKey:@"cls6"];
	[coder encodeBool:self.t_sunrise forKey:@"t_sunrise"];
	[coder encodeBool:self.t_sunset forKey:@"t_sunset"];
	[coder encodeBool:self.t_noon forKey:@"t_noon"];
	[coder encodeBool:self.t_sandhya forKey:@"t_sandhya"];
	[coder encodeBool:self.t_riseinfo forKey:@"t_riseinfo"];
	[coder encodeBool:self.t_brahma forKey:@"t_brahma"];
	[coder encodeBool:self.t_det_tithi forKey:@"t_det_tithi"];
	[coder encodeBool:self.t_det_naksatra forKey:@"t_det_naksatra"];
	[coder encodeBool:self.noon forKey:@"noon"];
	[coder encodeBool:self.change_dst forKey:@"change_dst"];
	[coder encodeBool:self.naksatra forKey:@"naksatra"];
	[coder encodeBool:self.yoga forKey:@"yoga"];
	[coder encodeBool:self.fast forKey:@"fast"];
	[coder encodeBool:self.paksa forKey:@"paksa"];
	[coder encodeBool:self.rasi forKey:@"rasi"];
	[coder encodeBool:self.old_style forKey:@"old_style"];
	[coder encodeBool:self.childSylables forKey:@"childSylables"];
	[coder encodeInt:self.first_weekday forKey:@"first_weekday"];
	[coder encodeInt:self.app_celebs forKey:@"app_celebs"];
	
	[coder encodeBool:self.ical_ekadasi forKey:@"ical_ekadasi"];
	[coder encodeObject:self.ical_ekad_date forKey:@"ical_ekad_date"];
	[coder encodeInt:self.ical_ekad_alarm forKey:@"ical_ekad_alarm"];
	[coder encodeBool:self.ical_parana forKey:@"ical_parana"];
	[coder encodeObject:self.ical_parana_date forKey:@"ical_parana_date"];
	[coder encodeInt:self.ical_parana_alarm forKey:@"ical_parana_alarm"];
	[coder encodeBool:self.ical_changedst forKey:@"ical_changedst"];
	[coder encodeBool:self.ical_changemasa forKey:@"ical_changemasa"];
	
	[coder encodeDouble:self.locLatitude forKey:@"loc_latitude"];
	[coder encodeDouble:self.locLongitude forKey:@"loc_longitude"];
	[coder encodeObject:self.locCity forKey:@"loc_city"];
	[coder encodeObject:self.locCountry forKey:@"loc_country"];
	[coder encodeObject:self.locTimeZone forKey:@"loc_timezone"];
	
	[coder finishEncoding];
	[data writeToFile:path atomically:batom];
	[coder release];
}

-(void)readFromFile:(NSString *)path
{
	NSData * data;
	NSKeyedUnarchiver * coder;
	NSLog(@"Reading settings from file %@\n", path);
	
	data = [NSData dataWithContentsOfFile:path];
	if (data != nil)
	{
		coder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	//	self = [super initWithCoder:coder];
		self.arun_tithi= [coder decodeBoolForKey:@"arun_tithi"];
		self.arunodaya = [coder decodeBoolForKey:@"arunodaya"];
		self.sunrise   = [coder decodeBoolForKey:@"sunrise"];
		self.sunset    = [coder decodeBoolForKey:@"sunset"];
		self.moonrise  = [coder decodeBoolForKey:@"moonrise"];
		self.moonset   = [coder decodeBoolForKey:@"moonset"];
		self.festivals = [coder decodeBoolForKey:@"festivals"];
		self.ksaya     = [coder decodeBoolForKey:@"ksaya"];
		self.sun_long  = [coder decodeBoolForKey:@"sun_long"];
		self.vriddhi   = [coder decodeBoolForKey:@"vriddhi"];
		self.moon_long = [coder decodeBoolForKey:@"moon_long"];
		self.ayanamsa  = [coder decodeBoolForKey:@"ayanamsa"];
		self.julian    = [coder decodeBoolForKey:@"julian"];
		self.catur_purn = [coder decodeBoolForKey:@"catur_purn"];
		self.catur_prat = [coder decodeBoolForKey:@"catur_prat"];
		self.catur_ekad = [coder decodeBoolForKey:@"catur_ekad"];
		self.sankranti = [coder decodeBoolForKey:@"sankranti"];
		self.ekadasi   = [coder decodeBoolForKey:@"ekadasi"];
		self.hdr_masa  = [coder decodeBoolForKey:@"hdr_masa"];
		self.hdr_month = [coder decodeBoolForKey:@"hdr_month"];
		self.hide_empty= [coder decodeBoolForKey:@"hide_empty"];
		self.change_masa = [coder decodeBoolForKey:@"change_masa"];
		self.cls0      = [coder decodeBoolForKey:@"cls0"];
		self.cls1 = [coder decodeBoolForKey:@"cls1"];
		self.cls2 = [coder decodeBoolForKey:@"cls2"];
		self.cls3 = [coder decodeBoolForKey:@"cls3"];
		self.cls4 = [coder decodeBoolForKey:@"cls4"];
		self.cls5 = [coder decodeBoolForKey:@"cls5"];
		self.cls6 = [coder decodeBoolForKey:@"cls6"];
		self.t_sunrise = [coder decodeBoolForKey:@"t_sunrise"];
		self.t_sunset  = [coder decodeBoolForKey:@"t_sunset"];
		self.t_noon    = [coder decodeBoolForKey:@"t_noon"];
		self.t_sandhya = [coder decodeBoolForKey:@"t_sandhya"];
		self.t_riseinfo = [coder decodeBoolForKey:@"t_riseinfo"];
		self.t_brahma  = [coder decodeBoolForKey:@"t_brahma"];
		self.t_det_tithi  = [coder decodeBoolForKey:@"t_det_tithi"];
		self.t_det_naksatra  = [coder decodeBoolForKey:@"t_det_naksatra"];
		self.noon = [coder decodeBoolForKey:@"noon"];
		self.change_dst = [coder decodeBoolForKey:@"change_dst"];
		self.naksatra = [coder decodeBoolForKey:@"naksatra"];
		self.yoga     = [coder decodeBoolForKey:@"yoga"];
		self.fast     = [coder decodeBoolForKey:@"fast"];
		self.paksa    = [coder decodeBoolForKey:@"paksa"];
		self.rasi     = [coder decodeBoolForKey:@"rasi"];
		self.old_style = [coder decodeBoolForKey:@"old_style"];
		self.childSylables = [coder decodeBoolForKey:@"childSylables"];
		self.first_weekday = [coder decodeIntForKey:@"first_weekday"];
		self.app_celebs = [coder decodeIntForKey:@"app_celebs"];

		self.ical_ekadasi = [coder decodeBoolForKey:@"ical_ekadasi"];
		self.ical_ekad_date = [coder decodeObjectForKey:@"ical_ekad_date"];
		self.ical_ekad_alarm = [coder decodeIntForKey:@"ical_ekad_alarm"];
		self.ical_parana = [coder decodeBoolForKey:@"ical_parana"];
		self.ical_parana_date = [coder decodeObjectForKey:@"ical_parana_date"];
		self.ical_parana_alarm = [coder decodeIntForKey:@"ical_parana_alarm"];
		self.ical_changedst = [coder decodeBoolForKey:@"ical_changedst"];
		self.ical_changemasa = [coder decodeBoolForKey:@"ical_changemasa"];
		
		self.locLatitude = [coder decodeDoubleForKey:@"loc_latitude"];
		self.locLongitude = [coder decodeDoubleForKey:@"loc_longitude"];
		self.locCity = [coder decodeObjectForKey:@"loc_city"];
		self.locCountry = [coder decodeObjectForKey:@"loc_country"];
		self.locTimeZone = [coder decodeObjectForKey:@"loc_timezone"];
		[coder finishDecoding];
		[coder release];
	}
	

}



@end
