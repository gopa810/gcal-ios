#import "gc_dtypes.h"
#import "gc_const.h"
#import "gc_func.h"

extern unsigned int gGaurBeg[];

// PORTABLE 

/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

double GetPrevConjunction(gc_time test_date, gc_time * found, BOOL this_conj, gc_earth earth)
{
	double phi = 12.0;
	double l1, l2, sunl;
	
	if (this_conj)
	{
		test_date.shour -= 0.2;
		gc_time_NormalizeValues(&test_date);
	}
	
	
	JULIANDATE jday = gc_time_GetJulianComplete(&test_date);
	JULIANDATE xj;
	gc_moon moon;
	gc_time d = test_date;
	gc_time xd;
	double scan_step = 1.0;
	int prev_tit = 0;
	int new_tit = -1;
	
	MoonCalc(jday, &moon, earth);
	sunl = GetSunLongitude(d);
	l1 = put_in_180(moon.longitude_deg - sunl);
	prev_tit = (int)(floor(l1/phi));
	
	int counter = 0;
	while(counter < 20)
	{
		xj = jday;
		xd = d;
		
		jday -= scan_step;
		d.shour -= scan_step;
		if (d.shour < 0.0)
		{
			d.shour += 1.0;
			GetPrevDay(&d);
		}
		
		MoonCalc(jday, &moon, earth);
		sunl = GetSunLongitude(d);
		l2 = put_in_180(moon.longitude_deg - sunl);
		new_tit = (int)(floor(l2/phi));
		
		if (prev_tit >= 0 && new_tit < 0)
		{
			jday = xj;
			d = xd;
			scan_step *= 0.5;
			counter++;
			continue;
		}
		else
		{
			prev_tit = new_tit;
		}
		
	}
	*found = d;
	return sunl;
}

/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

double GetNextConjunction(gc_time test_date, gc_time * found, BOOL this_conj, gc_earth earth)
{
	double phi = 12.0;
	double l1, l2, sunl;
	
	if (this_conj)
	{
		test_date.shour += 0.2;
		gc_time_NormalizeValues(&test_date);
	}
	
	
	JULIANDATE jday = gc_time_GetJulianComplete(&test_date);
	JULIANDATE xj;
	gc_moon moon;
	gc_time d = test_date;
	gc_time xd;
	double scan_step = 1.0;
	int prev_tit = 0;
	int new_tit = -1;
	
	MoonCalc(jday, &moon, earth);
	sunl = GetSunLongitude(d);
	l1 = put_in_180(moon.longitude_deg - sunl);
	prev_tit = (int)(floor(l1/phi));
	
	int counter = 0;
	while(counter < 20)
	{
		xj = jday;
		xd = d;
		
		jday += scan_step;
		d.shour += scan_step;
		if (d.shour > 1.0)
		{
			d.shour -= 1.0;
			GetNextDay(&d);
		}
		
		MoonCalc(jday, &moon, earth);
		sunl = GetSunLongitude(d);
		l2 = put_in_180(moon.longitude_deg - sunl);
		new_tit = (int)(floor(l2/phi));
		
		if (prev_tit < 0 && new_tit >= 0)
		{
			jday = xj;
			d = xd;
			scan_step *= 0.5;
			counter++;
			continue;
		}
		else 
		{
			prev_tit = new_tit;			
		}

	}
	*found = d;
	return sunl;
	
}

void correct_parallax(gc_moon * , JULIANDATE, double, double);


double DayCalcEx(gc_time date, gc_earth earth, int nType)
{
	double d;
	JULIANDATE jdate;
	gc_moon moon;
	gc_sun sun;
	
	if (nType == DCEX_NAKSATRA_MIDNIGHT)
	{
		date.shour = 1.0;
		jdate = gc_time_GetJulianDetailed(&date);
		MoonCalc(jdate, &moon, earth);
		d = put_in_360( moon.longitude_deg - GetAyanamsa(jdate));
		return floor(( d * 3.0) / 40.0 );
	}
	else if (nType == DCEX_MOONRISE)
	{
		return 0.3;
	}
	else if (nType == DCEX_SUNRISE)
	{
		// calculation TITHI at sunset
		SunCalc( date, earth, &sun);
		return (sun.sunrise_deg / 360.0) + (date.tzone/24.0);
	}
	
	return 0;
}

