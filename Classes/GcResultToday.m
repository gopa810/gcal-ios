//
//  GcResultToday.m
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GcResultToday.h"
#import "gc_func.h"
#import "GcDayFestival.h"

@implementation GcResultToday

@synthesize current;

-(void)recalc
{
	[self calcDate:self.current];
}

-(gcalAppDisplaySettings *)disp
{
	return disp;
}

-(void)calcDate:(gc_time)vc
{
	gc_time_InitWeekDay(&vc);
	self.current = vc;
	gc_time vc2 = vc;
	
	gc_time_sub_days(&vc2, 9);
	[calend CalculateCalendar:vc2 count:19];
		
}

-(void)setDay:(gc_time)vc
{
	if ([calend FindDate:vc] >= 0)
	{
		gc_time_InitWeekDay(&vc);
		self.current = vc;
	}
	else
	{
		[self calcDate:vc];
	}
}

-(void)setNextDay
{
	gc_time vc2 = self.current;
	gc_time_add_days(&vc2, 1);
	
	if ([calend FindDate:vc2] < 0) 
	{
		[self calcDate:vc2];
	}
	else {
		gc_time_InitWeekDay(&vc2);
		self.current = vc2;
	}

}

-(void)setPrevDay
{
	gc_time vc2 = self.current;
	gc_time_sub_days(&vc2, 1);
	
	if ([calend FindDate:vc2] < 0) 
	{
		[self calcDate:vc2];
	}
	else {
		gc_time_InitWeekDay(&vc2);
		self.current = vc2;
	}
}

