//
//  GcResultCalendar.m
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GcResultCalendar.h"
#import "gc_func.h"
#import "gc_dtypes.h"
#import "GcDayFestival.h"
#import "GcEvents.h"
#import "GCGregorianTime.h"
#import "GCCoreEvent.h"

/*
 
 Complete calculation of Vaisnava Calendar
 
 Main func is CalculateCalendar
 
 */
#define FOREACH_INDEX(i) for(i=0;i<nTotalCount;i++)
#define MAX_VAL(a,b) ((a) > (b) ? (a) : (b))
#define MIN_VAL(a,b) ((a) < (b) ? (a) : (b))
#define DAYS_TO_ENDWEEK(i) (21-(i-g_firstday_in_week))%7
#define DAYS_FROM_BEGINWEEK(i) (i-g_firstday_in_week+14)%7
#define DAY_INDEX(i) (i+g_firstday_in_week)%7

/*class SYSTEMTIME
{
public:
	int wDay;
	int wMonth;
	int wYear;
	int wSecond;
	int wMinute;
	int wHour;
	int wMilliseconds;
	int wDayOfWeek;
};

void GetLocalTime(SYSTEMTIME * st)
{
	time_t t;
	tm * pt;
	time(&t);
	pt = localtime(&t);
	if (pt)
	{
		st->wDay = pt->tm_mday;
		st->wMonth = pt->tm_mon + 1;
		st->wYear = pt->tm_year + 1900;
		st->wHour = pt->tm_hour;
		st->wMinute = pt->tm_min;
		st->wSecond = pt->tm_sec;
		st->wMilliseconds = 0;
		st->wDayOfWeek = pt->tm_wday;
	}
}*/

@implementation GcResultCalendar


@synthesize m_vcStart;
@synthesize m_nCount;
@synthesize m_PureCount;
@synthesize m_vcCount;


-(id)init
{
	NSLog(@"init calendar");
	if ((self = [super init]) != nil) {
		//nTop = 0;
		//nBeg = 0;
		m_pData = nil;
		self.m_PureCount = 0;
		self.m_nCount = 0;
		events = nil;
	}
	
	return self;
}

-(void)dealloc
{
	// dealokacia pola
	
	[self freeEvents];
	
}

-(void)freeEvents
{
	if (events != nil)
	{
		events = nil;
	}
}

-(BOOL)NextNewFullIsVriddhi:(int)nIndex location:(gc_earth)earth
{
	int i = 0;
	int nTithi;
	int nPrevTithi = 100;
	
	for(i = 0; (i < BEFORE_DAYS) && (nIndex < [m_pData count]); i++)
	{
		GCCalendarDay * p = [m_pData objectAtIndex:nIndex];
		nTithi = p.astrodata.nTithi;
		if ((nTithi == nPrevTithi) && TITHI_FULLNEW_MOON(nTithi))
		{
			return YES;
		}
		nPrevTithi = nTithi;
		nIndex++;
	}
	
	return NO;
}

-(BOOL)IsMhd58:(int)nIndex type:(int *)nMahaType
{
	GCCalendarDay * t = [m_pData objectAtIndex:nIndex];
	GCCalendarDay * u = [m_pData objectAtIndex:(nIndex + 1)];
	
	*nMahaType = 0;
	
	if (t.astrodata.nNaksatra != u.astrodata.nNaksatra)
		return NO;
	
	if (t.astrodata.nPaksa != 1)
		return NO;
	
	if (t.astrodata.nTithi == t.astrodata.nTithiSunset)
	{
		if (t.astrodata.nNaksatra == 6) // punarvasu
		{
			*nMahaType = EV_JAYA;
			return YES;
		}
		else if (t.astrodata.nNaksatra == 3) // rohini
		{
			*nMahaType = EV_JAYANTI;
			return YES;
		}
		else if (t.astrodata.nNaksatra == 7) // pusyami
		{
			*nMahaType = EV_PAPA_NASINI;
			return YES;
		}
		else if (t.astrodata.nNaksatra == 21) // sravana
		{
			*nMahaType = EV_VIJAYA;
			return YES;
		}
		else
			return NO;
	}
	else
	{
		if (t.astrodata.nNaksatra == 21) // sravana
		{
			*nMahaType = EV_VIJAYA;
			return YES;
		}
	}
	
	return NO;
}

-(void)recalc
{
	[self CalculateCalendar:self.m_vcStart count:self.m_vcCount];
}

/******************************************************************************************/
/******************************************************************************************/

- (void)calculateTithiCoreEvents:(gc_earth)ed
{
    // init for sankranti
    GCCalendarDay * P = [m_pData objectAtIndex:0];
    GCGregorianTime *date = [P.date copy];
    int nTithi;

    do
    {
        nTithi = GetNextTithiStart(ed, date, &date);
        //[date addDayHours:[self.m_Location daytimeBiasForDate:date]];
        P = [self findCalendarDay:date];
        if (P == nil)
            break;
        GCCoreEvent * event = [GCCoreEvent new];
        event.seconds = (int)(date.shour * 86400);
        event.type = CET_TITHI;
        event.text = [NSString stringWithFormat:@"%@ tithi starts", [self.gstr GetTithiName:nTithi]];
        [P addCoreEvent:event];
        [date addDayHours:0.5];
    }
    while(YES);
    
}

/******************************************************************************************/
/******************************************************************************************/

- (void)calculateNaksatraCoreEvents:(gc_earth)ed
{
    // init for sankranti
    GCCalendarDay * P = [m_pData objectAtIndex:BEFORE_DAYS - 1];
    GCGregorianTime *date = [P.date copy];
    int nNaksatra;
    
    do
    {
        nNaksatra = GetNextNaksatra(ed, date, &date);
        //[date addDayHours:[self.m_Location daytimeBiasForDate:date]];
        P = [self findCalendarDay:date];
        if (P == nil)
            return;
        GCCoreEvent * event = [GCCoreEvent new];
        event.seconds = (int)(date.shour * 86400);
        event.type = CET_NAKSATRA;
        event.text = [NSString stringWithFormat:@"%@ naksatra starts", [self.gstr GetNaksatraName:nNaksatra]];
        [P addCoreEvent:event];
        [date addDayHours:0.5];
    }
    while(YES);
    
}


/******************************************************************************************/
/******************************************************************************************/

- (void)calculateSankrantiCoreEvents
{
    // init for sankranti
    GCGregorianTime *date;
    int i;
    GCCalendarDay * P;
    P = [m_pData objectAtIndex:0];
    date = P.date;
    i = 0;
    BOOL bFoundSan;
    int zodiac;
    int i_target;
    do
    {
        date = GetNextSankranti(date, &zodiac);
        //[date addDayHours:[self.m_Location daytimeBiasForDate:date]];
        
        P = [self findCalendarDay:date];
        GCCoreEvent * ce = [GCCoreEvent new];
        ce.seconds = (int)(date.shour * 86400);
        ce.type = 2;
        ce.text = [NSString stringWithFormat:@"%@ sankranti", [self.gstr GetSankrantiName:zodiac]];
        [P addCoreEvent:ce];
        
        bFoundSan = NO;
        for(i=0;i < self.m_nCount-1;i++)
        {
            GCCalendarDay * P = [m_pData objectAtIndex:i];
            i_target = -1;
            
            switch(GetSankrantiType())
            {
                case 0:
                    if (gc_time_CompareYMD(date, P.date) == 0)
                    {
                        i_target = i;
                    }
                    break;
                case 1:
                    if (gc_time_CompareYMD(date, P.date) == 0)
                    {
                        if (date.shour < gc_daytime_GetDayTime(P.astrodata.sun.rise))
                        {
                            i_target = i - 1;
                        }
                        else
                        {
                            i_target = i;
                        }
                    }
                    break;
                case 2:
                    if (gc_time_CompareYMD(date, P.date) == 0)
                    {
                        if (date.shour > gc_daytime_GetDayTime(P.astrodata.sun.noon))
                        {
                            i_target = i+1;
                        }
                        else
                        {
                            i_target = i;
                        }
                    }
                    break;
                case 3:
                    if (gc_time_CompareYMD(date, P.date) == 0)
                    {
                        if (date.shour > gc_daytime_GetDayTime(P.astrodata.sun.set))
                        {
                            i_target = i+1;
                        }
                        else
                        {
                            i_target = i;
                        }
                    }
                    break;
            }
            
            if (i_target >= 0)
            {
                GCCalendarDay * pTarget = [m_pData objectAtIndex:i_target];
                pTarget.sankranti_zodiac = zodiac;
                pTarget.sankranti_day = date;
                bFoundSan = YES;
                break;
            }
        }
        date = [date addDays:20];
    }
    while(bFoundSan);
}

/******************************************************************************************/

/******************************************************************************************/


- (void)calculateSankrantiBasedEvents
{
    // 9
    // init for festivals dependent on sankranti
    int i;
    for(i = BEFORE_DAYS; i < self.m_PureCount + BEFORE_DAYS; i++)
    {
        GCCalendarDay * P = [m_pData objectAtIndex:i];
        GCCalendarDay * Rnext = [m_pData objectAtIndex:(i+1)];
        if (P.sankranti_zodiac == MAKARA_SANKRANTI)
        {
            [P AddFestival:[self.gstr string:78] withClass:5];
        }
        else if (P.sankranti_zodiac == MESHA_SANKRANTI)
        {
            [P AddFestival:[self.gstr string:79] withClass:5];
        }
        else if (Rnext.sankranti_zodiac == VRSABHA_SANKRANTI)
        {
            [P AddFestival:[self.gstr string:80] withClass:5];
        }
    }
}

/******************************************************************************************/

/******************************************************************************************/


- (void)calculateKsayaAndVriddhiDays:(gc_earth)earth
{
    // 10
    // init ksaya data
    // init of second day of vriddhi
    int i;
    for(i = BEFORE_DAYS; i < self.m_PureCount + BEFORE_DAYS; i++)
    {
        GCCalendarDay * P = [m_pData objectAtIndex:i];
        GCCalendarDay * Oprev = [m_pData objectAtIndex:(i-1)];
        if (P.astrodata.nTithi == Oprev.astrodata.nTithi)
            P.is_vriddhi = true;
        else if (P.astrodata.nTithi != ((Oprev.astrodata.nTithi + 1)%30))
        {
            P.was_ksaya = true;
            
            GCGregorianTime * day1, * d1, * d2;
            day1 = [P.date copy];
            day1.shour = P.astrodata.sun.sunrise_deg/360.0 + earth.tzone/24.0;
            
            GetPrevTithiStart(earth, day1, &d2);
            day1 = [d2 copy];
            [day1 addDayHours:-0.1];
            GetPrevTithiStart(earth, day1, &d1);
            
            [d1 addDayHours:(P.nDST/24.0)];
            [d2 addDayHours:(P.nDST/24.0)];
            
            P.ksaya_day1 = (d1.day == P.date.day) ? 0 : -1;
            P.ksaya_time1 = d1.shour;
            P.ksaya_day2 = (d2.day == P.date.day) ? 0 : -1;
            P.ksaya_time2 = d2.shour;
            
        }
        
        [self addAdditionalInfo:P];
        
    }
}

/******************************************************************************************/
/* Main fucntion for VCAL calculations                                                    */
/*                                                                                        */
/*                                                                                        */
/******************************************************************************************/