/*********************************************************************/
/*                                                                   */
/* Calculation of tithi, paksa, naksatra, yoga for given             */
/*    Gregorian date                                                 */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

gc_astro DayCalc(gc_time date, gc_earth earth)
{
	gc_astro day;
	double d;
	JULIANDATE jdate;
	//	SUNDATA sun;
	
	// sun position on sunrise on that day
	SunCalc( date, earth, &(day.sun));
	date.shour = day.sun.sunrise_deg/360.0;
	
	// date.shour is [0..1] time of sunrise in local timezone time
	day.jdate = jdate = gc_time_GetJulianDetailed(&date);
	
	// moon position at sunrise on that day
	MoonCalc(gc_time_GetJulianDetailed(&date), &(day.moon), earth);
	
	// correct_parallax(day.moon, jdate, earth.latitude_deg, earth.longitude_deg);
	
	day.msDistance = put_in_360( day.moon.longitude_deg - day.sun.longitude_deg - 180.0);
	day.msAyanamsa = GetAyanamsa( jdate );
	
	// tithi
	d = day.msDistance / 12.0;
	day.nTithi = (int)(floor(d));
	day.nTithiElapse = (d - floor(d)) * 100.0;
	day.nPaksa = (day.nTithi >= 15) ? 1 : 0;
	
	
	// naksatra
	d = put_in_360( day.moon.longitude_deg - day.msAyanamsa );
	d = ( d * 3.0) / 40.0;
	day.nNaksatra = (int)(floor(d));
	day.nNaksatraElapse = (d - floor(d)) * 100.0;
	
	// yoga
	d = put_in_360( day.moon.longitude_deg + day.sun.longitude_deg - 2*day.msAyanamsa);
	d = (d * 3.0) / 40.0;
	day.nYoga = (int)(floor(d));
	day.nYogaElapse = (d - floor(d)) * 100.0;
	
	// masa
	day.nMasa = -1;
	
	// rasi
	day.nRasi = GetRasi(day.sun.longitude_deg, day.msAyanamsa);
	
	gc_moon moon;
	date.shour = day.sun.sunset_deg/360.0;
	MoonCalc(gc_time_GetJulianDetailed(&date), &moon, earth);
	d = put_in_360(moon.longitude_deg - day.sun.longitude_set_deg - 180) / 12.0;
	day.nTithiSunset = (int)floor(d);
	
	date.shour = day.sun.arunodaya_deg/360.0;
	MoonCalc(gc_time_GetJulianDetailed(&date), &moon, earth);
	d = put_in_360(moon.longitude_deg - day.sun.longitude_arun_deg - 180) / 12.0;
	day.nTithiArunodaya = (int)floor(d);
	
	return day;
}

/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