-(NSString *)formatTodayText
{
	NSString * str2, * str3;

	NSMutableString * str = [[[NSMutableString alloc] init] autorelease];
	
	//int nFestClass;
	int i = [calend FindDate:self.current];
	if (i < 0) return @"";
	
	GcDay * p = [calend GetDay:i];
	if (!p) return @"";
	
	[str appendFormat:@"%@ [%@]\r\n\r\n[%@]\r\n  %@, %@ %@\r\n  %@ %@, %d Gaurabda\r\n\r\n",
				[myLocation city], [myLocation country], [gstr dateToString:self.current],
				[gstr GetTithiName:p.astrodata.nTithi], [gstr GetPaksaName:p.astrodata.nPaksa], 
				[gstr string:20], 
				[gstr GetMasaName:p.astrodata.nMasa], [gstr string:22], p.astrodata.nGaurabdaYear];
	
	if (p.ekadasi_parana)
	{
		[str appendFormat:@"%@\n", [p GetTextEP:gstr]];
	}
	
	// adding mahadvadasi
	// adding spec festivals
	
	if (p.festivals && [p.festivals count] > 0)
	{
		for(GcDayFestival * pdf in p.festivals)
		{
			if (pdf.group < 0 || [disp canShowFestivalClass:pdf.group])
			{
				[str appendFormat:@"   %@\n", pdf.name];
			}
		}
	}
	
	[str appendFormat:@"\n"];
	
	if (disp.sankranti && p.sankranti_zodiac >= 0)
	{
		//double h1, m1;
		//m1 = modf(p->sankranti_day.shour*24, &h1);
		[str appendFormat:@"---------- %@ %@ (%@ %@ %@ %d %@, %@ %@) ----------"
					, [gstr GetSankrantiName:p.sankranti_zodiac]
					, [gstr string:56]
					, [gstr string:111]
					, [gstr GetSankrantiNameEn:p.sankranti_zodiac]
					, [gstr string:852]
					, p.sankranti_day.day, [gstr GetMonthAbr:p.sankranti_day.month]
					, [gstr timeShortToString:p.sankranti_day]
					, [gstr GetDSTSignature:p.nDST]];
	}
	
	if (disp.ksaya && p.was_ksaya)//(m_dshow.m_info_ksaya) && (pvd->was_ksaya))
	{
		gc_time dd;
		dd = p.date;
		if (p.ksaya_day1 < 0.0) GetPrevDay(&dd);
		str2 = [NSString stringWithFormat:@"%d %@, %@", dd.day
				, [gstr GetMonthAbr:dd.month]
				, [gstr hoursToString:p.ksaya_time1*24]];
		
		//				if (pvd->ksaya_time2 < 0.0)
		//					m = modf(fabs(1.0 + pvd->ksaya_time2)*24, &h);
		//				else
		dd = p.date;
		if (p.ksaya_day2 < 0.0)
			GetPrevDay(&dd);
		str3 = [NSString stringWithFormat:@"%d %@, %@", dd.day
				, [gstr GetMonthAbr:dd.month]
				, [gstr hoursToString:p.ksaya_time2*24]];
		
		[str appendFormat:@"%@ %@ %@ %@ %@ (%@)\n"
			, [gstr string:89], [gstr string:850]
			, str2, [gstr string:851], str3, [gstr GetDSTSignature:p.nDST]];
	}
	// adding fasting
	if (disp.vriddhi && p.is_vriddhi)
	{
		[str appendFormat:@"%@", [gstr string:90]];
		[str appendFormat:@"\n"];
	}
	
	
	if (p.nCaturmasya & CMASYA_PURN_MASK)
	{
		[str appendFormat:@"%@ [PURNIMA SYSTEM]\n"
					, [gstr string:107 + (p.nCaturmasya & CMASYA_PURN_MASK_DAY)
						   + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]];
		if ((p.nCaturmasya & CMASYA_PURN_MASK_DAY) == 0x1)
		{
			[str appendFormat:@"%@", [gstr string:110 + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]];
		}
	}
	
	if (p.nCaturmasya & CMASYA_PRAT_MASK)
	{
		[str appendFormat:@"%@ [PRATIPAT SYSTEM]\n"
					, [gstr string:107 + ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8)
						   + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]];
		if ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) == 0x100)
		{
			[str appendFormat:@"%@", [gstr string:110 + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]];
		}
	}
	
	if (p.nCaturmasya & CMASYA_EKAD_MASK)
	{
		[str appendFormat:@"%@ [EKADASI SYSTEM]\r\n"
					, [gstr string:107 + ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16)
						   + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]
					];
		if ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) == 0x10000)
		{
			[str appendFormat:@"%@", [gstr string:110 + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]];
		}
	}
	[str appendFormat:@"\n"];
	// tithi at arunodaya
	if (disp.arun_tithi)//m_dshow.m_tithi_arun)
	{
		[str appendFormat:@"%@: %@\n", [gstr string:98], [gstr GetTithiName:p.astrodata.nTithiArunodaya]];
	}
	
	//"Arunodaya Time",//1
	if (disp.arunodaya)//m_dshow.m_arunodaya)
	{
		[str appendFormat:@"%@ %d:%02d (%@)\n", [gstr string:99], p.astrodata.sun.arunodaya.hour
					, p.astrodata.sun.arunodaya.minute, [gstr GetDSTSignature:p.nDST]];
	}
	
	//"Moonrise Time",//4
	if (disp.moonrise)
	{
		if (p.moonrise.hour < 0)
		{
			[str appendFormat:@"%@", [gstr string:136]];
		}
		else
		{
			[str appendFormat:@"%@ %d:%02d (%@)", [gstr string:53], p.moonrise.hour
						, p.moonrise.minute, [gstr GetDSTSignature:p.nDST]];
		}
		[str appendFormat:@"\n"];
	}
	//"Moonset Time",//5
	if (disp.moonset)
	{
		if (p.moonrise.hour < 0)
			[str appendFormat:@"%@", [gstr string:137]];
		else
		{
			[str appendFormat:@"%@ %d:%02d (%@)", [gstr string:54], p.moonset.hour
						, p.moonset.minute, [gstr GetDSTSignature:p.nDST]];
		}
		[str appendFormat:@"\n"];
	}
	///"Sun Longitude",//9
	if (disp.sun_long)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@: %f (*)\n", [gstr string:100], p.astrodata.sun.longitude_deg];
	}
	//"Moon Longitude",//10
	if (disp.moon_long)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@: %f (*)\r\n", [gstr string:101], p.astrodata.moon.longitude_deg];
	}
	//"Ayanamsha value",//11
	if (disp.ayanamsa)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@ %f (%@) (*)\r\n", [gstr string:102], p.astrodata.msAyanamsa, GetAyanamsaName(GetAyanamsaType())];
	}
	//"Julian Day",//12
	if (disp.julian)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@ %f (*)\r\n", [gstr string:103], p.astrodata.jdate];
	}
	
	[str appendFormat:@"\r\n%@ %d:%02d %@, %@: %@, %@: %@, %@: %@.\r\n",
			[gstr string:51], 
			p.astrodata.sun.rise.hour, p.astrodata.sun.rise.minute, 
			[gstr GetDSTSignature:p.nDST],
			[gstr string:15], [gstr GetNaksatraName:p.astrodata.nNaksatra],
			[gstr string:104], [gstr GetYogaName:p.astrodata.nYoga], 
			[gstr string:105], [gstr GetSankrantiName:p.astrodata.nRasi]];
	[str appendFormat:@"%@ %d:%02d %@\r\n", [gstr string:52], p.astrodata.sun.set.hour, p.astrodata.sun.set.minute
		, [gstr GetDSTSignature:p.nDST]];
	
	return str;
}

