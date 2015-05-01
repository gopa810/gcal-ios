//
//  GcDay.m
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCCalendarDay.h"
#import "gc_dtypes.h"
#import "gc_func.h"
#import "GcDayFestival.h"
#import "GcResultCalendar.h"
#import "GCGregorianTime.h"
#import "GCCoreEvent.h"

@implementation GCCalendarDay


@synthesize nCaturmasya;
@synthesize nDST;
//@synthesize date;
// moon data
@synthesize moonrise;
@synthesize moonset;
// astronomical data from astro-sub-layer
@synthesize astrodata;
// fast data
@synthesize nFastType;
@synthesize nFeasting;
// ekadasi data
@synthesize nMhdType;
@synthesize isEkadasiParana;
@synthesize hrEkadasiParanaStart;
@synthesize hrEkadasiParanaEnd;
// sankranti data
@synthesize sankranti_zodiac;
@synthesize sankranti_day;
// ksata data
@synthesize was_ksaya;
@synthesize ksaya_day2;
@synthesize ksaya_day1;
@synthesize ksaya_time1;
@synthesize ksaya_time2;
// vriddhi data
@synthesize is_vriddhi;
// flag for validity
@synthesize fDateValid;
@synthesize fAstroValid;
@synthesize fVaisValid;	



-(id)init
{
	if ((self = [super init]) != nil)
	{
		fDateValid = false;
		fAstroValid = false;
		self.ekadasiVrataName = nil;
		nDST = 0;
		gc_daytime_SetValue(&moonrise, 0);
		gc_daytime_SetValue(&moonset, 0);
		[self Clear];
	}
	
	return self;
}

-(void)setVCTIME:(GCGregorianTime *)vc
{
	self.date = vc;
	fDateValid = YES;
}

-(void)setGCASTRO:(gc_astro)dd
{
	astrodata = dd;
	fAstroValid = YES;
}


-(void)Clear
{
	fVaisValid = false;
	// init
	self.festivals = [NSMutableArray new];

    nFastType = FAST_NULL;
	nFeasting = FEAST_NULL;
	nMhdType = EV_NULL;
	isEkadasiParana = false;
    
	self.ekadasiVrataName = [[NSMutableString alloc] init];
	
    hrEkadasiParanaStart = hrEkadasiParanaEnd = 0.0;
	sankranti_zodiac = -1;
	was_ksaya = false;
	ksaya_time1 = ksaya_time2 = 0.0;
	is_vriddhi = false;
	nCaturmasya = 0;
    self.coreEvents = [NSMutableArray new];
}


-(BOOL)GetNaksatraTimeRange:(gc_earth)earth timeFrom:(GCGregorianTime **)from timeTo:(GCGregorianTime **)to
{
	GCGregorianTime * start;
	
	start = [self.date copy];
	start.shour = astrodata.sun.sunrise_deg / 360 + earth.tzone/24.0;
	
	GetNextNaksatra(earth, start, to);
	GetPrevNaksatra(earth, start, from);
	
	return true;
}

-(BOOL)GetTithiTimeRange:(gc_earth)earth timeFrom:(GCGregorianTime **)from timeTo:(GCGregorianTime **)to
{
	GCGregorianTime *  start;
	
	start = [self.date copy];
	start.shour = astrodata.sun.sunrise_deg / 360 + earth.tzone/24.0;
	
	GetNextTithiStart(earth, start, to);
	GetPrevTithiStart(earth, start, from);
	
	return true;
	
}

-(GcDayFestival *)AddFestival:(NSString *)text
{
    GcDayFestival * festival = nil;
	if (text == nil) return nil;
	NSArray * comps = [text componentsSeparatedByString:@"#"];
	for(NSString * part in comps)
	{
		GcDayFestival * p = [[GcDayFestival alloc] init];
		if (p) {
			p.name = part;
			p.group = -1;
			[self AddFestivalRecord:p];
            if (festival == nil)
                festival = p;
		}
	}
    
    return festival;
}

-(void)addCoreEvent:(GCCoreEvent *)ce
{
    for(int i = 0; i < self.coreEvents.count; i++)
    {
        GCCoreEvent * item = [self .coreEvents objectAtIndex:i];
        if (item.seconds > ce.seconds)
        {
            [self.coreEvents insertObject:ce atIndex:i];
            return;
        }
    }
    
    [self.coreEvents addObject:ce];
}