gc_astro MasaCalc(gc_time date, gc_astro day, gc_earth earth)
{
	//	SUNDATA sun;
	//	gc_moon moon;
	//	gc_time Conj[6], ConjA;
	//	double Long[6], LongA;
	//	int Sank[6], SankA;
	
	const int PREV_MONTHS = 6;
	
	double L[8];
	gc_time C[8];
	int    R[8];
	int    n, rasi, masa;
	int    ksaya_from = -1;
	int    ksaya_to = -1;
	
	date.shour = day.sun.sunrise_deg / 360.0 + earth.tzone / 24.0;
	
	// STEP 1: calculate position of the sun and moon
	// it is done by previous call of DayCalc
	// and results are in argument gc_astro day
	// *DayCalc(date, earth, day, moon, sun);*
	
	L[1] = /*Long[0] =*/ GetNextConjunction(date, &(C[1]), false, earth);
	L[0] = /*LongA   =*/ GetNextConjunction(C[1], &(C[0]), true, earth);
	
	// on Pratipat (nTithi == 15) we need to look for previous conjunction
	// but this conjunction can occur on this date before sunrise
	// so we need to include this very date into looking for conjunction
	// on other days we cannot include it
	// and exclude it from looking for next because otherwise that will cause
	// incorrect detection of Purusottama adhika masa
	L[2] = GetPrevConjunction(date, &C[2], false, earth);
	
	for(n = 3; n < PREV_MONTHS; n++)
		L[n] = GetPrevConjunction(C[n-1], &C[n], true, earth);
	
	for(n = 0; n < PREV_MONTHS; n++)
		R[n] = GetRasi(L[n], GetAyanamsa(gc_time_GetJulian(&C[n])));
	
	/*	TRACE("TEST Date: %d %d %d\n", date.day, date.month, date.year);
	 TRACE("FOUND CONJ Date: %d %d %d rasi: %d\n", C[1].day, C[1].month, C[1].year, R[1]);
	 TRACE("FOUND CONJ Date: %d %d %d rasi: %d\n", C[2].day, C[2].month, C[2].year, R[2]);
	 TRACE("FOUND CONJ Date: %d %d %d rasi: %d\n", C[3].day, C[3].month, C[3].year, R[3]);
	 TRACE("FOUND CONJ Date: %d %d %d rasi: %d\n", C[4].day, C[4].month, C[4].year, R[4]);
	 TRACE("---\n");
	 */
	// test for Adhika-Ksaya sequence
	// this is like 1-2-2-4-5...
	// second (2) is replaced by rasi(3)
	/*	if ( ((Sank[1] + 2) % 12 == SankA) && ((Sank[1] == Sank[0]) || (Sank[0] == SankA)))
	 {
	 Sank[0] = (Sank[1] + 1) % 12;
	 }
	 
	 if ( ((Sank[2] + 2) % 12 == Sank[0]) && ((Sank[2] == Sank[1]) || (Sank[1] == Sank[0])))
	 {
	 Sank[1] = (Sank[2] + 1) % 12;
	 }*/
	
	// look for ksaya month
	ksaya_from = -1;
	for(n = PREV_MONTHS - 2; n >= 0; n--)
	{
		if ((R[n+1] + 2) % 12 == R[n])
		{
			ksaya_from = n;
			break;
		}
	}
	
	if (ksaya_from >= 0)
	{
		for(n = ksaya_from; n > 0; n--)
		{
			if (R[n] == R[n-1])
			{
				ksaya_to = n;
				break;
			}
		}
		
		if (ksaya_to >= 0)
		{
			// adhika masa found
			// now correct succession of rasis
		}
		else
		{
			// adhika masa not found
			// there will be some break in masa queue
			ksaya_to = 0;
		}
		
		int current_rasi = R[ksaya_from + 1] + 1;
		for(n = ksaya_from; n >= ksaya_to; n--)
		{
			R[n] = current_rasi;
			current_rasi = (current_rasi + 1) % 12;
		}
	}
	
	// STEP 3: test for adhika masa
	// test for adhika masa
	if (R[1] == R[2])
	{
		// it is adhika masa
		masa = 12;
		rasi = R[1];
	}
	else
	{
		// STEP 2. select nearest Conjunction
		if (day.nPaksa == 0)
		{
			masa = R[1];
		}
		else if (day.nPaksa == 1)
		{
			masa = R[2];
		}
		rasi = masa;
	}
	
	// calculation of Gaurabda year
	day.nGaurabdaYear = date.year - 1486;
	
	if ((rasi > 7) && (rasi < 11)) // Visnu
	{
		if (date.month < 6)
			day.nGaurabdaYear--;
	}
	
	
	day.nMasa = masa;
	
	return day;
}

/*
 
 Routines for supporting calculation of Vaisnava Calendar
 
 */


int AvcComboMasaToMasa(int);