-(void)calcAllTithis:(gc_time)dayA
{
	gc_time dayB = dayA;
	dayB.shour = 0.0;
		
	ab = GetPrevTithiStart([myLocation getEarth], dayB, &titA);
	titB = titA;
	gc_time_add_hours(&titB, 0.3);
	bc = GetNextTithiStart([myLocation getEarth], titB, &titB);
	titC = titB;
	gc_time_add_hours(&titC, 0.3);
	cd = GetNextTithiStart([myLocation getEarth], titC, &titC);
	titD = titC;
	gc_time_add_hours(&titD, 0.3);
	GetNextTithiStart([myLocation getEarth], titD, &titD);

	nak_ab = GetPrevNaksatra([myLocation getEarth], dayB, &nakA);
	nakB = nakA;
	gc_time_add_hours(&nakB, 0.3);
	nak_bc = GetNextNaksatra([myLocation getEarth], nakB, &nakB);
	nakC = nakB;
	gc_time_add_hours(&nakC, 0.3);
	nak_cd = GetNextNaksatra([myLocation getEarth], nakC, &nakC);
	nakD = nakC;
	gc_time_add_hours(&nakD, 0.3);
	GetNextNaksatra([myLocation getEarth], nakD, &nakD);
	
	
	double bs = [myLocation daytimeBiasForDate:titB];
	timeInDST = 0;
	if (fabs(bs) > 0.01)
	{
		timeInDST = 1;
		gc_time_add_hours(&titA, bs);
		gc_time_add_hours(&titB, bs);
		gc_time_add_hours(&titC, bs);
		gc_time_add_hours(&titD, bs);

		gc_time_add_hours(&nakA, bs);
		gc_time_add_hours(&nakB, bs);
		gc_time_add_hours(&nakC, bs);
		gc_time_add_hours(&nakD, bs);
	}
}

-(NSString *)formatInitialHtml
{
	NSMutableString * f = [[[NSMutableString alloc] init] autorelease];
	
	gc_time gc;
	gc_time_Today(&gc);
	
	[f appendFormat:@"<html>\n<head>\n<title></title>"];
	[f appendFormat:@"<style>\n"];
	[gstr addHtmlStylesDef:f display:disp];
	[f appendFormat:@"\n</style>\n"];
	[f appendFormat:@"</head>\n"];
	[f appendFormat:@"<body bgcolor=%@>\n", disp.bkgColor];
	[f appendFormat:@"<p class=SectionHead style='text-align:left'><span class=SectionHead1><b>%@</b>  %@</span><br><b>%@</b><br>\n", 
	 [gstr dateToString:gc], 
	 gc_time_getDayHumanTitle(gc),
	 [gstr string:gc.dayOfWeek]];
	[f appendFormat:@"<span class=SectionHead2>%@<br>%@ %@</span></p>\n", [myLocation fullName],
	 [myLocation.timeZone abbreviationForDate:[myLocation dateFromGcTime:gc]], 
	 [myLocation.timeZone name]];
	[f appendFormat:@"<hr><p><b>GCAL is calculating current day. Please wait a moment.</b></p>"];

	return f;
}