-(int)CalculateCalendar:(GCGregorianTime *)begDate count:(int)iCount
{
	int i, m, weekday;
	int nTotalCount = BEFORE_DAYS + iCount + BEFORE_DAYS;
	GCGregorianTime * date;
	int nYear;
	gc_earth earth;
	int prev_paksa = 0;
	bool bCalcMoon = (disp.moonrise == YES || disp.moonset == YES);
	/*	Boolean bCalcMasa[] = 
	 { true, true, false, false, false, false, false, false, false, false, false, false, false, false, true, 
	 true, true, false, false, false, false, false, false, false, false, false, false, false, false, true };
	 */
	self.m_nCount = 0;
	self.m_vcStart = begDate;
	self.m_vcCount = iCount;
	earth = [self.m_Location getEarth];
	
	// dealokacia pola
	
	// kontrola xi ma eventy
	if (events == nil)
	{
		events = [GcEvents defaultEvents];
	}
	
	// alokacia pola
	m_pData = [[NSMutableArray alloc] initWithCapacity:nTotalCount];
	if (m_pData == nil) return 0;
	
	// inicializacia poctovych premennych
	self.m_nCount = nTotalCount;
	self.m_PureCount = iCount;
	
    date = [begDate copy];
	date.shour = 0.0;
	date.tzone = [self.m_Location timeZoneOffset];
	//	date -= BEFORE_DAYS;
	
	//ProgressWindowCreate();
	//ProgressWindowSetRange(0, 100);

    date = [date addDays:-BEFORE_DAYS];
	weekday = date.dayOfWeek;
	
	// 1
	// initialization of days
	FOREACH_INDEX(i)
	{
		GCCalendarDay * P = [[GCCalendarDay alloc] init];
		P.date = [date copy];
		P.fDateValid = true;
		P.fVaisValid = false;
		weekday = (weekday + 1) % 7;
		date.dayOfWeek = weekday;
		P.moonrise = gc_daytime_init(-1);
		P.moonset = gc_daytime_init(-1);
		P.nDST = [self.m_Location isDaylightTime:P.date] ? 1 : 0;
		[m_pData addObject:P];
        
        date = [date nextDay];
	}
    
    GCCalendarDay * prevd = nil;
    GCCalendarDay * currd = nil;
    for (int i = 0; i < m_pData.count; i++)
    {
        currd = [m_pData objectAtIndex:i];
        currd.previousDay = prevd;
        if (prevd)
        {
            prevd.nextDay = currd;
        }
        prevd = currd;
    }
    
	
	// 3
	if (bCalcMoon)
	{
		gc_daytime mrise;
		gc_daytime mset;
		FOREACH_INDEX(i)
		{
			GCCalendarDay * P = [m_pData objectAtIndex:i];
			CalcMoonTimes(earth, P.date, (double)(P.nDST), &mrise, &mset);
			P.moonrise = mrise;
			P.moonset = mset;
		}
	}
	
	// 4
	// init of astro data
	FOREACH_INDEX(i)
	{
		GCCalendarDay * P = [m_pData objectAtIndex:i];
		P.astrodata = DayCalc(P.date, earth);
        //NSLog(@"Date %@     sunrise %02d:%02d:%02d", P.date.longDateString, P.astrodata.sun.rise.hour, P.astrodata.sun.rise.minute, P.astrodata.sun.rise.sec);
	}
	
	BOOL calc_masa;
	
	// 5
	// init of masa
	prev_paksa = -1;
	FOREACH_INDEX(i)
	{
		GCCalendarDay * P = [m_pData objectAtIndex:i];
		calc_masa = (P.astrodata.nPaksa != prev_paksa);
		prev_paksa = P.astrodata.nPaksa;
		
		if (i == 0)
			calc_masa = YES;
		
		if (calc_masa)
		{
			P.astrodata = MasaCalc(P.date, P.astrodata, earth);
			m = P.astrodata.nMasa;
			nYear = P.astrodata.nGaurabdaYear;
		}
		[P setMasa:m];
		[P setGaurabda:nYear];
		P.fAstroValid = true;
	}
	
	// 6
	// init of mahadvadasis
	//NSLog(@"6\n");
	for(i = 2; i < (self.m_PureCount + 2*BEFORE_DAYS - 3); i++)
	{
		GCCalendarDay * P = [m_pData objectAtIndex:i];
		[P Clear];
		[self MahadvadasiCalc:i location:earth];
	}
	
    [self calculateTithiCoreEvents:earth];
    [self calculateNaksatraCoreEvents:earth];
    [self calculateSankrantiCoreEvents];
    [self calculateKsayaAndVriddhiDays:earth];
    
	// 6,5
	// init for Ekadasis
	for(i = 3; i < (self.m_PureCount + 2*BEFORE_DAYS - 3); i++)
	{
		[self EkadasiCalc:i location:earth];
	}
	
	//NSLog(@"7\n");
	// 7
	// init of festivals
	for(i = BEFORE_DAYS; i < (self.m_PureCount + 2*BEFORE_DAYS - 3); i++)
	{
		[self CompleteCalc:i location:earth];
	}
	
	//NSLog(@"8\n");
	// 8
	// init of festivals
	for(i = BEFORE_DAYS; i < self.m_PureCount + BEFORE_DAYS; i++)
	{
		[self ExtendedCalc:i location:earth];
	}
	//NSLog(@"--before resolve ---\n");
	
	//NSLog(@"9\n");
	// resolve festivals fasting
	for(i = BEFORE_DAYS; i < self.m_PureCount + BEFORE_DAYS; i++)
	{
		GCCalendarDay * P = [m_pData objectAtIndex:i];
		[P addBiasToTimes:([self.m_Location daytimeBiasForDate:P.date]*24.0)];
		[self ResolveFestivalsFasting:i];
	}
	
	//NSLog(@"--after resolve ---\n");
	//NSLog(@"10\n");

   
    [self calculateSankrantiBasedEvents];
	
	
	
	//	ProgressWindowClose();
	
	return 1;
	
}

-(void)addAdditionalInfo:(GCCalendarDay *)p
{
    if (disp.sankranti && p.sankranti_zodiac >= 0)
    {
        NSString * str = [NSString stringWithFormat:@"%@ %@ (%@ %@ %@ %d %@, %@ %@)"
//         , disp.specialTextColor
         , [self.gstr GetSankrantiName:p.sankranti_zodiac]
         , [self.gstr string:56]
         , [self.gstr string:111], [self.gstr GetSankrantiNameEn:p.sankranti_zodiac]
         , [self.gstr string:852]
         , p.sankranti_day.day, [self.gstr GetMonthAbr:p.sankranti_day.month]
         , [p.sankranti_day shortTimeString]
         , [self.gstr GetDSTSignature:p.nDST]];
        
        [p AddFestival:str];
    }
    
    if (disp.ksaya && p.was_ksaya)//(m_dshow.m_info_ksaya) && (pvd->was_ksaya))
    {
        NSMutableString * f = [NSMutableString new];
        GCGregorianTime * dd;
        dd = p.date;
        if (p.ksaya_day1 < 0.0) dd = [dd previousDay];
        [f appendFormat:@"%@ %@ ", [self.gstr string:89], [self.gstr string:850]];
        [f appendFormat:@"%d %@, %@ ", dd.day, [self.gstr GetMonthAbr:dd.month], [self.gstr hoursToString:(p.ksaya_time1*24)]];
        dd = p.date;
        if (p.ksaya_day2 < 0.0) dd = [dd previousDay];
        [f appendFormat:@"%@ %d %@, %@", [self.gstr string:851],
         dd.day, [self.gstr GetMonthAbr:dd.month], [self.gstr hoursToString:(p.ksaya_time2*24)]];
        [f appendFormat:@"(%@)", [self.gstr GetDSTSignature:p.nDST]];

        [p AddFestival:f];
    }
    
    if (disp.vriddhi && p.is_vriddhi)
    {
        [p AddFestival:[self.gstr string:90]];
    }
    
    
    if ((p.nCaturmasya & CMASYA_PURN_MASK) && (disp.caturmasya == 0))
    {
        NSMutableString * f = [NSMutableString new];
        [f appendFormat:@"%@ [PURNIMA SYSTEM]"
         , [self.gstr string:107 + (p.nCaturmasya & CMASYA_PURN_MASK_DAY)
            + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]
         ];
        [p AddFestival:f];
        if ((p.nCaturmasya & CMASYA_PURN_MASK_DAY) == 0x1)
        {
            [f setString:@""];
            [f appendFormat:@"%@", [self.gstr string:110 + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]];
            [p AddFestival:f];
        }
    }
    
    if ((p.nCaturmasya & CMASYA_PRAT_MASK) && (disp.caturmasya == 1))
    {
        NSMutableString * f = [NSMutableString new];
        [f appendFormat:@"%@ [PRATIPAT SYSTEM]"
         , [self.gstr string:107 + ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8)
            + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]
         ];
        [p AddFestival:f];
        if ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) == 0x100)
        {
            [f setString:@""];
            [f appendFormat:@"%@", [self.gstr string:110 + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]];
            [p AddFestival:f];
        }
    }
    
    if ((p.nCaturmasya & CMASYA_EKAD_MASK) && (disp.caturmasya == 2))
    {
        NSMutableString * f = [NSMutableString new];
        [f appendFormat:@"%@ [EKADASI SYSTEM]"
         , [self.gstr string:107 + ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16)
            + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]
         ];
        [p AddFestival:f];
        if ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) == 0x10000)
        {
            [f setString:@""];
            [f appendFormat:@"%@", [self.gstr string:110 + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]];
            [p AddFestival:f];
        }
    }
    
    GCCoreEvent * ce;
    
    ce = [GCCoreEvent new];
    ce.seconds = p.astrodata.sun.rise.hour*3600 + p.astrodata.sun.rise.minute*60 + p.astrodata.sun.rise.sec - 96*60;
    ce.type = CET_ARUNODAYA;
    ce.text = @"Arunodaya";
    [p addCoreEvent:ce];

    ce = [GCCoreEvent new];
    ce.seconds = p.astrodata.sun.rise.hour*3600 + p.astrodata.sun.rise.minute*60 + p.astrodata.sun.rise.sec;
    ce.type = CET_SUNRISE;
    ce.text = @"Sunrise";
    [p addCoreEvent:ce];

    ce = [GCCoreEvent new];
    ce.seconds = p.astrodata.sun.noon.hour*3600 + p.astrodata.sun.noon.minute*60 + p.astrodata.sun.noon.sec;
    ce.type = CET_NOON;
    ce.text = @"Noon";
    [p addCoreEvent:ce];

    ce = [GCCoreEvent new];
    ce.seconds = p.astrodata.sun.set.hour*3600 + p.astrodata.sun.set.minute*60 + p.astrodata.sun.set.sec;
    ce.type = CET_SUNSET;
    ce.text = @"Sunset";
    [p addCoreEvent:ce];

    
}

-(int)EkadasiCalc:(int)nIndex location:(gc_earth)earth
{
	GCCalendarDay * s = [m_pData objectAtIndex:(nIndex - 1)];
	GCCalendarDay * t = [m_pData objectAtIndex:nIndex];
	GCCalendarDay * u = [m_pData objectAtIndex:(nIndex + 1)];
	
	if (TITHI_EKADASI(t.astrodata.nTithi))
	{
		// if TAT < 11 then NOT_EKADASI
		if (TITHI_LESS_EKADASI(t.astrodata.nTithiArunodaya))
		{
			t.nMhdType = EV_NULL;
			t.ekadasiVrataName = nil;
			t.nFastType = FAST_NULL;
		}
		else 
		{
			// else ak MD13 then MHD1 and/or 3
			if (TITHI_EKADASI(s.astrodata.nTithi) && TITHI_EKADASI(s.astrodata.nTithiArunodaya))
			{
				if (TITHI_TRAYODASI(u.astrodata.nTithi))
				{
					t.nMhdType = EV_UNMILANI_TRISPRSA;
					t.ekadasiVrataName = [self.gstr GetEkadasiName:t.astrodata.nMasa forPaksa:t.astrodata.nPaksa];
					t.nFastType = FAST_EKADASI;
				}
				else
				{
					t.nMhdType = EV_UNMILANI;
					t.ekadasiVrataName = [self.gstr GetEkadasiName:t.astrodata.nMasa forPaksa:t.astrodata.nPaksa];
					t.nFastType = FAST_EKADASI;
				}
			}
			else
			{
				if (TITHI_TRAYODASI(u.astrodata.nTithi))
				{
					t.nMhdType = EV_TRISPRSA;
					t.ekadasiVrataName = [self.gstr GetEkadasiName:t.astrodata.nMasa forPaksa:t.astrodata.nPaksa];
					t.nFastType = FAST_EKADASI;
				}
				else
				{
					// else ak U je MAHADVADASI then NOT_EKADASI
					if (TITHI_EKADASI(u.astrodata.nTithi) || (u.nMhdType >= EV_SUDDHA))
					{
						t.nMhdType = EV_NULL;
						t.ekadasiVrataName = nil;
						t.nFastType = FAST_NULL;
					}
					else if (u.nMhdType == EV_NULL)
					{
						// else suddha ekadasi
						t.nMhdType = EV_SUDDHA;
						t.ekadasiVrataName = [self.gstr GetEkadasiName:t.astrodata.nMasa forPaksa:t.astrodata.nPaksa];
						t.nFastType = FAST_EKADASI;
					}
				}
			}
		}
	}
	// test for break fast
	
	if (s.nFastType == FAST_EKADASI)
	{
		CalculateEParana(s, t, earth);
		
	}
	
	return 1;
}