// for VCIN
// that means, for Vaisnava Calendar data INput
// parameters for these functions are Vaisnava calendar data like masa, paksa, tithi etc.

/*********************************************************************/
/* Finds starting and ending time for given tithi                    */
/*                                                                   */
/* tithi is specified by Gaurabda year, masa, paksa and tithi number */
/*      nGYear - 0..9999                                             */
/*       nMasa - 0..12, 0-Madhusudana, 1-Trivikrama, 2-Vamana        */
/*                      3-Sridhara, 4-Hrsikesa, 5-Padmanabha         */
/*                      6-Damodara, 7-Kesava, 8-narayana, 9-Madhava  */
/*                      10-Govinda, 11-Visnu, 12-PurusottamaAdhika   */
/*       nPaksa -       0-Krsna, 1-Gaura                             */
/*       nTithi - 0..14                                              */
/*       earth  - used timezone                                      */
/*                                                                   */
/*********************************************************************/

gc_time CalcTithiEnd(int nGYear, int nMasa, int nPaksa, int nTithi, gc_earth earth, gc_time *  endTithi)
{
	gc_time d;
	
	d = GetFirstDayOfYear(earth, nGYear + 1486);
	d.shour = 0.5;
	d.tzone = earth.tzone;
	
	return CalcTithiEndEx(d, nGYear, nMasa, nPaksa, nTithi, earth, endTithi);
}

gc_time CalcTithiEndEx(gc_time vcStart, int GYear, int nMasa, int nPaksa, int nTithi, gc_earth earth, gc_time *  endTithi)
{
	int i, gy, nType;
	gc_time d;
	gc_astro day;
	int tithi;
	int counter;
	gc_time start, end;
	//	SUNDATA sun;
	//	gc_moon moon;
	double sunrise;
	start.shour = -1.0;
	end.shour = -1.0;
	start.day = start.month = start.year = -1;
	end.day = end.month = end.year = -1;
	
	/*	d = GetFirstDayOfYear(earth, nGYear + 1486);
	 d.shour = 0.5;
	 d.TimeZone = earth.tzone;
	 */
	d = vcStart;
	
	i = 0;
	do
	{
		gc_time_add_days(&d, 13);
		day = DayCalc(d, earth);
		day = MasaCalc(d, day, earth);
		gy = day.nGaurabdaYear;
		i++;
	}
	while(((day.nPaksa != nPaksa) || (day.nMasa != nMasa)) && (i <= 30));
	
	if (i >= 30)
	{
		d.year = d.month = d.day = -1;
		return d;
	}
	
	// we found masa and paksa
	// now we have to find tithi
	tithi = nTithi + nPaksa*15;
	
	if (day.nTithi == tithi)
	{
		// loc1
		// find tithi juncts in this day and according to that times,
		// look in previous or next day for end and start of this tithi
		nType = 1;
	}
	else
	{
		if (day.nTithi < tithi)
		{
			// do increment of date until nTithi == tithi
			//   but if nTithi > tithi
			//       then do decrement of date
			counter = 0;
			while(counter < 30)
			{
				GetNextDay(&d);
				day = DayCalc(d, earth);
				if (day.nTithi == tithi)
					goto cont_2;
				if ((day.nTithi < tithi ) && (day.nPaksa != nPaksa))
				{
					GetPrevDay(&d);
					goto cont_2;
				}
				if (day.nTithi > tithi)
				{
					GetPrevDay(&d);
					goto cont_2;
				}
				counter++;
			}
			// somewhere is error
			d.year = d.month = d.day = 0;
			nType = 0;
		}
		else
		{
			// do decrement of date until nTithi <= tithi
			counter = 0;
			while(counter < 30)
			{
				GetPrevDay(&d);
				day = DayCalc(d, earth);
				if (day.nTithi == tithi)
					goto cont_2;
				if ((day.nTithi > tithi ) && (day.nPaksa != nPaksa))
				{
					goto cont_2;
				}
				if (day.nTithi < tithi)
				{
					goto cont_2;
				}
				counter++;
			}
			// somewhere is error
			d.year = d.month = d.day = 0;
			nType = 0;
			
		}
	cont_2:
		if (day.nTithi == tithi)
		{
			// do the same as in loc1
			nType = 1;
		}
		else 
		{
			// nTithi != tithi and nTithi < tithi
			// but on next day is nTithi > tithi
			// that means we will find start and the end of tithi
			// in this very day or on next day before sunrise
			nType = 2;
		}
		
	}
	
	// now we know the type of day-accurancy
	// nType = 0 means, that we dont found a day
	// nType = 1 means, we find day, when tithi was present at sunrise
	// nType = 2 means, we found day, when tithi started after sunrise
	//                  but ended before next sunrise
	//
	sunrise = day.sun.sunrise_deg / 360 + earth.tzone/24;
	
	if (nType == 1)
	{
		gc_time d1, d2;
		d.shour = sunrise;
		GetPrevTithiStart(earth, d, &d1);
		//d = d1;
		//d.shour += 0.02;
		GetNextTithiStart(earth, d, &d2);
		
		*endTithi = d2;
		return d1;
	}
	else if (nType == 2)
	{
		gc_time d1, d2;
		d.shour = sunrise;
		GetNextTithiStart(earth, d, &d1);
		d = d1;
		d.shour += 0.1;
		gc_time_NormalizeValues(&d);
		GetNextTithiStart(earth, d, &d2);
		
		*endTithi = d2;
		return d1;
	}
	
	// if nType == 0, then this algoritmus has some failure
	if (nType == 0)
	{
		d.year = 0;
		d.month = 0;
		d.day = 0;
		d.shour = 0.0;
		*endTithi = d;
	}
	else
	{
		d = start;
		*endTithi = end;
	}
	
	return d;
}