-(GcDayFestival *)AddFestival:(NSString *)text withClass:(int)nClass
{
	if (text == nil) return nil;
	GcDayFestival * p = [[GcDayFestival alloc] init];
	if (p) {
		p.name = text;
		p.group = nClass;
		[self AddFestivalRecord:p];
	}
    
    return p;
}

-(void)AddSpecFestival:(int)nSpecialFestival withClass:(int)nClass source:(GcResultCalendar *)gstr
{
	[self AddFestivalRecord:[gstr GetSpecFestivalRecord:nSpecialFestival forClass:nClass]];
}

-(void)AddFestivalRecord:(GcDayFestival *)p
{
	if (p)
	{
		if (self.festivals == nil)
		{
			self.festivals = [NSMutableArray new];
		}
		[self.festivals addObject:p];
	}
}


-(NSString *)GetTextEP:(GCStrings *)gstr
{
	if (self.hrEkadasiParanaEnd >= 0.0)
	{
		return [NSString stringWithFormat:@"%@ %@ - %@ (%@)", [gstr string:60]
				, [gstr hoursToString:self.hrEkadasiParanaStart]
				, [gstr hoursToString:self.hrEkadasiParanaEnd]
				, [gstr GetDSTSignature:self.nDST]];
	}
	else if (self.hrEkadasiParanaStart >= 0.0)
	{
		return [NSString stringWithFormat:@"%@ %@ %@", [gstr string:61]
				, [gstr hoursToString:self.hrEkadasiParanaStart]
				, [gstr GetDSTSignature:self.nDST]];
	}
	else
	{
		return [NSString stringWithFormat:@"%@", [gstr string:62]];
	}
}

-(NSString *)getHtmlDayBackground
{
	if (self.nFastType == FAST_EKADASI)
		return @"#81624A";
	if (self.nFastType != 0)
		return @"#4A6262";
	return @"#626262";
}


-(NSString *)getTithiNameComplete:(GCStrings *)gstr
{
	NSString * s1 = nil;
	
	if ((astrodata.nTithi == 10) || (astrodata.nTithi == 25) 
		|| (astrodata.nTithi == 11) || (astrodata.nTithi == 26))
	{
		if (isEkadasiParana == false)
		{
			s1 = [NSString stringWithFormat:@"%@ %@",
				  [gstr GetTithiName:astrodata.nTithi],
				  (nMhdType == EV_NULL ? [gstr string:58] : [gstr string:59])];
		}
	}
	
	return s1 ? s1 : [gstr GetTithiName:astrodata.nTithi];
}

-(void)appendCalendarDayHeader:(NSMutableString *)dest format:(int)iFormat 
						source:(GCStrings *)gstr
					   display:(GCDisplaySettings *)disp
{
	//	static char * dow[] = {"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" };
	
	NSString * s1, * s2;

	s2 = [[gstr string:self.date.dayOfWeek] substringToIndex:2];
	
	if (astrodata.sun.longitude_deg < 0.0)
	{
		switch (iFormat) {
			case 0:
				[dest appendFormat:@"%@ %@  No sunset, no sunrise. No calendar info.\n", [self.date longDateString], s2];
				break;
			case 1:
				[dest appendFormat:@"\\par\\tab %@ %@  No sunset, no sunrise. No calendar info.\n", [self.date longDateString], s2];
				break;
			default:
				break;
		}
		return;
	}
	
	
	s1 = [self getTithiNameComplete:gstr];
	
	// before date
	switch (iFormat) {
		case 0:
			[dest appendFormat:@"%@ %@  ", [self.date longDateString], s2];
			[dest appendFormat:@"%-34@", s1];
			[dest appendFormat:@"%c ", (disp.paksa ? [gstr GetPaksaChar:(self.astrodata.nPaksa)] : ' ' )];
			if (disp.yoga) [dest appendFormat:@"%-10@", [gstr GetYogaName:(astrodata.nYoga)]];
			if (disp.naksatra) [dest appendFormat:@"-15%@", [gstr GetNaksatraName:(astrodata.nNaksatra)]];
			if (disp.fast) [dest appendFormat:@"%@", (nFastType == FAST_NULL ? @"   " : @" * ")];
			if (disp.rasi == 1) [dest appendFormat:@"%-15@", [gstr GetSankrantiName:(GetRasi(self.astrodata.moon.longitude_deg, self.astrodata.msAyanamsa))]];
			else if (disp.rasi == 2) [dest appendFormat:@"%-15@", [gstr GetSankrantiNameEn:(GetRasi(self.astrodata.moon.longitude_deg, self.astrodata.msAyanamsa))]];
			break;
		case 1:
			[dest appendFormat:@"\\par %@ %@  ", [self.date longDateString], s2];
			[dest appendFormat:@"\\tab %@", s1];
			[dest appendFormat:@"\\tab %c ", (disp.paksa ? [gstr GetPaksaChar:(astrodata.nPaksa)] : ' ' )];
			if (disp.yoga) [dest appendFormat:@"\\tab %@", [gstr GetYogaName:(astrodata.nYoga)]];
			if (disp.naksatra) [dest appendFormat:@"\\tab %@", [gstr GetNaksatraName:(astrodata.nNaksatra)]];
			if (disp.fast) [dest appendFormat:@"\\tab %@", (nFastType == FAST_NULL ? @"" : @"*")];
			if (disp.rasi == 1) [dest appendFormat:@"\\tab %@", [gstr GetSankrantiName:(GetRasi(self.astrodata.moon.longitude_deg, self.astrodata.msAyanamsa))]];
			else if (disp.rasi == 2) [dest appendFormat:@"\\tab %@", [gstr GetSankrantiNameEn:(GetRasi(self.astrodata.moon.longitude_deg, self.astrodata.msAyanamsa))]];
			break;
		default:
			break;
	}	
}