-(GcDayFestival *)GetSpecFestivalRecord:(int)i forClass:(int)inClass
{
	GcDayFestival * p = [[GcDayFestival alloc] init];
	switch(i)
	{
		case SPEC_JANMASTAMI:
			p.name = [self.gstr string:741];
			p.group = inClass;
			p.fast = (disp.old_style ? FAST_MIDNIGHT : FAST_TODAY);
			p.fastSubj = @"Sri Krsna";
			break;
		case SPEC_GAURAPURNIMA:
			p.name = [self.gstr string:742];
			p.group = inClass;
			p.fast = (disp.old_style ? FAST_MOONRISE : FAST_TODAY);
			p.fastSubj = @"Sri Caitanya Mahaprabhu";
			break;
		case SPEC_RETURNRATHA:
			p.name = [self.gstr string:743];
			p.group = inClass;
			break;
		case SPEC_HERAPANCAMI:
			p.name = [self.gstr string:744];
			p.group = inClass;
			break;
		case SPEC_GUNDICAMARJANA:
			p.name = [self.gstr string:745];
			p.group = inClass;
			break;
		case SPEC_GOVARDHANPUJA:
			p.name = [self.gstr string:746];
			p.group = inClass;
			break;
		case SPEC_RAMANAVAMI:
			p.name = [self.gstr string:747];
			p.group = inClass;
			p.fast = (disp.old_style ? FAST_SUNSET : FAST_TODAY);
			p.fastSubj = @"Sri Ramacandra";
			break;
		case SPEC_RATHAYATRA:
			p.name = [self.gstr string:748];
			p.group = inClass;
			break;
		case SPEC_NANDAUTSAVA:
			p.name = [self.gstr string:749];
			p.group = inClass;
			break;
		case SPEC_PRABHAPP:
			p.name = [self.gstr string:759];
			p.group = inClass;
			p.fast = (disp.old_style ? FAST_NOON : FAST_NULL);
			p.fastSubj = @"Srila Prabhupada";
			break;
		case SPEC_MISRAFESTIVAL:
			p.name = [self.gstr string:750];
			p.group = inClass;
			break;
		default:
			p.name = [self.gstr string:64];
			p.group = inClass;
			return nil;
	}
	
	return p;
}

/******************************************************************************************/
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/******************************************************************************************/