/*********************************************************************/
/*  Calculates Date of given Tithi                                   */
/*********************************************************************/

gc_time CalcTithiDate(int nGYear, int nMasa, int nPaksa, int nTithi, gc_earth earth)
{
	int i = 0;
	gc_time d;
	gc_astro day;
	int tithi = 0;
	int counter = 0;
	unsigned int tmp = 0;
	
	if (nGYear >= 464 && nGYear < 572)
	{
		tmp = gGaurBeg[(nGYear-464)*26 + nMasa*2 + nPaksa];
		d.month = (tmp & 0x3e0) >> 5;
		d.day   = (tmp & 0x1f);
		d.year  = (tmp & 0xfffc00) >> 10;
		d.shour = 0.5;
		d.tzone = earth.tzone;
		GetNextDay(&d);
		
		day = DayCalc(d, earth);
		day = MasaCalc(d, day, earth);
	}
	else
	{
		//d = GetFirstDayOfYear(earth, nGYear + 1486);
		d.day = 15;
		d.month = 2 + nMasa;
		d.year = nGYear + 1486;
		if (d.month > 12)
		{
			d.month -= 12;
			d.year++;
		}
		d.shour = 0.5;
		d.tzone = earth.tzone;
		
		i = 0;
		do
		{
			gc_time_add_days(&d, 13);
			day = DayCalc(d, earth);
			day = MasaCalc(d, day, earth);
			i++;
		}
		while(((day.nPaksa != nPaksa) || (day.nMasa != nMasa)) && (i <= 30));
	}
	
	if (i >= 30)
	{
		d.year = d.month = d.day = -1;
		return d;
	}
	
	// we found masa and paksa
	// now we have to find tithi
	tithi = nTithi + nPaksa*15;
	
	if (day.nTithi == tithi)
	{
		// loc1
		// find tithi juncts in this day and according to that times,
		// look in previous or next day for end and start of this tithi
		return d;
	}
	
	if (day.nTithi < tithi)
	{
		// do increment of date until nTithi == tithi
		//   but if nTithi > tithi
		//       then do decrement of date
		counter = 0;
		while(counter < 16)
		{
			GetNextDay(&d);
			day = DayCalc(d, earth);
			if (day.nTithi == tithi)
				return d;
			if ((day.nTithi < tithi ) && (day.nPaksa != nPaksa))
				return d;
			if (day.nTithi > tithi)
				return d;
			counter++;
		}
		// somewhere is error
		d.year = d.month = d.day = 0;
		return d;
	}
	else
	{
		// do decrement of date until nTithi <= tithi
		counter = 0;
		while(counter < 16)
		{
			GetPrevDay(&d);
			day = DayCalc(d, earth);
			if (day.nTithi == tithi)
				return d;
			if ((day.nTithi > tithi ) && (day.nPaksa != nPaksa))
			{
				GetNextDay(&d);
				return d;
			}
			if (day.nTithi < tithi)
			{
				GetNextDay(&d);
				return d;
			}
			counter++;
		}
		// somewhere is error
		d.year = d.month = d.day = 0;
		return d;
	}
	
	// now we know the type of day-accurancy
	// nType = 0 means, that we dont found a day
	// nType = 1 means, we find day, when tithi was present at sunrise
	// nType = 2 means, we found day, when tithi started after sunrise
	//                  but ended before next sunrise
	//
	
	return d;
}