/* format:
 
0 - plain text
1 - RTF
2 - HTML single
3 - HTML table
4 - XML
 
 */

-(void)AddListText:(NSString *)str toString:(NSMutableString *)dest format:(int)iFormat
{
	switch (iFormat) {
		case 0:
			[dest appendFormat:@"                 %@\n", str];
			break;
		case 1:
			[dest appendFormat:@"\\par\\tab %@\n", str];
		case 2:
			[dest appendFormat:@"%@<br>\n", str];
		case 3:
			[dest appendFormat:@"%@<br>\n", str];
		case 4:
			[dest appendFormat:@"<daytext>%@</daytext>\n", str];
		default:
			break;
	}
}

-(void)appendBlockBegin:(NSString *)strBlock toString:(NSMutableString *)dest format:(int)iFormat
{
	switch (iFormat) {
		case 4:
			[dest appendFormat:@"<%@>\n", strBlock];
			break;
		default:
			break;
	}
}

-(void)appendBlockEnd:(NSString *)strBlock toString:(NSMutableString *)dest format:(int)iFormat
{
	switch (iFormat) {
		case 4:
			[dest appendFormat:@"</%@>\n", strBlock];
			break;
		default:
			break;
	}
}


-(NSString *)stringWithFormat:(int)iFormat display:(GCDisplaySettings *)disp source:(GCStrings *)gstr
{
	NSString * str1, * str2, * str3;
	//int nFestClass;
	
	NSMutableString * dayText = [[NSMutableString alloc] init];

	[self appendCalendarDayHeader:dayText format:iFormat source:gstr display:disp];
	
	if (self.astrodata.sun.longitude_deg < 0.0) return dayText;
	
	if (disp.ekadasi == YES && isEkadasiParana)
	{
		[self AddListText:[self GetTextEP:gstr] toString:dayText format:iFormat];
	}
	
	if (disp.festivals == YES && [self.festivals count] > 0)
	{
		[self appendBlockBegin:@"festivals" toString:dayText format:iFormat];
		for(GcDayFestival * gf in self.festivals)
		{
			if ([disp canShowFestivalClass:(gf.group)])
			{
				[self AddListText:(gf.name) toString:dayText format:iFormat];
			}
		}
		[self appendBlockEnd:@"festivals" toString:dayText format:iFormat];
	}
	
	if (disp.sankranti && sankranti_zodiac >= 0)
	{
		str1 = [NSString stringWithFormat:@"%@ %@ (%@ %@ %@ %d %@, %@ %@)"
										  , [gstr GetSankrantiName:sankranti_zodiac]
										  , [gstr string:56]
										  , [gstr string:111]
										  , [gstr GetSankrantiNameEn:sankranti_zodiac]
										  , [gstr string:852]
										  , sankranti_day.day
										  , [gstr GetMonthAbr:sankranti_day.month]
										  , [self.sankranti_day shortTimeString]
										  , [gstr GetDSTSignature:nDST]];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	
	if (disp.ksaya && self.was_ksaya)
	{
		GCGregorianTime * ksayaDate = self.date;
		
		// zaciatok ksaya tithi
		if (ksaya_day1 < 0.0)
        {
            ksayaDate = [ksayaDate previousDay];
        }
		str2 = [NSString stringWithFormat:@"%d %@, %@"
				, ksayaDate.day
				, [gstr GetMonthAbr:ksayaDate.month], [gstr hoursToString:ksaya_time1*24]];
		
		// end of ksaya tithi
		ksayaDate = self.date;
		if (ksaya_day2 < 0.0)
        {
            ksayaDate = [ksayaDate previousDay];
        }
		str3 = [NSString stringWithFormat:@"%d %@, %@"
				, ksayaDate.day
				, [gstr GetMonthAbr:ksayaDate.month], [gstr hoursToString:ksaya_time2*24]];
		
		// print info
		[self AddListText:[NSString stringWithFormat:@"%@ %@ %@ %@ %@ (%@)"
						   , [gstr string:89]
						   , [gstr string:850]
						   , str2
						   , [gstr string:851]
						   , str3
						   , [gstr GetDSTSignature:self.nDST]]
				toString:dayText 
				   format:iFormat];
	}
	
	if (disp.vriddhi && self.is_vriddhi)
		[self AddListText:[gstr string:90] toString:dayText format:iFormat];
	
	if (nCaturmasya & CMASYA_CONT_MASK)
	{
		int n = ((nCaturmasya & CMASYA_CONT_MASK) >> 22);
		[self AddListText:[gstr string:(111 + n)] toString:dayText format:iFormat];
	}
	
	if ((disp.caturmasya == 0) && (nCaturmasya & CMASYA_PURN_MASK))
	{
		[self AddListText:[NSString stringWithFormat:@"%@ [PURNIMA SYSTEM]"
						   , [gstr string:(107 + (nCaturmasya & CMASYA_PURN_MASK_DAY)
						  + ((nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2))]]
				 toString:dayText
				   format:iFormat];
		if ((nCaturmasya & CMASYA_PURN_MASK_DAY) == 0x1)
		{
			[self AddListText:[gstr string:(110 + ((nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2))]
					 toString:dayText
					   format:iFormat];
		}
	}
	
	if ((disp.caturmasya == 1) && (nCaturmasya & CMASYA_PRAT_MASK))
	{
		[self AddListText:[NSString stringWithFormat:@"%@ [PRATIPAT SYSTEM]"
						   , [gstr string:(107 + ((nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8)
										   + ((nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10))]]
				 toString:dayText
				   format:iFormat];
		if ((nCaturmasya & CMASYA_PRAT_MASK_DAY) == 0x100)
		{
			[self AddListText:[gstr string:(110 + ((nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10))]
					 toString:dayText
					   format:iFormat];
		}
	}
	
	if ((disp.caturmasya == 2) && (nCaturmasya & CMASYA_EKAD_MASK))
	{
		[self AddListText:[NSString stringWithFormat:@"%@ [EKADASI SYSTEM]"
						   , [gstr string:(107 + ((nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16)
										   + ((nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18))]]
				 toString:dayText
				   format:iFormat];
		if ((nCaturmasya & CMASYA_EKAD_MASK_DAY) == 0x10000)
		{
			[self AddListText:[gstr string:(110 + ((nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18))]
					 toString:dayText
					   format:iFormat];
		}
	}
	
	// tithi at arunodaya
	if (disp.arun_tithi)//m_dshow.m_tithi_arun)
	{
		str1 = [NSString stringWithFormat:@"%@: %@"
				, [gstr string:98]
				, [gstr GetTithiName:astrodata.nTithiArunodaya]];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	
	//"Arunodaya Time",//1
	if (disp.arunodaya)//m_dshow.m_arunodaya)
	{
		str1 = [NSString stringWithFormat:@"%@ %d:%02d (%@)"
				, [gstr string:99]
				, astrodata.sun.arunodaya.hour
				, astrodata.sun.arunodaya.minute
				, [gstr GetDSTSignature:self.nDST]];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	//"Sunrise Time",//2
	//"Sunset Time",//3
	if (disp.sunrise)//m_dshow.m_sunrise)
	{
		str1 = [NSString stringWithFormat:@"%@ %d:%02d (%@)", [gstr string:51], astrodata.sun.rise.hour
				   , astrodata.sun.rise.minute, [gstr GetDSTSignature:self.nDST]];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	if (disp.sunset)//m_dshow.m_sunset)
	{
		str1 = [NSString stringWithFormat:@"%@ %d:%02d (%@)", [gstr string:52], astrodata.sun.set.hour
				   , astrodata.sun.set.minute, [gstr GetDSTSignature:self.nDST]];
		[self AddListText:str1 toString:dayText format:iFormat];
		
	}
	//"Moonrise Time",//4
	if (disp.moonrise)
	{
		if (moonrise.hour < 0)
			str1 = [gstr string:136];
		else
		{
			str1 = [NSString stringWithFormat:@"%@ %2d:%02d (%@)", [gstr string:53], moonrise.hour
					   , moonrise.minute, [gstr GetDSTSignature:self.nDST]];
		}
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	//"Moonset Time",//5
	if (disp.moonset)
	{
		if (moonrise.hour < 0)
			str1 = [gstr string:137];
		else
		{
			str1 = [NSString stringWithFormat:@"%@ %2d:%02d (%@)", [gstr string:54], moonset.hour
					   , moonset.minute, [gstr GetDSTSignature:self.nDST]];
		}
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	///"Sun Longitude",//9
	if (disp.sun_long)//m_dshow.m_sun_long)
	{
		str1 = [NSString stringWithFormat:@"%@: %f (*)"
				, [gstr string:100], astrodata.sun.longitude_deg];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	//"Moon Longitude",//10
	if (disp.moon_long)//m_dshow.m_sun_long)
	{
		str1 = [NSString stringWithFormat:@"%@: %f (*)", [gstr string:101], astrodata.moon.longitude_deg];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	//"Ayanamsha value",//11
	if (disp.ayanamsa)//m_dshow.m_sun_long)
	{
		str1 = [NSString stringWithFormat:@"%@ %f (%@) (*)", [gstr string:102], astrodata.msAyanamsa, GetAyanamsaName(GetAyanamsaType())];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	//"Julian Day",//12
	if (disp.julian)//m_dshow.m_sun_long)
	{
		str1 = [NSString stringWithFormat:@"%@ %f (*)", [gstr string:103], astrodata.jdate];
		[self AddListText:str1 toString:dayText format:iFormat];
	}
	
	return dayText;
}

-(void)setMasa:(int)nMasa
{
	astrodata.nMasa = nMasa;
}

-(void)setGaurabda:(int)nGaurabdaYear
{
	astrodata.nGaurabdaYear = nGaurabdaYear;
}

-(void)addBiasToTimes:(double)hours
{
	int addHours = nDST ? (int)hours : 0;
    
	if (hrEkadasiParanaStart > 0.0)
	{
		self.hrEkadasiParanaStart += addHours;
	}
	
	if (hrEkadasiParanaEnd > 0.0)
	{
		self.hrEkadasiParanaEnd += addHours;
	}
	
	if (astrodata.sun.longitude_deg > 0.0)
	{
		astrodata.sun.rise.hour += addHours;
		astrodata.sun.set.hour += addHours;
		astrodata.sun.noon.hour += addHours;
		astrodata.sun.arunodaya.hour += addHours;
	}
    
    if (nDST)
    {
        for (GCCoreEvent * ce in self.coreEvents) {
            if (ce.daylightSavingTime == NO)
            {
                ce.seconds += hours * 3600;
                ce.daylightSavingTime = YES;
            }
        }
        
        GCCoreEvent * last = [self.coreEvents lastObject];
        while([last seconds] > 86400)
        {
            [self.nextDay addCoreEvent:last];
            [self.coreEvents removeLastObject];
            last = [self.coreEvents lastObject];
        }
    }
}

-(NSString *)resolveSpecialEkadasiMessage
{
    NSString * msgSuitable = @"(suitable for fasting)";
    NSString * msgNonSuitable = @"(not suitable for fasting)";
    if (self.astrodata.nTithi == 10 || self.astrodata.nTithi == 25)
    {
        return (self.nFastType == FAST_EKADASI) ? msgSuitable : msgNonSuitable
        ;
    }
    else if ((self.astrodata.nTithi == 11 || self.astrodata.nTithi == 26) && self.nFastType == FAST_EKADASI)
    {
        return msgSuitable;
    }
    
    return @"";
}

-(NSString *)shortSunriseTime
{
    return [NSString stringWithFormat:@"%02d:%02d", self.astrodata.sun.rise.hour, self.astrodata.sun.rise.minute];
}

-(NSString *)shortNoonTime
{
    return [NSString stringWithFormat:@"%02d:%02d", self.astrodata.sun.noon.hour, self.astrodata.sun.noon.minute];
}

-(NSString *)shortSunsetTime
{
    return [NSString stringWithFormat:@"%02d:%02d", self.astrodata.sun.set.hour, self.astrodata.sun.set.minute];
}

@end