-(NSString *)resolveSpecialEkadasiMessage:(GcDay *)p
{
	NSString * msgSuitable = @"(suitable for fasting)<br>";
	NSString * msgNonSuitable = @"(not suitable for fasting)<br>";
	if (p.astrodata.nTithi == 10 || p.astrodata.nTithi == 25)
	{
		return (p.nFastType == FAST_EKADASI) ? msgSuitable : msgNonSuitable
			;
	}
	else if ((p.astrodata.nTithi == 11 || p.astrodata.nTithi == 26) && p.nFastType == FAST_EKADASI)
	{
		return msgSuitable;
	}
	
	return @"";
}

-(NSString *)formatTodayHtml
{
	//NSString * str2, * str3, * str4;
	
	int i = [calend FindDate:self.current];
	if (i < 0) return @"";
	
	GcDay * p = [calend GetDay:i];
	
	if (!p) return @"";
	
	// calc all tithis
	[self calcAllTithis:self.current];
	
	
	NSMutableString * f = [[[NSMutableString alloc] init] autorelease];
	
	[f appendFormat:@"<html>\n<head>\n<title></title>"];
	[f appendFormat:@"<style>\n"];
	[gstr addHtmlStylesDef:f display:disp];
	[f appendFormat:@"\n</style>\n"];
	[f appendFormat:@"</head>\n"];
	[f appendFormat:@"<body bgcolor=%@>\n", disp.bkgColor];
	[f appendFormat:@"<p class=SectionHead style='text-align:left'><span class=SectionHead1><b>%@</b>  %@</span><br><b>%@</b><br>\n", 
		[gstr dateToString:self.current], 
		gc_time_getDayHumanTitle(self.current),
		[gstr string:self.current.dayOfWeek]];
	[f appendFormat:@"<span class=SectionHead2>%@<br>%@ %@</span></p>\n", [myLocation fullName],
	 [myLocation.timeZone abbreviationForDate:[myLocation dateFromGcTime:p.date]], [myLocation.timeZone name]];
	[f appendFormat:@"<hr><p><span class=GaurHead>  %@, %@ %@</span><br><span class=GaurSubhead>%@  %@ %@, %d Gaurabda</span></p>",
			[gstr GetTithiName:p.astrodata.nTithi], [gstr GetPaksaName:p.astrodata.nPaksa], [gstr string:20], 
	 [self resolveSpecialEkadasiMessage:p],
			[gstr GetMasaName:p.astrodata.nMasa], [gstr string:22], p.astrodata.nGaurabdaYear];
	
	int prevCountFest = 0;
	
	if (p.ekadasi_parana)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"<span style=\'color:%@;font-weight:bold\'>%@</span>", 
		 disp.specialTextColor, [p GetTextEP:gstr]];
		prevCountFest++;
	}
	
	// adding mahadvadasi
	// adding spec festivals
	
	if ([p.festivals count] > 0)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		for(GcDayFestival * pdf in p.festivals)
		{
			//if (pdf.group < 0 || [disp canShowFestivalClass:pdf.group])
			{
				if (prevCountFest > 0)
					[f appendFormat:@"<br>"];
				[f appendFormat:@"%@", pdf.name];
				prevCountFest++;
			}
		}
	}
	
	
	if (disp.sankranti && p.sankranti_zodiac >= 0)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		//double h1, m1;
		//m1 = modf(p.sankranti_day.shour*24, &h1];
		[f appendFormat:@"<span style=\'color:%@\'>%@ %@ (%@ %@ %@ %d %@, %@ %@)</span>"
				, disp.specialTextColor
				, [gstr GetSankrantiName:p.sankranti_zodiac]
				, [gstr string:56]
				, [gstr string:111], [gstr GetSankrantiNameEn:p.sankranti_zodiac]
				, [gstr string:852]
				, p.sankranti_day.day, [gstr GetMonthAbr:p.sankranti_day.month]
				, [gstr timeShortToString:p.sankranti_day]
				, [gstr GetDSTSignature:p.nDST]];
		prevCountFest++;
	}
	
	if (disp.ksaya && p.was_ksaya)//(m_dshow.m_info_ksaya) && (pvd->was_ksaya))
	{
		gc_time dd;
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		dd = p.date;
		if (p.ksaya_day1 < 0.0) GetPrevDay(&dd);
		[f appendFormat:@"%@ %@ ", [gstr string:89], [gstr string:850]];
		[f appendFormat:@"%d %@, %@ ", dd.day, [gstr GetMonthAbr:dd.month], [gstr hoursToString:(p.ksaya_time1*24)]];
		dd = p.date;
		if (p.ksaya_day2 < 0.0) GetPrevDay(&dd);
		[f appendFormat:@"%@ %d %@, %@", [gstr string:851],
				dd.day, [gstr GetMonthAbr:dd.month], [gstr hoursToString:(p.ksaya_time2*24)]];
		[f appendFormat:@"(%@)", [gstr GetDSTSignature:p.nDST]];
		prevCountFest++;
	}
	
	if (disp.vriddhi && p.is_vriddhi)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"%@", [gstr string:90]];
		prevCountFest++;
	}
	
	
	if ((p.nCaturmasya & CMASYA_PURN_MASK) && disp.catur_purn)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br><br>"];
		[f appendFormat:@"%@ [PURNIMA SYSTEM]"
				, [gstr string:107 + (p.nCaturmasya & CMASYA_PURN_MASK_DAY)
					   + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]
				];
		if ((p.nCaturmasya & CMASYA_PURN_MASK_DAY) == 0x1)
		{
			[f appendFormat:@"<br>"];
			[f appendFormat:@"%@", [gstr string:110 + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]];
		}
		[f appendFormat:@"<br>"];
		prevCountFest++;
	}
	
	if ((p.nCaturmasya & CMASYA_PRAT_MASK) && disp.catur_prat)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br><br>"];
		[f appendFormat:@"%@ [PRATIPAT SYSTEM]"
				, [gstr string:107 + ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8)
					   + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]
				];
		if ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) == 0x100)
		{
			[f appendFormat:@"<br>"];
			[f appendFormat:@"%@", [gstr string:110 + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]];
		}
		[f appendFormat:@"</br>"];
		prevCountFest++;
	}
	
	if ((p.nCaturmasya & CMASYA_EKAD_MASK) && disp.catur_ekad)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br><br>"];
		[f appendFormat:@"%@ [EKADASI SYSTEM]"
				, [gstr string:107 + ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16)
					   + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]
				];
		if ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) == 0x10000)
		{
			[f appendFormat:@"<br>"];
			[f appendFormat:@"%@", [gstr string:110 + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]];
		}
		[f appendFormat:@"<br>"];
		prevCountFest++;
	}
	
	if (prevCountFest > 0)
		[f appendFormat:@"</td></tr></table>\n"];
	
	[f appendFormat:@"<p>"];
	// tithi at arunodaya
	if (disp.arun_tithi)//m_dshow.m_tithi_arun)
	{
		[f appendFormat:@"<br>%@: %@", [gstr string:98], [gstr GetTithiName:p.astrodata.nTithiArunodaya]];
	}
	
	//"Arunodaya Time",//1
	if (disp.arunodaya)//m_dshow.m_arunodaya)
	{
		[f appendFormat:@"<br>%@ %d:%02d (%@)\r\n", [gstr string:99], p.astrodata.sun.arunodaya.hour
				, p.astrodata.sun.arunodaya.minute, [gstr GetDSTSignature:p.nDST]];
	}
	
	//"Moonrise Time",//4
	if (disp.moonrise)
	{
		[f appendFormat:@"<br>"];
		if (p.moonrise.hour < 0)
			[f appendFormat:@"%@", [gstr string:136]];
		else
		{
			[f appendFormat:@"%@ %d:%02d (%@)", [gstr string:53], p.moonrise.hour
					, p.moonrise.minute, [gstr GetDSTSignature:p.nDST]];
		}
	}
	//"Moonset Time",//5
	if (disp.moonset)
	{
		if (disp.moonrise)
			[f appendFormat:@"&nbsp;&nbsp;&nbsp;"];
		else
			[f appendFormat:@"<br>"];
		if (p.moonrise.hour < 0)
			[f appendFormat:@"%@", [gstr string:137]];
		else
		{
			[f appendFormat:@"%@ %d:%02d (%@)", [gstr string:54], p.moonset.hour
					, p.moonset.minute, [gstr GetDSTSignature:p.nDST]];
		}
	}
	///"Sun Longitude",//9
	if (disp.sun_long)//m_dshow.m_sun_long)
	{
		[f appendFormat:@"<br>%@: %f (*)\r\n", [gstr string:100], p.astrodata.sun.longitude_deg];
	}
	//"Moon Longitude",//10
	if (disp.moon_long)//m_dshow.m_sun_long)
	{
		if (disp.sun_long)
			[f appendFormat:@", "];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"%@: %f (*)\r\n", [gstr string:101], p.astrodata.moon.longitude_deg];
	}
	//"Ayanamsha value",//11
	if (disp.ayanamsa)//m_dshow.m_sun_long)
	{
		if (disp.sun_long || disp.moon_long)
			[f appendFormat:@", "];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"<br>%@ %f (%@) (*)\r\n", [gstr string:102], p.astrodata.msAyanamsa, GetAyanamsaName(GetAyanamsaType())];
	}
	//"Julian Day",//12
	if (disp.julian)//m_dshow.m_sun_long)
	{
		if (disp.sun_long || disp.moon_long || disp.ayanamsa)
			[f appendFormat:@", "];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"<br>%@ %f (*)\r\n", [gstr string:103], p.astrodata.jdate];
	}
	
	/*BEGIN GCAL 1.4.3*/
	gc_daytime tdA, tdB;
	
	if (disp.t_brahma)
	{
		tdA = p.astrodata.sun.rise;
		tdB = p.astrodata.sun.rise;
		gc_daytime_sub_minutes(&tdA, 96);
		gc_daytime_sub_minutes(&tdB, 48);
		[f appendFormat:@"<p><b>Brahma-muhurta</b> %2d:%02d - %2d:%02d</p>",
			 tdA.hour, tdA.minute, tdB.hour, tdB.minute];
	}

	[f appendFormat:@"<table border=0 cellpadding=0 width='100%%'><tr>"];
	if (disp.t_sunrise)
	{
		[f appendFormat:@"<td class=hed><p>%@<br> <span style='font-size:%@'>%2d:%02d</span></td> ",
				[gstr string:51], disp.h2textSize, p.astrodata.sun.rise.hour, p.astrodata.sun.rise.minute ];
	}
	if (disp.t_noon)
	{
		[f appendFormat:@"<td class=hed><p>%@<br><span style='font-size:%@'>%2d:%02d</span></td>", 
		 [gstr string:857], disp.h2textSize, p.astrodata.sun.noon.hour, p.astrodata.sun.noon.minute];
	}
	if (disp.t_sunset)
	{
		[f appendFormat:@"<td class=hed><p>%@<br><span style='font-size:%@'>%2d:%02d</span></td>", 
		[gstr string:52], disp.h2textSize, p.astrodata.sun.set.hour, p.astrodata.sun.set.minute];
	}
	[f appendFormat:@"</tr>"];
	if (disp.t_sandhya)
	{
		[f appendFormat:@"<tr>"];
		if (disp.t_sunrise)
		{
			tdA = p.astrodata.sun.rise;
			tdB = p.astrodata.sun.rise;
			gc_daytime_sub_minutes(&tdA, 24);
			gc_daytime_add_minutes(&tdB, 24);
			[f appendFormat:@"<td class=hed2>sandhya<br><b>%2d:%02d - %2d:%02d</b></td>", tdA.hour, tdA.minute, tdB.hour, tdB.minute];
		}
		if (disp.t_noon)
		{
			tdA = p.astrodata.sun.noon;
			tdB = p.astrodata.sun.noon;
			gc_daytime_sub_minutes(&tdA, 24);
			gc_daytime_add_minutes(&tdB, 24);
			[f appendFormat:@"<td class=hed2>sandhya<br><b>%2d:%02d - %2d:%02d</b></td>", tdA.hour, tdA.minute, tdB.hour, tdB.minute];
		}
		if (disp.t_sunset)
		{
			tdA = p.astrodata.sun.set;
			tdB = p.astrodata.sun.set;
			gc_daytime_sub_minutes(&tdA, 24);
			gc_daytime_add_minutes(&tdB, 24);
			[f appendFormat:@"<td class=hed2>sandhya<br><b>%2d:%02d - %2d:%02d</b></td>", tdA.hour, tdA.minute, tdB.hour, tdB.minute];
		}
		[f appendFormat:@"</tr>"];
	}
	[f appendFormat:@"</table>"];

	
	if (disp.t_riseinfo)
	{
		[f appendFormat:@"<p><b>%@ info</b><br>Moon in the %@ %@, %@ %@, Sun in the %@ %@.</p>",
				[gstr string:51], 
				[gstr GetNaksatraName:p.astrodata.nNaksatra], [gstr string:15],  
				[gstr GetYogaName:p.astrodata.nYoga], [gstr string:104],  
				[gstr GetSankrantiName:p.astrodata.nRasi], [gstr string:105]];
	}
	
	if (disp.t_det_tithi)
	{
		[f appendFormat:@"<p><b>Tithi Details</b> (%@)<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@</p>",
		 [myLocation timeNameForDate:titA],
		 [gstr GetTithiName:ab], 
		 [gstr dateShortToString:titA], [gstr timeShortToString:titA],
		 [gstr dateShortToString:titB], [gstr timeShortToString:titB],
		 [gstr GetTithiName:bc],
		 [gstr dateShortToString:titB], [gstr timeShortToString:titB],
		 [gstr dateShortToString:titC], [gstr timeShortToString:titC],
		 [gstr GetTithiName:cd],
		 [gstr dateShortToString:titC], [gstr timeShortToString:titC],
		 [gstr dateShortToString:titD], [gstr timeShortToString:titD]
		 ];
	}

	if (disp.t_det_naksatra)
	{
		[f appendFormat:@"<p><b>Naksatra Details</b> (%@)<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@</p>",
		 [myLocation timeNameForDate:nakA],
		 [gstr GetNaksatraName:nak_ab], 
		 [gstr dateShortToString:nakA], [gstr timeShortToString:nakA],
		 [gstr dateShortToString:nakB], [gstr timeShortToString:nakB],
		 [gstr GetNaksatraName:nak_bc],
		 [gstr dateShortToString:nakB], [gstr timeShortToString:nakB],
		 [gstr dateShortToString:nakC], [gstr timeShortToString:nakC],
		 [gstr GetNaksatraName:nak_cd],
		 [gstr dateShortToString:nakC], [gstr timeShortToString:nakC],
		 [gstr dateShortToString:nakD], [gstr timeShortToString:nakD]
		 ];
	}
	
	[f appendFormat:@"<hr>"];
	[f appendFormat:@"<p style='font-size:8.0pt'>%@"
//	    "<b>NOTE</b>: To change location, click on 'Current"
//		" Location' button in the toolbar. Select location and click on 'Accept' button."
//		"<br>For configuration of this page, go to Menu -&gt; Settings -&gt; Today "
//		"Display Settings."
		"<br>Generated by %@</p>", [myLocation.timeZone description], [gstr string:131]];
	[f appendFormat:@"</body>"];
	[f appendFormat:@"</html>"];
	/* END GCAL 1.4.3 */
	
	return f;
}

@end