int	GetGaurabdaYear(gc_time vc, gc_earth earth)
{
	gc_astro day;
	
	day = DayCalc(vc, earth);
	day = MasaCalc(vc, day, earth);
	
	return day.nGaurabdaYear;
}


/*********************************************************************/
/*  Finds date of Pratipat, Krsna Paksa, Visnu Masa                  */
/*                                                                   */
/*  gc_earth earth - location                                       */
/*  int nYear       - Gregorian year                                 */
/*                                                                   */
/*********************************************************************/

gc_time GetFirstDayOfYear(gc_earth earth, int nYear)
{
	
	int a[] = {2, 15, 3, 1, 3, 15, 4, 1, 4, 15};
	gc_time d;
	gc_astro day;
	int j;
	int step;
	unsigned int tmp;
	
	if (nYear >= 1950 && nYear < 2058)
	{
		tmp = gGaurBeg[(nYear - 1950)*26 + 22];
		d.month = (tmp & 0x3e0) >> 5;
		d.day   = (tmp & 0x1f);
		d.year  = nYear;
		d.tzone = earth.tzone;
		d.shour = 0.5;
		GetNextDay(&d);
		a[0] = d.month;
		a[1] = d.day;
	}
	
	for(int i = 0; i < 10; i+=2)
	{
		d.year = nYear;
		d.month = a[i];
		d.day = a[i+1];
		d.shour = 0.0;
		d.dayOfWeek = 0;
		d.tzone = earth.tzone;
		
		day = DayCalc(d, earth);
		day = MasaCalc(d, day, earth);
		
		if (day.nMasa == 11) // visnu masa
		{
			do
			{
				// shifts date
				step = day.nTithi / 2;
				step = (step > 0) ? step : 1;
				for(j = step; j > 0; j--)
				{
					GetPrevDay(&d);
				}
				// try new time
				day = DayCalc(d, earth);
			}
			while(day.nTithi < 28);
			GetNextDay(&d);
			d.tzone = earth.tzone;
			d.shour = day.sun.sunrise_deg / 360.0;
			return d;
		}
	}
	
	d.year = -1;
	d.month = -1;
	d.day = -1;
	d.tzone = earth.tzone;
	d.shour = day.sun.sunrise_deg / 360.0;
	
	return d;
	
}


/*********************************************************************/
/*   Finds first day of given masa and gaurabda year                 */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

gc_time GetFirstDayOfMasa(gc_earth earth, int GYear, int nMasa)
{
	return CalcTithiDate(GYear, nMasa, 0, 0, earth);
}