-(int)CompleteCalc:(int)nIndex location:(gc_earth)earth
{
	GCCalendarDay * tmptr = nil;
	GCCalendarDay * s = [m_pData objectAtIndex:(nIndex - 1)];
	GCCalendarDay * t = [m_pData objectAtIndex:nIndex];
	GCCalendarDay * u = [m_pData objectAtIndex:(nIndex + 1)];
	GCCalendarDay * v = [m_pData objectAtIndex:(nIndex + 2)];
	
	// test for Govardhan-puja
	if (t.astrodata.nMasa == DAMODARA_MASA)
	{
		if (t.astrodata.nTithi == TITHI_GAURA_PRATIPAT)
		{
			gc_daytime mrise;
			gc_daytime mset;
			CalcMoonTimes(earth, u.date, s.nDST, &mrise, &mset);
			s.moonrise = mrise;
			s.moonset  = mset;
			CalcMoonTimes(earth, t.date, t.nDST, &mrise, &mset);
			t.moonrise = mrise;
			t.moonset  = mset;
			if (s.astrodata.nTithi == TITHI_GAURA_PRATIPAT)
			{
			}
			else if (u.astrodata.nTithi == TITHI_GAURA_PRATIPAT)
			{
				if (t.moonrise.hour >= 0)
				{
					if (gc_daytime_gt(t.moonrise, t.astrodata.sun.rise))
						// today is GOVARDHANA PUJA
						[t AddSpecFestival:SPEC_GOVARDHANPUJA withClass:1 source:self];
					else
						[u AddSpecFestival:SPEC_GOVARDHANPUJA withClass:1 source:self];
				}
				else if (u.moonrise.hour >= 0)
				{
					if (gc_daytime_lt(u.moonrise, u.astrodata.sun.rise))
						// today is GOVARDHANA PUJA
						[t AddSpecFestival:SPEC_GOVARDHANPUJA withClass:1 source:self];
					else
						[u AddSpecFestival:SPEC_GOVARDHANPUJA withClass:1 source:self];
				}
				else
				{
					[t AddSpecFestival:SPEC_GOVARDHANPUJA withClass:1 source:self];
				}
			}
			else
			{
				// today is GOVARDHANA PUJA
				[t AddSpecFestival:SPEC_GOVARDHANPUJA withClass:1 source:self];
			}
			
		}
		else if ((t.astrodata.nTithi == TITHI_GAURA_DVITIYA) && (s.astrodata.nTithi == TITHI_AMAVASYA))
		{
			// today is GOVARDHANA PUJA
			[t AddSpecFestival:SPEC_GOVARDHANPUJA withClass:1 source:self];
		}
	}
	
	int mid_nak_t, mid_nak_u;
	
	if (t.astrodata.nMasa == HRSIKESA_MASA)
	{
		// test for Janmasthami
		if (IsFestivalDay(s, t, TITHI_KRSNA_ASTAMI))
		{
			// if next day is not astami, so that means that astami is not vriddhi
			// then today is SKJ
			if (u.astrodata.nTithi != TITHI_KRSNA_ASTAMI)
			{
				// today is Sri Krsna Janmasthami
				[t AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
				[u AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
				[u AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
				//				t.nFastType = FAST_MIDNIGHT;
			}
			else // tithi is vriddhi and we have to test both days
			{
				// test when both days have ROHINI
				if ((t.astrodata.nNaksatra == ROHINI_NAKSATRA) && (u.astrodata.nNaksatra == ROHINI_NAKSATRA))
				{
					mid_nak_t = (int)DayCalcEx(t.date, earth, DCEX_NAKSATRA_MIDNIGHT);
					mid_nak_u = (int)DayCalcEx(u.date, earth, DCEX_NAKSATRA_MIDNIGHT);
					
					// test when both days have modnight naksatra ROHINI
					if ((ROHINI_NAKSATRA == mid_nak_u) && (mid_nak_t == ROHINI_NAKSATRA))
					{
						// choice day which is monday or wednesday
						if ((u.date.dayOfWeek == DW_MONDAY) || (u.date.dayOfWeek == DW_WEDNESDAY))
						{
							[u AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
							[v AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
							[v AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
							//							u.nFastType = FAST_MIDNIGHT;
						}
						else
						{
							// today is Sri Krsna Janmasthami
							[t AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
							[u AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
							[u AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
							//							t.nFastType = FAST_MIDNIGHT;
						}
					}
					else if (mid_nak_t == ROHINI_NAKSATRA)
					{
						// today is Sri Krsna Janmasthami
						[t AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
						[u AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
						//						t.nFastType = FAST_MIDNIGHT;
						[u AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
					}
					else if (mid_nak_u == ROHINI_NAKSATRA)
					{
						[u AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
						[v AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
						[v AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
						//						u.nFastType = FAST_MIDNIGHT;
					}
					else
					{
						if ((u.date.dayOfWeek == DW_MONDAY) || (u.date.dayOfWeek == DW_WEDNESDAY))
						{
							[u AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
							[v AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
							[v AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
							//							u.nFastType = FAST_MIDNIGHT;
						}
						else
						{
							// today is Sri Krsna Janmasthami
							[t AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
							[u AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
							[u AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
							//							t.nFastType = FAST_MIDNIGHT;
						}
					}
				}
				else if (t.astrodata.nNaksatra == ROHINI_NAKSATRA)
				{
					// today is Sri Krsna Janmasthami
					[t AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
					[u AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
					[u AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
					//					t.nFastType = FAST_MIDNIGHT;
				}
				else if (u.astrodata.nNaksatra == ROHINI_NAKSATRA)
				{
					[u AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
					[v AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
					[v AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
					//					u.nFastType = FAST_MIDNIGHT;
				}
				else
				{
					if ((u.date.dayOfWeek == DW_MONDAY) || (u.date.dayOfWeek == DW_WEDNESDAY))
					{
						[u AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
						[v AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
						[v AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
						//						u.nFastType = FAST_MIDNIGHT;
					}
					else
					{
						// today is Sri Krsna Janmasthami
						[t AddSpecFestival:SPEC_JANMASTAMI withClass:0 source:self];
						[u AddSpecFestival:SPEC_NANDAUTSAVA withClass:1 source:self];
						[u AddSpecFestival:SPEC_PRABHAPP withClass:2 source:self];
						//						t.nFastType = FAST_MIDNIGHT;
					}
				}
			}
		}
	}
	
	// test for RathaYatra
	if (t.astrodata.nMasa == VAMANA_MASA)
	{
		if (IsFestivalDay(s, t, TITHI_GAURA_DVITIYA))
		{
			NSLog(@"Added Rathayatra to %@\n", [t.date longDateString]);
			[t AddSpecFestival:SPEC_RATHAYATRA withClass:1 source:self];
		}
		
		if (nIndex > 4)
		{
			if (IsFestivalDay([m_pData objectAtIndex:(nIndex - 5)], [m_pData objectAtIndex:(nIndex - 4)], TITHI_GAURA_DVITIYA))
			{
				[t AddSpecFestival:SPEC_HERAPANCAMI withClass:1 source:self];
			}
		}
		
		if (nIndex > 8)
		{
			if (IsFestivalDay([m_pData objectAtIndex:(nIndex - 9)], [m_pData objectAtIndex:(nIndex - 8)], TITHI_GAURA_DVITIYA))
			{
				[t AddSpecFestival:SPEC_RETURNRATHA withClass:1 source:self];
			}
		}
		
		if (IsFestivalDay([m_pData objectAtIndex:nIndex], [m_pData objectAtIndex:(nIndex+1)], TITHI_GAURA_DVITIYA))
		{
			[t AddSpecFestival:SPEC_GUNDICAMARJANA withClass:1 source:self];
		}
		
	}
	
	// test for Gaura Purnima
	if (s.astrodata.nMasa == GOVINDA_MASA)
	{
		if (IsFestivalDay(s, t, TITHI_PURNIMA))
		{
			[t AddSpecFestival:SPEC_GAURAPURNIMA withClass:0 source:self];
			//			t.nFastType = FAST_MOONRISE;
		}
	}
	
	// test for Jagannatha Misra festival
	tmptr = [m_pData objectAtIndex:(nIndex-2)];
	if (tmptr.astrodata.nMasa == GOVINDA_MASA)
	{
		if (IsFestivalDay(tmptr, s, TITHI_PURNIMA))
		{
			[t AddSpecFestival:SPEC_MISRAFESTIVAL withClass:1 source:self];
		}
	}
	
	
	// ------------------------
	// test for other festivals
	// ------------------------
	if (t.astrodata.nMasa <= 11)
	{
		int nt, ns, ns2;
		NSPredicate * pred = nil;
		NSArray * addEventsArray = nil;
		ns = s.astrodata.nMasa * 30 + s.astrodata.nTithi;
		nt = t.astrodata.nMasa * 30 + t.astrodata.nTithi;
		ns2 = (nt + 359 ) % 360; // this is index into table of festivals for previous tithi
	
		if (ns == nt) {
			// this is case, when t is second day of vriddhi
		}
		else if (ns == ns2) {
			// this is normal case, when s is previous tithi to t
			pred = [NSPredicate predicateWithFormat:@"tithi=%d and masa=%d and used=YES and visible=YES", t.astrodata.nTithi, t.astrodata.nMasa];
			addEventsArray = [events filteredArrayUsingPredicate:pred];
		}
		else {
			// this is case (when previous tithi is not t and not t-1, so it can be only t-2
			// that means between s and t is another tithi
			pred = [NSPredicate predicateWithFormat:@"((tithi=%d and masa=%d) or (tithi=%d and masa=%d)) and used=YES and visible=YES"
					, t.astrodata.nTithi, t.astrodata.nMasa, ns2%30, ns2/30];
			addEventsArray = [events filteredArrayUsingPredicate:pred];
		}
		if (addEventsArray)
		{
			//NSLog(@"---a begin==\n");
			if (t.festivals == nil) {
				t.festivals = [NSMutableArray new];
			}
			for(GcDayFestival * pit in addEventsArray)
			{
				[t.festivals addObject:[pit copy]];
			}
			//[t.festivals addObjectsFromArray:addEventsArray];
			addEventsArray = nil;
			//NSLog(@"---a end==\n");
		}
	}
	
	// ---------------------------
	// bhisma pancaka test
	// ---------------------------
	
	if (t.astrodata.nMasa == DAMODARA_MASA)
	{
		if ((t.astrodata.nPaksa == GAURA_PAKSA) && (t.nFastType == FAST_EKADASI))
		{
			[t AddFestival:[self.gstr string:81]];
		}
	}
	
	// ---------------------------
	// caturmasya tests
	// ---------------------------
	
	// first month for punima and ekadasi systems
	if (t.astrodata.nMasa == VAMANA_MASA)
	{
		// purnima system
		if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_GAURA_CATURDASI, TITHI_PURNIMA))
		{
			t.nCaturmasya |= CMASYA_PURN_1_FIRST;
		}
		
		// ekadasi system
		//if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_GAURA_DASAMI, TITHI_GAURA_EKADASI))
		if ((t.astrodata.nPaksa == GAURA_PAKSA) && (t.nMhdType != EV_NULL))
		{
			t.nCaturmasya |= CMASYA_EKAD_1_FIRST;
		}
	}
	
	// first month for pratipat system
	// month transit for purnima and ekadasi systems
	if (t.astrodata.nMasa == SRIDHARA_MASA)
	{
		if (s.astrodata.nMasa == ADHIKA_MASA)
		{
			t.nCaturmasya = CMASYA_1_CONT;
		}
		
		// pratipat system
		if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_PURNIMA, TITHI_KRSNA_PRATIPAT))
		{
			t.nCaturmasya |= CMASYA_PRAT_1_FIRST;
		}
		
		// first day of particular month for PURNIMA system, when purnima is not KSAYA
		if (TITHI_TRANSIT(t.astrodata.nTithi, u.astrodata.nTithi, TITHI_GAURA_CATURDASI, TITHI_PURNIMA))
		{
			u.nCaturmasya |= CMASYA_PURN_2_FIRST;
			t.nCaturmasya |= CMASYA_PURN_1_LAST;
		}
		
		// ekadasi system
		//if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_GAURA_DASAMI, TITHI_GAURA_EKADASI))
		if ((t.astrodata.nPaksa == GAURA_PAKSA) && (t.nMhdType != EV_NULL))
		{
			t.nCaturmasya |= CMASYA_EKAD_2_FIRST;
			s.nCaturmasya |= CMASYA_EKAD_1_LAST;
		}
	}
	
	// second month for pratipat system
	// month transit for purnima and ekadasi systems
	if (t.astrodata.nMasa == HRSIKESA_MASA)
	{
		if (s.astrodata.nMasa == ADHIKA_MASA)
		{
			t.nCaturmasya = CMASYA_2_CONT;
		}
		
		// pratipat system
		if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_PURNIMA, TITHI_KRSNA_PRATIPAT))
			//		if (s.astrodata.nMasa == SRIDHARA_MASA)
		{
			t.nCaturmasya |= CMASYA_PRAT_2_FIRST;
			s.nCaturmasya |= CMASYA_PRAT_1_LAST;
		}
		
		// first day of particular month for PURNIMA system, when purnima is not KSAYA
		if (TITHI_TRANSIT(t.astrodata.nTithi, u.astrodata.nTithi, TITHI_GAURA_CATURDASI, TITHI_PURNIMA))
		{
			u.nCaturmasya |= CMASYA_PURN_3_FIRST;
			t.nCaturmasya |= CMASYA_PURN_2_LAST;
		}
		// ekadasi system
		if ((t.astrodata.nPaksa == GAURA_PAKSA) && (t.nMhdType != EV_NULL))
			//if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_GAURA_DASAMI, TITHI_GAURA_EKADASI))
		{
			t.nCaturmasya |= CMASYA_EKAD_3_FIRST;
			s.nCaturmasya |= CMASYA_EKAD_2_LAST;
		}
	}
	
	// third month for pratipat
	// month transit for purnima and ekadasi systems
	if (t.astrodata.nMasa == PADMANABHA_MASA)
	{
		if (s.astrodata.nMasa == ADHIKA_MASA)
		{
			t.nCaturmasya = CMASYA_3_CONT;
		}
		// pratipat system
		if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_PURNIMA, TITHI_KRSNA_PRATIPAT))
			//		if (s.astrodata.nMasa == HRSIKESA_MASA)
		{
			t.nCaturmasya |= CMASYA_PRAT_3_FIRST;
			s.nCaturmasya |= CMASYA_PRAT_2_LAST;
		}
		
		// first day of particular month for PURNIMA system, when purnima is not KSAYA
		if (TITHI_TRANSIT(t.astrodata.nTithi, u.astrodata.nTithi, TITHI_GAURA_CATURDASI, TITHI_PURNIMA))
		{
			u.nCaturmasya |= CMASYA_PURN_4_FIRST;
			t.nCaturmasya |= CMASYA_PURN_3_LAST;
		}
		
		// ekadasi system
		if ((t.astrodata.nPaksa == GAURA_PAKSA) && (t.nMhdType != EV_NULL))
			//if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_GAURA_DASAMI, TITHI_GAURA_EKADASI))
		{
			t.nCaturmasya |= CMASYA_EKAD_4_FIRST;
			s.nCaturmasya |= CMASYA_EKAD_3_LAST;
		}
	}
	
	// fourth month for pratipat system
	// month transit for purnima and ekadasi systems
	if (t.astrodata.nMasa == DAMODARA_MASA)
	{
		if (s.astrodata.nMasa == ADHIKA_MASA)
		{
			t.nCaturmasya = CMASYA_4_CONT;
		}
		// pratipat system
		if (TITHI_TRANSIT(s.astrodata.nTithi, t.astrodata.nTithi, TITHI_PURNIMA, TITHI_KRSNA_PRATIPAT))
		{
			t.nCaturmasya |= CMASYA_PRAT_4_FIRST;
			s.nCaturmasya |= CMASYA_PRAT_3_LAST;
		}
		
		// last day for punima system
		if (TITHI_TRANSIT(t.astrodata.nTithi, u.astrodata.nTithi, TITHI_GAURA_CATURDASI, TITHI_PURNIMA))
		{
			t.nCaturmasya |= CMASYA_PURN_4_LAST;
		}
		
		// ekadasi system
		//if (TITHI_TRANSIT(t.astrodata.nTithi, u.astrodata.nTithi, TITHI_GAURA_DASAMI, TITHI_GAURA_EKADASI))
		if ((t.astrodata.nPaksa == GAURA_PAKSA) && (t.nMhdType != EV_NULL))
		{
			s.nCaturmasya |= CMASYA_EKAD_4_LAST;
		}
		
		if (TITHI_TRANSIT(t.astrodata.nTithi, u.astrodata.nTithi, TITHI_PURNIMA, TITHI_KRSNA_PRATIPAT))
		{
			t.nCaturmasya |= CMASYA_PRAT_4_LAST;
			
			// on last day of Caturmasya pratipat system is Bhisma Pancaka ending
			[t AddFestival:[self.gstr string:82]];
		}
	}
	
	// vaisnava calendar calculations are valid
	t.fVaisValid = true;
	
	return 1;
}


/******************************************************************************************/
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/******************************************************************************************/

-(int)MahadvadasiCalc:(int)nIndex location:(gc_earth)earth
{
	int nMahaType = 0;
	int nMhdDay = -1;
	
	GCCalendarDay * s = [m_pData objectAtIndex:(nIndex - 1)];
	GCCalendarDay * t = [m_pData objectAtIndex:nIndex];
	GCCalendarDay * u = [m_pData objectAtIndex:(nIndex + 1)];
	
	// if yesterday is dvadasi
	// then we skip this day
	if (TITHI_DVADASI(s.astrodata.nTithi))
		return 1;
	
	if (TITHI_GAURA_DVADASI == t.astrodata.nTithi && TITHI_GAURA_DVADASI == t.astrodata.nTithiSunset 
		&& [self IsMhd58:nIndex type:&nMahaType])
	{
		t.nMhdType = nMahaType;
		nMhdDay = nIndex;
	}
	else if (TITHI_DVADASI(t.astrodata.nTithi))
	{
		if (TITHI_DVADASI(u.astrodata.nTithi) && TITHI_EKADASI(s.astrodata.nTithi) && TITHI_EKADASI(s.astrodata.nTithiArunodaya))
		{
			t.nMhdType = EV_VYANJULI;
			nMhdDay = nIndex;
		}
		else if ([self NextNewFullIsVriddhi:nIndex location:earth])
		{
			t.nMhdType = EV_PAKSAVARDHINI;
			nMhdDay = nIndex;
		}
		else if (TITHI_LESS_EKADASI(s.astrodata.nTithiArunodaya))
		{
			t.nMhdType = EV_SUDDHA;
			nMhdDay = nIndex;
		}
	}
	
	if (nMhdDay >= 0)
	{
		// fasting day
		GCCalendarDay * v = [m_pData objectAtIndex:nMhdDay];
		v.nFastType = FAST_EKADASI;
		v.ekadasiVrataName = [self.gstr GetEkadasiName:t.astrodata.nMasa forPaksa:t.astrodata.nPaksa];
		v.isEkadasiParana = NO;
		v.hrEkadasiParanaStart = 0.0;
		v.hrEkadasiParanaEnd = 0.0;
		v.fVaisValid = YES;
		
		// parana day
		GCCalendarDay * w = [m_pData objectAtIndex:(nMhdDay + 1)];
		w.nFastType = FAST_NULL;
		w.isEkadasiParana = YES;
		w.hrEkadasiParanaStart = 0.0;
		w.hrEkadasiParanaEnd = 0.0;
		w.fVaisValid = YES;
	}
	
	return 1;
}

-(GCCalendarDay *)dayAtIndex:(NSInteger)nIndex
{
	int nReturn = nIndex + BEFORE_DAYS;
	
	if (nReturn >= self.m_nCount)
		return NULL;
	
	return [m_pData objectAtIndex:nReturn];
}

-(NSInteger)daysCount
{
    return m_PureCount;
}

/******************************************************************************************/
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/******************************************************************************************/

-(int)ExtendedCalc:(int)nIndex location:(gc_earth)earth
{
	GCCalendarDay * s = [m_pData objectAtIndex:(nIndex - 1)];
	GCCalendarDay * t = [m_pData objectAtIndex:nIndex];
	GCCalendarDay * u = [m_pData objectAtIndex:(nIndex + 1)];
	//	GcDay * v = [m_pData objectAtIndex:(nIndex + 2)];
	
	// test for Rama Navami
	if ((t.astrodata.nMasa == VISNU_MASA) && (t.astrodata.nPaksa == GAURA_PAKSA))
	{
		if (IsFestivalDay(s, t, TITHI_GAURA_NAVAMI))
		{
			if (u.nFastType >= FAST_EKADASI)
			{
				// yesterday was Rama Navami
				[s AddSpecFestival:SPEC_RAMANAVAMI withClass:0 source:self];
				//s.nFastType = FAST_SUNSET;
			}
			else
			{
				// today is Rama Navami
				[t AddSpecFestival:SPEC_RAMANAVAMI withClass:0 source:self];
				//t.nFastType = FAST_SUNSET;
			}
		}
	}
	
	return 1;
}

/******************************************************************************************/
/*                                                                                        */
/*  TEST if today is given festival tithi                                                 */
/*                                                                                        */
/*  if today is given tithi and yesterday is not this tithi                               */
/*  then it is festival day (it is first day of this tithi, when vriddhi)                 */
/*                                                                                        */
/*  if yesterday is previous tithi to the given one and today is next to the given one    */
/*  then today is day after ksaya tithi which is given                                    */
/*                                                                                        */
/*                                                                                        */
/******************************************************************************************/

BOOL IsFestivalDay(GCCalendarDay * yesterday, GCCalendarDay * today, int nTithi)
{
	return ((today.astrodata.nTithi == nTithi) && TITHI_LESS_THAN(yesterday.astrodata.nTithi, nTithi))
	|| (TITHI_LESS_THAN(yesterday.astrodata.nTithi, nTithi) && TITHI_GREAT_THAN(today.astrodata.nTithi, nTithi));	
}

-(int)FindDate:(GCGregorianTime *)vc
{
	int i;
	for(i = BEFORE_DAYS; i < self.m_PureCount + BEFORE_DAYS; i++)
	{
		GCCalendarDay * P = [m_pData objectAtIndex:i];
		if ((P.date.day == vc.day) && (P.date.month == vc.month) && (P.date.year == vc.year))
			return (i - BEFORE_DAYS);
	}
	
	return -1;
}

-(GCCalendarDay *)findCalendarDay:(GCGregorianTime *)vc
{
    for (GCCalendarDay * P in m_pData) {
        if ((P.date.day == vc.day) && (P.date.month == vc.month) && (P.date.year == vc.year))
            return P;
    }
    
    return nil;
}

double GcGetNaksatraEndHour(gc_earth earth, GCGregorianTime * yesterday, GCGregorianTime * today)
{
	GCGregorianTime * nend;
	GCGregorianTime * snd = [yesterday copy];
	snd.shour = 0.5;
	GetNextNaksatra(earth, snd, &nend);
	return [nend julian] - [today julian] + nend.shour;
}

int CalculateEParana(GCCalendarDay * s, GCCalendarDay * t, gc_earth earth)
{
	t.nMhdType = EV_NULL;
	t.isEkadasiParana = true;
	t.nFastType = FAST_NULL;
	
	double tithiStartTime, titEnd, tithi_quart;
	double sunRise, sunSet, third_day, naksEnd;
	double parBeg = -1.0, parEnd = -1.0;
	double tithi_len;
	//gc_time snd, nend;
	
	/*sunRise = t.astrodata.sun.sunrise_deg / 360.0 + earth.tzone / 24.0;
	third_day = sunRise + t.astrodata.sun.length_deg / 1080.0;
    tithi_len = GetTithiTimes(earth, t.date, &tithiStartTime, &titEnd, sunRise);
    tithi_quart = tithi_len / 4.0 + tithiStartTime;
    */
    //if (t.date.day == 13 && t.date.month == 6)
    {
        GCCoreEvent * startTithi = nil;
        GCCoreEvent * endTithi = nil;
        GCCoreEvent * endNaksatra = nil;
        int findStartTithi = 1;
        int findEndTithi = 0;
        int findEndNaksatra = 1;
        GCCalendarDay * cde = s;
        for (GCCoreEvent * ce in cde.coreEvents) {
            if (ce.type == CET_TITHI)
            {
                tithiStartTime = -1.0;
                startTithi = ce;
            }
        }
        cde = t;
        //int mode = 1;
        for (GCCoreEvent * ce in cde.coreEvents) {
            if (ce.type == CET_TITHI && findStartTithi == 1)
            {
                tithiStartTime = 0.0;
                startTithi = ce;
            }
            if (ce.type == CET_SUNRISE)
            {
                findStartTithi = 2;
                findEndTithi = 1;
                findEndNaksatra = 1;
                sunRise = ce.seconds / 86400.0;
            }
            if (ce.type == CET_TITHI && findEndTithi == 1)
            {
                titEnd = 0.0;
                endTithi = ce;
                findEndTithi = 2;
            }
            if (ce.type == CET_SUNSET)
            {
                sunSet = ce.seconds / 86400.0;
            }
            if (ce.type == CET_NAKSATRA && findEndNaksatra == 1)
            {
                endNaksatra = ce;
                findEndNaksatra = 2;
            }
        }
        cde = cde.nextDay;
        if (findEndTithi == 1)
        {
            for (GCCoreEvent * ce in cde.coreEvents) {
                if (ce.type == CET_TITHI)
                {
                    titEnd = 1.0;
                    endTithi = ce;
                    break;
                }
            }
        }

        third_day = (sunSet - sunRise) / 3 + sunRise;
        tithiStartTime += startTithi.seconds / 86400.0;
        titEnd += endTithi.seconds / 86400.0;
        tithi_len = titEnd - tithiStartTime;
        tithi_quart = tithi_len / 4.0 + tithiStartTime;
        naksEnd = endNaksatra.seconds / 86400.0;
    }
    
	
    NSLog(@"CALCULATE EPARANA %@", [t.date longDateString]);
	switch(s.nMhdType)
	{
		case EV_UNMILANI:
            NSLog(@"UNMILANI titBeg=%f, titEnd=%f, thirdDay=%f, sunRise=%f, tithiQuart=%f\n", tithiStartTime, titEnd, third_day, sunRise, tithi_quart);
			parEnd = titEnd;
			if (parEnd > third_day)
				parEnd = third_day;
			parBeg = sunRise;
			break;
		case EV_VYANJULI:
            NSLog(@"VYANJULI titBeg=%f, titEnd=%f, thirdDay=%f, sunRise=%f", tithiStartTime, titEnd, third_day, sunRise);
			parBeg = sunRise;
			parEnd = MIN(titEnd, third_day);
			break;
		case EV_TRISPRSA:
            NSLog(@"TRISPRSA thirdDay=%f, sunRise=%f", third_day, sunRise);
			parBeg = sunRise;
			parEnd = third_day;
			break;
		case EV_JAYANTI:
		case EV_VIJAYA:
			
			//naksEnd = GcGetNaksatraEndHour(earth, s.date, t.date); //GetNextNaksatra(earth, snd, nend);
            //NSLog(@"JAYANTI, VIJAYA titBeg=%f, titEnd=%f, thirdDay=%f, sunRise=%f, naksEnd=%f\n", tithiStartTime, titEnd, third_day, sunRise, naksEnd);
			if (TITHI_DVADASI(t.astrodata.nTithi))
			{
				if (naksEnd < titEnd)
				{
					if (naksEnd < third_day)
					{
						parBeg = naksEnd;
						parEnd = MIN(titEnd, third_day);
					}
					else
					{
						parBeg = naksEnd;
						parEnd = titEnd;
					}
				}
				else
				{
					parBeg = sunRise;
					parEnd = MIN(titEnd, third_day);
				}
			}
			else
			{
				parBeg = sunRise;
				parEnd = MIN( naksEnd, third_day );
			}
			
			break;
		case EV_JAYA:
		case EV_PAPA_NASINI:
			
			//naksEnd = GcGetNaksatraEndHour(earth, s.date, t.date); //GetNextNaksatra(earth, snd, nend);

            //NSLog(@"JAYA, PAPANASINI titBeg=%f, titEnd=%f, thirdDay=%f, sunRise=%f, naksEnd=%f\n", tithiStartTime, titEnd, third_day, sunRise, naksEnd);
			
			if (TITHI_DVADASI(t.astrodata.nTithi))
			{
				if (naksEnd < titEnd)
				{
					if (naksEnd < third_day)
					{
						parBeg = naksEnd;
						parEnd = MIN(titEnd, third_day);
					}
					else
					{
						parBeg = naksEnd;
						parEnd = titEnd;
					}
				}
				else
				{
					parBeg = sunRise;
					parEnd = MIN(titEnd, third_day);
				}
			}
			else
			{
				if (naksEnd < third_day)
				{
					parBeg = naksEnd;
					parEnd = third_day;
				}
				else
				{
					parBeg = naksEnd;
					parEnd = -1.0;
				}
			}
			
			break;
		default:
			// first initial
            //if (t.date.day == 13 && t.date.month == 6)
            //{
            //    NSLog(@"---");
            //}
			//NSLog(@"DEFAULT titBeg=%f, titEnd=%f, thirdDay=%f, sunRise=%f, tithiQuart=%f\n", tithiStartTime, titEnd, third_day, sunRise, tithi_quart);
			parEnd = MIN(titEnd, third_day);
			parBeg = MAX(sunRise, tithi_quart);
			
			if (TITHI_DVADASI(s.astrodata.nTithi))
			{
				parBeg = sunRise;
			}
			
			//if (parBeg > third_day)
			if (parBeg > parEnd)
			{	
				//			parBeg = sunRise;
				parEnd = -1.0;
			}
			break;
	}

    //if (t.date.day == 13 && t.date.month == 6)
    //{
    //NSLog(@"EKADASI PARANA %f - %f", parBeg, parEnd);
    //}
    if (parBeg > 0)
        parBeg *= 24.0;
    if (parEnd > 0)
        parEnd *= 24.0;

	t.hrEkadasiParanaStart = parBeg;
	t.hrEkadasiParanaEnd = parEnd;
	
	return 1;
}


/* Function before is writen accoring this algorithms:
 
 
 1. Normal - fasting day has ekadasi at sunrise and dvadasi at next sunrise.
 
 2. Viddha - fasting day has dvadasi at sunrise and trayodasi at next
 sunrise, and it is not a naksatra mahadvadasi
 
 3. Unmilani - fasting day has ekadasi at both sunrises
 
 4. Vyanjuli - fasting day has dvadasi at both sunrises, and it is not a
 naksatra mahadvadasi
 
 5. Trisprsa - fasting day has ekadasi at sunrise and trayodasi at next
 sunrise.
 
 6. Jayanti/Vijaya - fasting day has gaura dvadasi and specified naksatra at
 sunrise and same naksatra at next sunrise
 
 7. Jaya/Papanasini - fasting day has gaura dvadasi and specified naksatra at
 sunrise and same naksatra at next sunrise
 
 ==============================================
 Case 1 Normal (no change)
 
 If dvadasi tithi ends before 1/3 of daylight
 then PARANA END = TIME OF END OF TITHI
 but if dvadasi TITHI ends after 1/3 of daylight
 then PARANA END = TIME OF 1/3 OF DAYLIGHT
 
 if 1/4 of dvadasi tithi is before sunrise
 then PARANA BEGIN is sunrise time
 but if 1/4 of dvadasi tithi is after sunrise
 then PARANA BEGIN is time of 1/4 of dvadasi tithi
 
 if PARANA BEGIN is before PARANA END
 then we will write "BREAK FAST FROM xx TO yy
 but if PARANA BEGIN is after PARANA END
 then we will write "BREAK FAST AFTER xx"
 
 ==============================================
 Case 2 Viddha
 
 If trayodasi tithi ends before 1/3 of daylight
 then PARANA END = TIME OF END OF TITHI
 but if trayodasi TITHI ends after 1/3 of daylight
 then PARANA END = TIME OF 1/3 OF DAYLIGHT
 
 PARANA BEGIN is sunrise time
 
 we will write "BREAK FAST FROM xx TO yy
 
 ==============================================
 Case 3 Unmilani
 
 PARANA END = TIME OF 1/3 OF DAYLIGHT
 
 PARANA BEGIN is end of Ekadasi tithi
 
 if PARANA BEGIN is before PARANA END
 then we will write "BREAK FAST FROM xx TO yy
 but if PARANA BEGIN is after PARANA END
 then we will write "BREAK FAST AFTER xx"
 
 ==============================================
 Case 4 Vyanjuli
 
 PARANA BEGIN = Sunrise
 
 PARANA END is end of Dvadasi tithi
 
 we will write "BREAK FAST FROM xx TO yy
 
 ==============================================
 Case 5 Trisprsa
 
 PARANA BEGIN = Sunrise
 
 PARANA END = 1/3 of daylight hours
 
 we will write "BREAK FAST FROM xx TO yy
 
 ==============================================
 Case 6 Jayanti/Vijaya
 
 PARANA BEGIN = Sunrise
 
 PARANA END1 = end of dvadasi tithi or sunrise, whichever is later
 PARANA END2 = end of naksatra
 
 PARANA END is earlier of END1 and END2
 
 we will write "BREAK FAST FROM xx TO yy
 
 ==============================================
 Case 7 Jaya/Papanasini
 
 PARANA BEGIN = end of naksatra
 
 PARANA END = 1/3 of Daylight hours
 
 if PARANA BEGIN is before PARANA END
 then we will write "BREAK FAST FROM xx TO yy
 but if PARANA BEGIN is after PARANA END
 then we will write "BREAK FAST AFTER xx"
 
 
 
 */



-(void)ResolveFestivalsFasting:(int)nIndex
{
	GCCalendarDay * s = [m_pData objectAtIndex:(nIndex - 1)];
	GCCalendarDay * t = [m_pData objectAtIndex:nIndex];
	GCCalendarDay * u = [m_pData objectAtIndex:(nIndex + 1)];
	
    GcDayFestival * gcfest = nil;
    
	//int nf, nf2, nftype;
	//NSString * pers, * str, * S;
	int fasting = t.nFastType;
	NSString * ch;
	if (t.nMhdType != EV_NULL)
	{
		gcfest = [t AddFestival:[NSString stringWithFormat:@"%@ %@"
					, [self.gstr string:87], t.ekadasiVrataName]];
        gcfest.highlight = 1;
	}
	//NSLog(@"---yeue ty---\n");
	
	ch = [self.gstr GetMahadvadasiName:t.nMhdType];
	if (ch) 
	{
		gcfest = [t AddFestival:ch];
        gcfest.highlight = 3;
	}
	
	//NSLog(@"---yeue---\n");
	// analyze for fasting
	NSMutableArray * temp = [[NSMutableArray alloc] initWithArray:t.festivals];
	[t.festivals removeAllObjects];
	for(GcDayFestival * pdf in temp)
	{
        if (disp.old_style == NO)
        {
            if (pdf.fast < FAST_NOON_VISNU)
                pdf.fast = FAST_NULL;
            else
                pdf.fast = FAST_TODAY;
            //NSLog(@"--after modify   fasting=%d\n", pdf.fast);
        }

        gcfest = [t AddFestival:pdf.name];
        gcfest.highlight = (pdf.fast != FAST_NULL && pdf.fast != FAST_EKADASI) ? 2 : pdf.highlight;
        gcfest.group = pdf.group;
		
        if (fasting < pdf.fast && fasting != FAST_EKADASI)
			fasting = pdf.fast;
		if (pdf.fast != FAST_NULL)
		{
			if (s.nFastType == FAST_EKADASI)
			{
				gcfest = [s AddFestival:[NSString stringWithFormat:@"(Fast till noon for %@, with feast tomorrow)", pdf.fastSubj]];
                gcfest.highlight = 3;
				gcfest = [t AddFestival:@"(Fasting is done yesterday, today is feast)"];
                gcfest.highlight = 3;
				pdf.fast = FAST_NULL;
				pdf.fastSubj = nil;
			}
			else if (t.nFastType == FAST_EKADASI)
			{
				gcfest = [t AddFestival:@"(Fasting till noon, with feast tomorrow)"];
                gcfest.highlight = 3;
				pdf.fast = FAST_NULL;
				pdf.fastSubj = nil;
			}
			else
			{
				//NSLog(@"day %@   fasting %d\n", [gstr dateToString:t.date], pdf.fast);
				gcfest = [t AddFestival:[self.gstr GetFastingName:pdf.fast]];
                gcfest.highlight = 1;
				pdf.fast = FAST_NULL;
			}
		}
	}
	[temp removeAllObjects];
	
	if (fasting)
	{
		if (s.nFastType == FAST_EKADASI)
		{
			t.nFeasting = FEAST_TODAY_FAST_YESTERDAY;
			s.nFeasting = FEAST_TOMMOROW_FAST_TODAY;
		}
		else if (t.nFastType == FAST_EKADASI)
		{
			u.nFeasting = FEAST_TODAY_FAST_YESTERDAY;
			t.nFeasting = FEAST_TOMMOROW_FAST_TODAY;
		}
		else
		{
			t.nFastType = fasting;
		}
	}
	
}

-(void)appendCalendarColumnsHeader:(NSMutableString *)str format:(int)iFormat
{
	int i1, i2;
	switch(iFormat)
	{
	case 0:
		i1 = [str length];
		[str appendFormat:@" DATE            TITHI                             "];
		if (disp.paksa)    [str appendFormat:@"P "];
		if (disp.yoga)     [str appendFormat:@"YOGA      "];
		if (disp.naksatra) [str appendFormat:@"NAKSATRA       "];
		if (disp.fast)     [str appendFormat:@"FAST "];
		if (disp.rasi)     [str appendFormat:@"RASI        "];
		i2 = [str length] + 1;
		[str appendFormat:@"\n"];
		while(i1 < i2) {
			[str appendFormat:@"-"];
			i1++;
		}
		[str appendFormat:@"\n"];
		break;
	case 1:
		[str appendFormat:@"\\par{\\highlight15\\cf7\\fs%d\\b DATE\\tab TITHI", disp.textNoteSize];
		if (disp.paksa)    [str appendFormat:@"\\tab PAKSA"];
		if (disp.yoga)     [str appendFormat:@"\\tab YOGA"];
		if (disp.naksatra) [str appendFormat:@"\\tab NAKSATRA"];
		if (disp.fast)     [str appendFormat: @"\\tab FAST"];
		if (disp.rasi)     [str appendFormat: @"\\tab RASI"];
		[str appendFormat: @"}"];
		break;
	case 2:
		[str appendFormat:@"<tr>"];
		[str appendFormat:@"<td  class=\"hed\" colspan=2 width=85pt>DATE</td>"];
		[str appendFormat:@"<td class=\"hed\" width=150pt>TITHI</td>"];
		if (disp.paksa)    [str appendFormat:@"<td class=\"hed\" width=20pt>PAKSA</td>"];
		if (disp.naksatra) [str appendFormat:@"<td class=\"hed\" width=100pt>NAKSATRA</td>"];
		if (disp.yoga)     [str appendFormat:@"<td class=\"hed\" width=100pt>YOGA</td>"];
		if (disp.fast)     [str appendFormat:@"<td class=\"hed\" width=30pt>FAST</td>"];
		if (disp.rasi)     [str appendFormat:@"<td class=\"hed\" width=100pt>RASI</td>"];
		[str appendFormat:@"</tr>"];
		break;
	case 3:
		break;
	default:
		break;
	}
}

-(NSString *)formatCalendarXml
{
	int k;
	//NSString *str, * st;
	gc_time date;
	NSMutableString * xml = [[NSMutableString alloc] initWithCapacity:8000];
	GCCalendarDay * pvd;
	int nPrevMasa = -1;
	//	int nPrevPaksa = -1;
	
	[xml appendFormat:@"<xml>\n"];
	[xml appendFormat:@"\t<request name=\"Calendar\" version=\"%@\">\n", [self.gstr string:130]];
	[xml appendFormat:@"\t\t<arg name=\"longitude\" val=\"%f\" />\n", self.m_Location.longitude];
	[xml appendFormat:@"\t\t<arg name=\"latitude\" val=\"%f\" />\n", self.m_Location.latitude];
	[xml appendFormat:@"\t\t<arg name=\"timezone\" val=\"%f\" />\n", [self.m_Location timeZoneOffset]];
	[xml appendFormat:@"\t\t<arg name=\"startdate\" val=\"%@\" />\n", [self.m_vcStart shortTimeString]];
	[xml appendFormat:@"\t\t<arg name=\"daycount\" val=\"%d\" />\n", self.m_vcCount];
	[xml appendFormat:@"\t\t<arg name=\"dst\" val=\"%@\" />\n", [self.m_Location.timeZone name]];
	[xml appendFormat:@"\t</request>\n"];
	[xml appendFormat:@"\t<result name=\"Calendar\">\n"];
	
	for (k = 0; k < self.m_vcCount; k++)
	{
		pvd = [self dayAtIndex:k];
		if (pvd)
		{
			if (nPrevMasa != pvd.astrodata.nMasa)
			{
				if (nPrevMasa != -1)
					[xml appendFormat:@"\t</masa>\n"];
				[xml appendFormat:@"\t<masa name=\"%@ Masa", [self.gstr GetMasaName:pvd.astrodata.nMasa]];
				if (nPrevMasa == ADHIKA_MASA) {
					[xml appendFormat:@" "];
					[xml appendFormat:@"%@", [self.gstr string:109]];
				}
				[xml appendFormat:@"\""];
				[xml appendFormat:@" gyear=\"Gaurabda %d\"", pvd.astrodata.nGaurabdaYear];
				[xml appendFormat:@">\n"];
			}
			
			nPrevMasa = pvd.astrodata.nMasa;
			
			// date data
			[xml appendFormat:@"\t<day><date>%d/%d/%d</date><dayweek>%@</dayweek>", pvd.date.month, pvd.date.day, pvd.date.year,
				[self.gstr string:pvd.date.dayOfWeek]];
			
			// sunrise data
			[xml appendFormat:@"\t\t<sunrise><time>%02d:%02d:%02d</time>\n", pvd.astrodata.sun.rise.hour, pvd.astrodata.sun.rise.minute, pvd.astrodata.sun.rise.sec];
			
			[xml appendFormat:@"\t\t\t<tithi><name>%@", [self.gstr GetTithiName:pvd.astrodata.nTithi]];
			if ((pvd.astrodata.nTithi == 10) || (pvd.astrodata.nTithi == 25) 
				|| (pvd.astrodata.nTithi == 11) || (pvd.astrodata.nTithi == 26))
			{
				if (pvd.isEkadasiParana == false)
				{
					if (pvd.nMhdType == EV_NULL)
					{
						[xml appendFormat:@" %@", [self.gstr string:58]];
					}
					else
					{
						[xml appendFormat:@" %@", [self.gstr string:59]];
					}
				}
			}
			[xml appendFormat:@"</name><elapse>%.1f</elapse><index>%d</index></tithi>\n"
					   ,pvd.astrodata.nTithiElapse, pvd.astrodata.nTithi % 30 + 1];
			[xml appendFormat:@"\t\t\t<naksatra><name>%@</name><elapse>%.1f</elapse></naksatra>\n"
					   , [self.gstr GetNaksatraName:pvd.astrodata.nNaksatra], pvd.astrodata.nNaksatraElapse];
			[xml appendFormat:@"\t\t\t<yoga><name>%@</name></yoga>\n", [self.gstr GetYogaName:pvd.astrodata.nYoga]];
			[xml appendFormat:@"\t\t\t<paksa><id>%c</id><name>%@</name></paksa>\n", [self.gstr GetPaksaChar:pvd.astrodata.nPaksa], [self.gstr GetPaksaName:pvd.astrodata.nPaksa] ];
			[xml appendFormat:@"\t\t</sunrise>\n"];
			
			[xml appendFormat:@"\t\t<dst>%d</dst>\n", pvd.nDST];
			// arunodaya data
			[xml appendFormat:@"\t\t<arunodaya>\n\t\t\t<time>%@</time>\n", [self.gstr daytimeToString:pvd.astrodata.sun.arunodaya]];
			[xml appendFormat:@"\t\t\t<tithi>%@</tithi>\n", [self.gstr GetTithiName:pvd.astrodata.nTithiArunodaya]];
			[xml appendFormat:@"\t\t</arunodaya>\n"];
			[xml appendFormat:@"\t\t<noon><time>%@</time></noon>\n", [self.gstr daytimeToString:pvd.astrodata.sun.noon]];
			[xml appendFormat:@"\t\t<sunset><time>%@</time></sunset>\n", [self.gstr daytimeToString:pvd.astrodata.sun.set]];
			
			// moon data
			[xml appendFormat:@"\t\t<moon><rise>%@</rise><set>%@</set></moon>\n", [self.gstr daytimeToString:pvd.moonrise], [self.gstr daytimeToString:pvd.moonset]];
			
			if (pvd.isEkadasiParana)
			{
				if (pvd.hrEkadasiParanaEnd >= 0.0)
				{
					[xml appendFormat:@"\t\t<parana><from>%@</from><to>%@</to><parana>\n"
						, [self.gstr hoursToString:pvd.hrEkadasiParanaStart]
						, [self.gstr hoursToString:pvd.hrEkadasiParanaEnd]];
				}
				else
				{
					[xml appendFormat:@"\t\t<parana><after>%@</after></parana>\n"
						, [self.gstr hoursToString:pvd.hrEkadasiParanaStart]];
				}
			}
			
			if ([pvd.festivals count] > 0)
			{
				[xml appendFormat:@"<festivals>\n"];
				for(GcDayFestival * pdf in pvd.festivals)
				{
					[xml appendFormat:@"\t\t<festival><name>%@</name><class>%d</class></festival>\n", pdf.name, pdf.group];
				}
				[xml appendFormat:@"</festivals>\n"];
			}
			
			if (pvd.nFastType != FAST_NULL)
			{
				[xml appendFormat:@"\t\t<fastflag />\n"];
			}
			
			if (pvd.sankranti_zodiac >= 0)
			{
				[xml appendFormat:@"\t\t<sankranti><rasi>%@</rasi><time>%@</time></sankranti>\n"
				 , [self.gstr GetSankrantiName:pvd.sankranti_zodiac], [pvd.sankranti_day shortTimeString]];
			}
			
			if (pvd.was_ksaya)
			{
				double h1, m1, h2, m2;
				m1 = modf(pvd.ksaya_time1*24, &h1);
				m2 = modf(pvd.ksaya_time2*24, &h2);
				[xml appendFormat:@"\t\t<ksaya><from>%02d:%02d</from><to>%02d:%02d</to></ksaya>\n", (int)(h1), abs((int)(m1*60)), (int)(h2), abs((int)(m2*60))];
			}
			
			if (pvd.is_vriddhi)
			{
				[xml appendFormat:@"\t\t<vriddhi />\n"];
			}
			
			if (pvd.nCaturmasya & CMASYA_PURN_MASK)
			{
				[xml appendFormat:@"\t\t<caturmasya><day>%@</day><month>%d</month><system>PURNIMA</system></caturmasya>\n",
					((pvd.nCaturmasya & CMASYA_PURN_MASK_DAY) > 1 ? @"last" : @"first"),
					(int)((pvd.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 4) ];
			}
			
			if (pvd.nCaturmasya & CMASYA_PRAT_MASK)
			{
				[xml appendFormat:@"\t\t<caturmasya><day>%@</day><month>%d</month><system>PURNIMA</system></caturmasya>\n",
					(((pvd.nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8) > 1 ? @"last" : @"first"),
					(int)((pvd.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 12) ];
			}
			
			if (pvd.nCaturmasya & CMASYA_EKAD_MASK)
			{
				[xml appendFormat:@"\t\t<caturmasya><day>%@</day><month>%d</month><system>PURNIMA</system></caturmasya>\n",
					((pvd.nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16) > 1 ? @"last" : @"first"
						   , (int)((pvd.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 20) ];
			}
			
			[xml appendFormat:@"\t</day>\n\n"];
			
		}
		date.shour = 0;
		GetNextDay(&date);
	}
	[xml appendFormat:@"\t</masa>\n"];
	
	
	[xml appendFormat:@"</result>\n</xml>\n"];
	
	return xml;
}

-(NSString *)formatCalendarHTML
{
	int k;
	//NSString * str;
	//gc_time date;
	NSMutableString * xml = [[NSMutableString alloc] initWithCapacity:8000];
	GCCalendarDay * pvd;
	int nPrevMasa = -1;
	
	[xml appendFormat:@"<html><head><title>\n"];
	[xml appendFormat:@"Calendar %d</title>", m_vcStart.year];
	[xml appendFormat:@"<style>\n"];
	[self.gstr addHtmlStylesDef:xml display:disp];
	[xml appendFormat:@"</style>\n"];
	[xml appendFormat:@"</head>\n<body>"];
	
	for (k = 0; k < m_vcCount; k++)
	{
		pvd = [self dayAtIndex:k];
		if (pvd) {
			if (nPrevMasa != pvd.astrodata.nMasa)
			{
				if (nPrevMasa != -1)
					[xml appendFormat:@"\t</table>\n"];
				[xml appendFormat:@"<p class=\'SectionHead\'><span class=\'SectionHead1\'>"];
				[xml appendFormat:@"%@", [self.gstr GetMasaName:pvd.astrodata.nMasa]];
				[xml appendFormat:@" Masa"];
				if (nPrevMasa == ADHIKA_MASA)
					[xml appendFormat:@" %@", [self.gstr string:109]];
				[xml appendFormat:@"</span>"];
				[xml appendFormat:@"<br><span class=\'SectionHead2\'>Gaurabda %d", pvd.astrodata.nGaurabdaYear];
				[xml appendFormat:@"<br>%@</font>",  [self.m_Location fullName] ];
				[xml appendFormat:@"</span></p>\n<table align=center>"];
				[self appendCalendarColumnsHeader:xml format:2];
			}
			
			nPrevMasa = pvd.astrodata.nMasa;
			
			// date data
			[xml appendFormat:@"<tr>"];
			[xml appendFormat:@"<td align=right>%@</td><td>%@</td>\n"
				, [pvd.date longDateString]
				, [[self.gstr string:pvd.date.dayOfWeek] substringToIndex:2] ];
			
			// sunrise data
			//[xml appendFormat:@"\t\t<sunrise time=\"" << pvd.astrodata.sun.rise << "\">\n";
			
			//[xml appendFormat:@"\t\t\t<tithi name=\"";
			[xml appendFormat:@"<td>%@</td>\n", [pvd getTithiNameComplete:self.gstr]];
			
			
			if (disp.paksa)
				[xml appendFormat:@"<td>%@</td>\n", [self.gstr GetPaksaName:pvd.astrodata.nPaksa]];
			if (disp.naksatra)
				[xml appendFormat:@"<td>%@</td>\n", [self.gstr GetNaksatraName:pvd.astrodata.nNaksatra]];
			if (disp.yoga)
				[xml appendFormat:@"<td>%@</td>\n", [self.gstr GetYogaName:pvd.astrodata.nYoga]];
			if (disp.fast) 
				[xml appendFormat:@"<td>%@</td>\n", ((pvd.nFastType!=FAST_NULL)?@"FAST":@"")];
			if (disp.rasi == 1) 
				[xml appendFormat:@"<td>%@</td>\n", [self.gstr GetSankrantiName:(GetRasi(pvd.astrodata.moon.longitude_deg, pvd.astrodata.msAyanamsa))]];
			else if (disp.rasi == 2) 
				[xml appendFormat:@"<td>%@</td>\n", [self.gstr GetSankrantiNameEn:(GetRasi(pvd.astrodata.moon.longitude_deg, pvd.astrodata.msAyanamsa))]];
			
			
			[xml appendFormat:@"</tr>\n\n<tr>\n<td></td><td></td><td colspan=4>"];
			if (pvd.isEkadasiParana)
			{
				if (pvd.hrEkadasiParanaEnd >= 0.0) {
					
					[xml appendFormat:@"Break fast %@ - %@ %@<br>\n"
						, [self.gstr hoursToString:pvd.hrEkadasiParanaStart]
						, [self.gstr hoursToString:pvd.hrEkadasiParanaEnd]
						, (pvd.nDST == 1 ? @"(DST applied)" : @"(Local Time)")];
				}
				else {
					[xml appendFormat:@"Break fast after %@<br>\n", [self.gstr hoursToString:pvd.hrEkadasiParanaStart] ];
				}
			}
			
			if ([pvd.festivals count] > 0)
			{
				for(GcDayFestival * pdf in pvd.festivals)
				{
					[xml appendFormat:@"%@<br>\n", pdf.name];
				}
			}
			
			if (pvd.sankranti_zodiac >= 0)
			{
				//double h1, m1, s1;
				//m1 = modf(pvd.sankranti_day.shour*24, &h1);
				//				s1 = modf(m1*60, &m1);
				[xml appendFormat:@"<span class=\'SankInfo\'>%@ Sankranti (<i>%d %@ %d  %@</i>)</span><br>\n"
				 , [self.gstr GetSankrantiName:pvd.sankranti_zodiac], pvd.sankranti_day.day
				 , [self.gstr GetMonthAbr:pvd.sankranti_day.month], pvd.sankranti_day.year
				 , [pvd.sankranti_day shortTimeString]];
			}
			
			if (disp.ksaya && pvd.was_ksaya)
			{
				double h1, m1, h2, m2;
				GCGregorianTime * ksayaDate;
				[xml appendFormat:@"Previous tithi is ksaya from "];
				m1 = modf(pvd.ksaya_time1*24, &h1);
				ksayaDate = pvd.date;
				if (pvd.ksaya_day1 < 0.0)
					ksayaDate = [ksayaDate previousDay];
				[xml appendFormat:@"%d %@, %02d:%02d", ksayaDate.day, [self.gstr GetMonthAbr:ksayaDate.month], (int)(h1), (int)(m1*60)];
				
				m2 = modf(pvd.ksaya_time2*24, &h2);
				[xml appendFormat:@"to %d %@, %02d:%02d<br>\n", ksayaDate.day, [self.gstr GetMonthAbr:ksayaDate.month], (int)(h2), abs((int)(m2*60))];
			}
			
			if (disp.vriddhi == 1 && pvd.is_vriddhi)
			{
				[xml appendFormat:@"Second day of vriddhi tithi<br>\n"];
			}
			
			if ((disp.caturmasya == 1) && (pvd.nCaturmasya & CMASYA_PRAT_MASK))
			{
				[xml appendFormat:@"%@", [self.gstr  string:(107 + ((pvd.nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8)
							+ ((pvd.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)) ]];
				[xml appendFormat:@" [PRATIPAT SYSTEM]<br>\n"];
				if ((pvd.nCaturmasya & CMASYA_PRAT_MASK_DAY) == 0x100)
				{
					[xml appendFormat:@"%@", [self.gstr string:(110 + ((pvd.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)) ]];
				}
			}
			
			if ((disp.caturmasya == 0) && (pvd.nCaturmasya & CMASYA_PURN_MASK))
			{
				[xml appendFormat:@"%@", [self.gstr string:(107 + (pvd.nCaturmasya & CMASYA_PURN_MASK_DAY)
							+ ((pvd.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)) ]];
				[xml appendFormat:@" [PURNIMA SYSTEM]<br>"];
				if ((pvd.nCaturmasya & CMASYA_PURN_MASK_DAY) == 0x1)
				{
					[xml appendFormat:@"%@", [self.gstr string:(110 + ((pvd.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)) ]];
				}
			}
			
			if ((disp.caturmasya == 2) && (pvd.nCaturmasya & CMASYA_EKAD_MASK))
			{
				[xml appendFormat:@"%@", [self.gstr string:(107 + ((pvd.nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16)
							+ ((pvd.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)) ]];
				[xml appendFormat:@" [EKADASI SYSTEM]<br>"];
				if ((pvd.nCaturmasya & CMASYA_EKAD_MASK_DAY) == 0x10000)
				{
					[xml appendFormat:@"%@", [self.gstr string:(110 + ((pvd.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)) ]];
				}
			}
			[xml appendFormat:@"\t</tr>\n\n"];
			
		}
	}
	[xml appendFormat:@"\t</table>\n\n"];
	[xml appendFormat:@"<hr align=center width=\"65%%\">\n"];
	[xml appendFormat:@"<p align=center>Generated by %@</p>\n", [self.gstr string:130]];
	[xml appendFormat:@"</body>\n</html>\n"];
	
	return xml;
}



/******************************************************************************************/
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/******************************************************************************************/
/*
-(NSString *)formatCalendarHtmlTable
{
	int g_firstday_in_week = disp.first_weekday;
	int k, y, lwd;
	NSMutableString * xml = [[[NSMutableString alloc] initWithCapacity:8000] autorelease];
	GcDay * pvd;
	int nPrevMasa = -1;
	//int nPrevMasa = -1;
	int prevMas = -1;
	
	// first = 1
	//int i_end[7] = {0, 6, 5, 4, 3, 2, 1}; //(6-(i-first))%7
	//int i_beg[7] = {6, 0, 1, 2, 3, 4, 5}; //(i-first)%7
	
	[xml appendFormat:@"<html>\n<head>\n<title>Calendar %@</title>\n", [gstr dateToString:self.m_vcStart]];
	[xml appendFormat:@"<style>\n<!--\np.MsoNormal, li.MsoNormal, div.MsoNormal\n	{mso-style-parent:\"\";"];
	[xml appendFormat:@"margin:0in;margin-bottom:.0001pt;mso-pagination:widow-orphan;font-size:12.0pt;font-family:\"Times New Roman\";"];
	[xml appendFormat:@"mso-fareast-font-family:\"Times New Roman\";}"];
	[xml appendFormat:@"p.month\n{mso-style-name:month;\nmso-margin-top-alt:auto;\nmargin-right:0in;\nmso-margin-bottom-alt:auto;\nmargin-left:0in;\nmso-pagination:widow-orphan;\nfont-size:24.0pt;font-family:Arial;mso-fareast-font-family:Arial;}\n"];
	[xml appendFormat:@"p.text, li.text, div.text\n{mso-style-name:text;\nmso-margin-top-alt:auto;\nmargin-right:0in;\nmso-margin-bottom-alt:auto;\nmargin-left:0in;\n	mso-pagination:widow-orphan;\nfont-size:10.0pt;\nmso-bidi-font-size:12.0pt;\nfont-family:Arial;	mso-fareast-font-family:\"Times New Roman\";mso-bidi-font-family:\"Times New Roman\";}\n"];
	[xml appendFormat:@"p.tnote\n{mso-style-name:text;\nmso-margin-top-alt:auto;\nmargin-right:0in;\nmso-margin-bottom-alt:auto;\nmargin-left:0in;\n	mso-pagination:widow-orphan;\nfont-size:8.0pt;\nmso-bidi-font-size:9.0pt;\nfont-family:Arial;	mso-fareast-font-family:Arial;mso-bidi-font-family:Arial;}\n"];
	[xml appendFormat:@"span.dayt\n	{mso-style-name:dayt;\nfont-size:14.0pt;\nmso-ansi-font-size:14.0pt;\nfont-family:Arial;\nmso-ascii-font-family:Arial;\nmso-hansi-font-family:Arial;\nfont-weight:bold;\nmso-bidi-font-weight:normal;}\n"];
	[xml appendFormat:@"span.SpellE\n{mso-style-name:\"\";\nmso-spl-e:yes;}\n"];
	[xml appendFormat:@"span.GramE\n{mso-style-name:\"\";\nmso-gram-e:yes;}\n"];
	[xml appendFormat:@"-->\n</style>\n"];
	
	[xml appendFormat:@"</head>\n\n<body>\n\n"];

	for (k = 0; k < self.m_vcCount; k++)
	{
		pvd = [self GetDay:k];
		if (pvd) {
			BOOL bSemicolon = false;
			BOOL bBr = false;
			lwd = pvd.date.dayOfWeek;
			if (nPrevMasa != pvd.date.month)
			{
				int y;
				if (nPrevMasa != -1)
				{
					for(y = 0; y < DAYS_TO_ENDWEEK(lwd); y++)
					{
						[xml appendFormat:@"<td style=\'border:solid windowtext 1.0pt;mso-border-alt:solid windowtext .5pt;padding:3.0pt 3.0pt 3.0pt 3.0pt\'>&nbsp;</td>"];
					}
					[xml appendFormat:@"</tr></table>\n"];
				}
				[xml appendFormat:@"\n<table width=\"100%\" border=0 frame=bottom cellspacing=0 cellpadding=0><tr><td width=\"60%\"><p class=month>"];
				[xml appendFormat:@"%@ %d", [gstr string:(pvd.date.month + 759)], pvd.date.year];
				[xml appendFormat:@"</p></td><td><p class=tnote align=right>"];
				[xml appendFormat:@"%@", m_Location.city];
				[xml appendFormat:@"<br>Timezone: "];
				[xml appendFormat:@"%@", m_Location.timezoneName];
				[xml appendFormat:@"</p>"];
				[xml appendFormat:@"</td></tr></table><hr>"];
				nPrevMasa = pvd.date.month;
				[xml appendFormat:@"\n<table bordercolor=black cellpadding=0 cellspacing=0>\n<tr>\n"];
				for(y = 0; y < 7; y++)
				{
					[xml appendFormat:@"<td width=\"14%\" align=center style=\'font-size:10.0pt;border:none\'>%@</td>\n", [gstr string:(DAY_INDEX(y))]];
				}
				[xml appendFormat:@"<tr>\n"];
				for(y=0; y < DAYS_FROM_BEGINWEEK(pvd.date.dayOfWeek); y++)
					[xml appendFormat:@"<td style=\'border:solid windowtext 1.0pt;mso-border-alt:solid windowtext .5pt;padding:3.0pt 3.0pt 3.0pt 3.0pt\'>&nbsp;</td>"];
			}
			else
			{
				if (pvd.date.dayOfWeek == g_firstday_in_week)
					[xml appendFormat:@"<tr>\n"];
			}
			
			// date data
			[xml appendFormat:@"\n<td valign=top style=\'border:solid windowtext 1.0pt;mso-border-alt:solid windowtext .5pt;padding:3.0pt 3.0pt 3.0pt 3.0pt\' bgcolor=\""];
			switch (pvd.nFastType)
			{
				case FAST_EKADASI:
					[xml appendFormat:@"#ffffbb"];
					break;
				case FAST_NOON:
				case FAST_SUNSET:
				case FAST_MOONRISE:
				case FAST_DUSK:
				case FAST_MIDNIGHT:
				case FAST_TODAY:
					[xml appendFormat:@"#bbffbb"];
					break;
				default:
					[xml appendFormat:@"white"];
					break;
			}
			[xml appendFormat:@"\"><p class=text><span class=dayt>%d</span><br>", pvd.date.day];
			
			[xml appendFormat:@"%@", [pvd getTithiNameComplete:gstr]];
			
			if (pvd.ekadasi_parana)
			{
				[xml appendFormat:@"%@<br>\n", [pvd GetTextEP:gstr]];
				bBr = YES;
				bSemicolon = YES;
			}
			
			if ([pvd.festivals count] > 0)
			{
				[xml appendFormat:@"<br>\n"];
				for(GcDayFestival * pdf in pvd.festivals)
				{
					if (bSemicolon)
						[xml appendFormat:@"; "];
					[xml appendFormat:@"%@", pdf.name];
					bSemicolon=YES;
					bBr=NO;
				}
			}
			
			if (pvd.sankranti_zodiac >= 0)
			{
				[xml appendFormat:@"<i>%@ Sankranti</i>\n", [gstr GetSankrantiName:pvd.sankranti_zodiac]];
				[xml appendFormat:@"<br>\n"];
				bBr = YES;
			}
			
			if (prevMas != pvd.astrodata.nMasa)
			{
				if (bBr==false)
					[xml appendFormat:@"<br>\n"];
				[xml appendFormat:@"<b>[%@ Masa]</b>", [gstr GetMasaName:pvd.astrodata.nMasa]];
				prevMas = pvd.astrodata.nMasa;
			}
			[xml appendFormat:@"</td>\n\n"];
			
		}
	}

	for(y = 1; y < DAYS_TO_ENDWEEK(lwd); y++)
	{
		[xml appendFormat:@"<td style=\'border:solid windowtext 1.0pt;mso-border-alt:solid windowtext .5pt;padding:3.0pt 3.0pt 3.0pt 3.0pt\'>&nbsp;</td>"];
	}
	[xml appendFormat:@"</tr>\n</table>\n"];
	[xml appendFormat:@"</body>\n</html>\n"];
	
	return xml;
}
*/

-(NSString *)formatCalendarPlainText
{
	int k;
	NSString *str;
	
	NSMutableString *dayText = [[NSMutableString alloc] initWithCapacity:8000];
	NSMutableString * m_text = [[NSMutableString alloc] initWithCapacity:8000];	

	NSString * spaces = @"                                                                                ";
	GCCalendarDay * pvd, * prevd, *nextd;
	int lastmasa = -1;
	int lastmonth = -1;
	int tp1;
	//	double rate;
	//	DlgCalcProgress dcp;
	//	bool bCalcMoon = (GetShowSetVal(4) > 0 || GetShowSetVal(5) > 0);
	
	for (k = 0; k < self.m_vcCount; k++)
	{
		
		prevd = [m_pData objectAtIndex:(BEFORE_DAYS + k - 1)];
		pvd   = [m_pData objectAtIndex:(BEFORE_DAYS + k)];
		nextd = [m_pData objectAtIndex:(BEFORE_DAYS + k + 1)];
		
		if (pvd) {
			if (disp.hdr_masa && (pvd.astrodata.nMasa != lastmasa))
			{
				[m_text appendFormat:@"\n"];
				[dayText setString:[NSString stringWithFormat:@"%@ %@, Gaurabda %d", [self.gstr GetMasaName:pvd.astrodata.nMasa]
						, [self.gstr string:22], pvd.astrodata.nGaurabdaYear]];
				tp1 = (80 - [dayText length])/2;
				[dayText insertString:[spaces substringToIndex:tp1] atIndex:0];
				[dayText appendFormat:@"%@", spaces];
				[dayText insertString:[self.gstr GetVersionText] atIndex:(80 - [[self.gstr GetVersionText] length] )];
				[m_text appendFormat:@"%@", [dayText substringToIndex:80]];
				[dayText setString:@""];
				[m_text appendFormat:@"\n"];
				if ((pvd.astrodata.nMasa == ADHIKA_MASA) && ((lastmasa >= SRIDHARA_MASA) && (lastmasa <= DAMODARA_MASA)))
				{
					[pvd AddListText:[self.gstr string:128] toString:m_text format:0];
				}
				str = [self.m_Location fullName];
				[m_text appendFormat:@"%@%@\n\n", [spaces substringToIndex:(80 - [str length])/2], str ];
				[self appendCalendarColumnsHeader:m_text format:0];
				lastmasa = pvd.astrodata.nMasa;
			}
			
			if (disp.hdr_month && (pvd.date.month != lastmonth))
			{
				[m_text appendFormat:@"\n"];
				[dayText setString:[NSString stringWithFormat:@"%@ %d", [self.gstr string:(759 + pvd.date.month)], pvd.date.year]];
				tp1 = (80 - [dayText length])/2;
				[dayText insertString:[spaces substringToIndex:tp1] atIndex:0];
				[dayText appendFormat:@"%@", spaces];
				[dayText insertString:[self.gstr GetVersionText] atIndex:(80 - [[self.gstr GetVersionText] length] )];
				[m_text appendFormat:@"%@", [dayText substringToIndex:80]];
				[dayText setString:@""];
				[m_text appendFormat:@"\n"];

				str = [self.m_Location fullName];
				[m_text appendFormat:@"%@%@\n\n", [spaces substringToIndex:(80 - [str length])/2], str ];
				[self appendCalendarColumnsHeader:m_text format:0];
				lastmonth = pvd.date.month;
			}
			
			[dayText setString:@""];
			
			if (disp.change_masa)
			{
				if (prevd)
				{
					if (prevd.astrodata.nMasa != pvd.astrodata.nMasa)
					{
						str = [NSString stringWithFormat:@"%@ %@ %@", [self.gstr string:780]
							, [self.gstr GetMasaName:pvd.astrodata.nMasa], [self.gstr string:22]];
						[pvd AddListText:str toString:dayText format:0];
					}
				}
				if (nextd)
				{
					if (nextd.astrodata.nMasa != pvd.astrodata.nMasa)
					{
						str = [NSString stringWithFormat:@"%@ %@ %@", [self.gstr string:781]
							, [self.gstr GetMasaName:pvd.astrodata.nMasa], [self.gstr string:22]];
						[pvd AddListText:str toString:dayText format:0];
					}
				}
			}
			
			if (disp.hide_empty == NO || [dayText length] > 90)
				[m_text appendFormat:@"%@", dayText];
			
			
		}
	}
	
	return m_text;
}

-(NSString *)formatCalendarRtf
{
	int k;
	int bShowColumnHeaders = 0;
	//NSString * str, * str2, * str3;
	NSMutableString * dayText = [[NSMutableString alloc] init];
	NSMutableString * m_text = [[NSMutableString alloc] init];

	//NSString * spaces = @"                                                                                ";
	GCCalendarDay * pvd, * prevd, *nextd;
	int lastmasa = -1;
	int lastmonth = -1;
	//BOOL bCalcMoon = (disp.moonset || disp.moonrise);

	[self.gstr appendRtfHeader:m_text];

	for (k = 0; k < self.m_vcCount; k++)
	{

		prevd = [m_pData objectAtIndex:(BEFORE_DAYS + k - 1)];
		pvd   = [m_pData objectAtIndex:(BEFORE_DAYS + k)];
		nextd = [m_pData objectAtIndex:(BEFORE_DAYS + k + 1)];

		if (pvd)
		{
			[dayText setString:@""];
			bShowColumnHeaders = 0;
			if (disp.hdr_masa && (pvd.astrodata.nMasa != lastmasa))
			{
				if (bShowColumnHeaders == 0)
					[m_text appendFormat:@"\\par "];
				bShowColumnHeaders = 1;
//				m_text += "\\par\r\n";
				[dayText setString:@""];
				[dayText appendFormat:@"\\par \\pard\\f2\\fs%d\\qc %@ %@, Gaurabda %d", disp.textHeader2Size
					, [self.gstr GetMasaName:pvd.astrodata.nMasa], [self.gstr string:22]
					, pvd.astrodata.nGaurabdaYear];
				if ((pvd.astrodata.nMasa == ADHIKA_MASA) && ((lastmasa >= SRIDHARA_MASA) && (lastmasa <= DAMODARA_MASA)))
				{
					[dayText appendFormat:@"\\line %@", [self.gstr string:128]];
				}
				[m_text appendFormat:@"%@", dayText];

				lastmasa = pvd.astrodata.nMasa;
			}

			if (disp.hdr_month && (pvd.date.month != lastmonth))
			{
				if (bShowColumnHeaders == 0)
					[m_text appendFormat:@"\\par "];
				bShowColumnHeaders = 1;
				[m_text appendFormat:@"\\par\\pard\\f2\\qc\\fs%d\r\n", disp.textHeader2Size];
				[m_text appendFormat:@"%@ %d", [self.gstr string:(759 + pvd.date.month)], pvd.date.year];
				lastmonth = pvd.date.month;
			}

			// print location text
			if (bShowColumnHeaders)
			{
				[m_text appendFormat:@"\\par\\pard\\qc\\cf2\\fs22 %@", [self.m_Location fullName]];
				[m_text appendFormat:@"\\par\\pard\\fs%d\\qc %@\\par\\par\n", disp.textNoteSize, [self.gstr GetVersionText]];

				int tabStop = 5760*disp.textSize/24;
				[m_text appendFormat:@"\\pard\\tx%d\\tx%d ",2000*disp.textSize/24, tabStop];
				if (disp.paksa)
				{
					tabStop += 990*disp.textSize/24;
					[m_text appendFormat:@"\\tx%d", tabStop];
				}
				if (disp.yoga)
				{
					tabStop += 1720*disp.textSize/24;
					[m_text appendFormat:@"\\tx%d", tabStop];
				}
				if (disp.naksatra)
				{
					tabStop += 1800*disp.textSize/24;
					[m_text appendFormat:@"\\tx%d", tabStop];
				}
				if (disp.fast)
				{
					tabStop += 750*disp.textSize/24;
					[m_text appendFormat:@"\\tx%d", tabStop];
				}
				if (disp.rasi)
				{
					tabStop += 1850*disp.textSize/24;
					[m_text appendFormat:@"\\tx%d", tabStop];
				}
				// paksa width 990
				// yoga width 1720
				// naks width 1800
				// fast width 990
				// rasi width 1850
				[self appendCalendarColumnsHeader:m_text format:1];
			}
			[m_text appendFormat:@"\\fs%d ", disp.textSize];

			// add text od days events
			[dayText setString:[pvd stringWithFormat:1 display:disp source:self.gstr]];

			if (disp.change_masa)
			{
				if (prevd && prevd.astrodata.nMasa != pvd.astrodata.nMasa)
				{
					[pvd AddListText:[NSString stringWithFormat:@"%@ %@ %@", [self.gstr string:780],
							[self.gstr GetMasaName:pvd.astrodata.nMasa], [self.gstr string:22]]
						toString:dayText
						format:1];
				}
				if (nextd && nextd.astrodata.nMasa != pvd.astrodata.nMasa)
				{
					[pvd AddListText:[NSString stringWithFormat:@"%@ %@ %@", [self.gstr string:781],
							[self.gstr GetMasaName:pvd.astrodata.nMasa], [self.gstr string:22]]
						toString:dayText
						format:1];
				}
			}
			/* BEGIN GCAL 1.4.3 */
			if (disp.change_dst)
			{
				if (prevd && prevd.nDST == 0 && pvd.nDST==1)
				{
					[pvd AddListText:[self.gstr string:855] toString:dayText format:1];
				}
				else if (nextd && pvd.nDST==1 && nextd.nDST==0)
				{
					[pvd AddListText:[self.gstr string:856] toString:dayText format:1];
				}
			}

			/* END GCAL 1.4.3 */

			if (disp.hide_empty == NO || [dayText length] > 90)
				[m_text appendFormat:@"%@", dayText];
			
			[dayText setString:@""];
		}
	}

				 [self.gstr addNoteRtf:m_text display:disp];
	[m_text appendFormat:@"\n}\n"];

	return m_text;
}


@end