/*********************************************************************/
/*                                                                   */
/*   finds next time when starts next naksatra                       */
/*                                                                   */
/*   timezone is not changed                                         */
/*                                                                   */
/*   return value: index of naksatra 0..26                           */
/*                 or -1 if failed                                   */
/*********************************************************************/

int GetNextNaksatra(gc_earth ed, gc_time startDate, gc_time * nextDate)
{
	double phi = 40.0/3.0;
	double l1, l2;
	JULIANDATE jday = gc_time_GetJulianComplete(&startDate);
	gc_moon moon;
	gc_time d = startDate;
	double ayanamsa = GetAyanamsa(jday);
	double scan_step = 0.5;
	int prev_naks = 0;
	int new_naks = -1;
	
	JULIANDATE xj;
	gc_time xd;
	
	MoonCalc(jday, &moon, ed);
	l1 = put_in_360(moon.longitude_deg - ayanamsa);
	prev_naks = (int)(floor(l1 / phi));
	
	int counter = 0;
	while(counter < 20)
	{
		xj = jday;
		xd = d;
		
		jday += scan_step;
		d.shour += scan_step;
		if (d.shour > 1.0)
		{
			d.shour -= 1.0;
			GetNextDay(&d);
		}
		
		MoonCalc(jday, &moon, ed);
		l2 = put_in_360(moon.longitude_deg - ayanamsa);
		new_naks = (int)(floor(l2/phi));
		if (prev_naks != new_naks)
		{
			jday = xj;
			d = xd;
			scan_step *= 0.5;
			counter++;
			continue;
		}
	}
	*nextDate = d;
	return new_naks;
}

/*********************************************************************/
/*                                                                   */
/*   finds previous time when starts next naksatra                   */
/*                                                                   */
/*   timezone is not changed                                         */
/*                                                                   */
/*   return value: index of naksatra 0..26                           */
/*                 or -1 if failed                                   */
/*********************************************************************/

int GetPrevNaksatra(gc_earth ed, gc_time startDate, gc_time * nextDate)
{
	double phi = 40.0/3.0;
	double l1, l2;
	JULIANDATE jday = gc_time_GetJulianComplete(&startDate);
	gc_moon moon;
	gc_time d = startDate;
	double ayanamsa = GetAyanamsa(jday);
	double scan_step = 0.5;
	int prev_naks = 0;
	int new_naks = -1;
	
	JULIANDATE xj;
	gc_time xd;
	
	MoonCalc(jday, &moon, ed);
	l1 = put_in_360(moon.longitude_deg - ayanamsa);
	prev_naks = (int)(floor(l1/phi));
	
	int counter = 0;
	while(counter < 20)
	{
		xj = jday;
		xd = d;
		
		jday -= scan_step;
		d.shour -= scan_step;
		if (d.shour < 0.0)
		{
			d.shour += 1.0;
			GetPrevDay(&d);
		}
		
		MoonCalc(jday, &moon, ed);
		l2 = put_in_360(moon.longitude_deg - ayanamsa);
		new_naks = (int)(floor(l2/phi));
		
		if (prev_naks != new_naks)
		{
			jday = xj;
			d = xd;
			scan_step *= 0.5;
			counter++;
			continue;
		}
		
	}
	
	*nextDate = d;
	return prev_naks;
	
}

/*********************************************************************/
/*                                                                   */
/*   finds next time when starts next tithi                          */
/*                                                                   */
/*   timezone is not changed                                         */
/*                                                                   */
/*   return value: index of tithi 0..29                              */
/*                 or -1 if failed                                   */
/*********************************************************************/

int GetNextTithiStart(gc_earth ed, gc_time startDate, gc_time * nextDate)
{
	double phi = 12.0;
	double l1, l2, sunl;
	JULIANDATE jday = gc_time_GetJulianComplete(&startDate);
	JULIANDATE xj;
	gc_moon moon;
	gc_time d = startDate;
	gc_time xd;
	double scan_step = 0.5;
	int prev_tit = 0;
	int new_tit = -1;
	
	MoonCalc(jday, &moon, ed);
	sunl = GetSunLongitude(d);
	l1 = put_in_360(moon.longitude_deg - sunl - 180.0);
	prev_tit = (int)(floor(l1/phi));
	
	int counter = 0;
	while(counter < 20)
	{
		xj = jday;
		xd = d;
		
		jday += scan_step;
		d.shour += scan_step;
		if (d.shour > 1.0)
		{
			d.shour -= 1.0;
			GetNextDay(&d);
		}
		
		MoonCalc(jday, &moon, ed);
		sunl = GetSunLongitude(d);
		//NSLog(@"MoonLong = %f, Sun Long = %f\n", moon.longitude_deg, sunl);
		l2 = put_in_360(moon.longitude_deg - sunl - 180.0);
		new_tit = (int)(floor(l2/phi));
		
		if (prev_tit != new_tit)
		{
			jday = xj;
			d = xd;
			scan_step *= 0.5;
			counter++;
			continue;
		}
	}
	*nextDate = d;
	return new_tit;
}

/*********************************************************************/
/*                                                                   */
/*   finds previous time when starts next tithi                      */
/*                                                                   */
/*   timezone is not changed                                         */
/*                                                                   */
/*   return value: index of tithi 0..29                              */
/*                 or -1 if failed                                   */
/*********************************************************************/

int GetPrevTithiStart(gc_earth ed, gc_time startDate, gc_time * nextDate)
{
	double phi = 12.0;
	double l1, l2, sunl;
	JULIANDATE jday = gc_time_GetJulianComplete(&startDate);
	JULIANDATE xj;
	gc_moon moon;
	gc_time d = startDate;
	gc_time xd;
	double scan_step = 0.5;
	int prev_tit = 0;
	int new_tit = -1;
	
	MoonCalc(jday, &moon, ed);
	sunl = GetSunLongitude(d);
	l1 = put_in_360(moon.longitude_deg - sunl - 180.0);
	prev_tit = (int)(floor(l1/phi));
	
	int counter = 0;
	while(counter < 20)
	{
		xj = jday;
		xd = d;
		
		jday -= scan_step;
		d.shour -= scan_step;
		if (d.shour < 0.0)
		{
			d.shour += 1.0;
			GetPrevDay(&d);
		}
		
		MoonCalc(jday, &moon, ed);
		sunl = GetSunLongitude(d);
		l2 = put_in_360(moon.longitude_deg - sunl - 180.0);
		new_tit = (int)(floor(l2/phi));
		
		if (prev_tit != new_tit)
		{
			jday = xj;
			d = xd;
			scan_step *= 0.5;
			counter++;
			continue;
		}
	}
	*nextDate = d;
	return prev_tit;
}

//===========================================================================
//
//===========================================================================

void VATIMEtoVCTIME(ga_time va, gc_time * vc, gc_earth earth)
{
	*vc = CalcTithiDate(va.gyear, va.masa, va.tithi / 15, va.tithi % 15, earth);
}

//===========================================================================
//
//===========================================================================

void VCTIMEtoVATIME(gc_time vc, ga_time *va, gc_earth earth)
{
	gc_astro day;
	
	day = DayCalc(vc, earth);
	day = MasaCalc(vc, day, earth);
	va->masa = day.nMasa;
	va->gyear = day.nGaurabdaYear;
	va->tithi = day.nTithi;
}



DAYHOURS GetTithiTimes(gc_earth ed, gc_time vc, DAYHOURS * titBeg, DAYHOURS * titEnd, DAYHOURS sunRise)
{
	gc_time d1, d2;
	
	vc.shour = sunRise;
	GetPrevTithiStart(ed, vc, &d1);
	GetNextTithiStart(ed, vc, &d2);
	
	*titBeg = d1.shour + gc_time_GetJulian(&d1) - gc_time_GetJulian(&vc);
	*titEnd = d2.shour + gc_time_GetJulian(&d2) - gc_time_GetJulian(&vc);
	
	return (*titEnd - *titBeg);
}
