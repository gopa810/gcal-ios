#include <math.h>
#import "gc_dtypes.h"
#import <UIKit/UIKit.h>

#import "GCGregorianTime.h"

#pragma mark ===== ga_time functions =====

void ga_time_init(ga_time* S, int t, int m, int y) 
{
	S->tithi = t;
	S->masa = m;
	S->gyear = y;
}

void ga_time_next(ga_time* S)
{
	S->tithi++;
	if (S->tithi >= 30)
	{
		S->tithi %= 30;
		S->masa++;
	}
	if (S->masa >= 12)
	{
		S->masa %= 12;
		S->gyear++;
	}
}

void ga_time_prev(ga_time * S)
{
	if (S->tithi == 0)
	{
		if (S->masa == 0)
		{
			S->masa = 11;
			S->tithi = 29;
		}
		else
		{
			S->masa--;
			S->tithi = 29;
		}
	}
	else
	{
		S->tithi--;
	}
}

#pragma mark ===== gc_time functions =====


void gc_time_Today(gc_time * s)
{
	time_t st;
	
	time(&st);
	struct tm * pt;
	
	pt = localtime(&st);
	
	s->day = pt->tm_mday;
	s->month = pt->tm_mon + 1;
	s->year = pt->tm_year + 1900;
	s->shour = 0.5;
	s->tzone = 0.0;
	
}


// vracia -1, ak zadany den je den nasledujuci po THIS
// vracia 1 ak THIS je nasledujuci den po zadanom dni

int gc_time_CompareYMD(GCGregorianTime * u, GCGregorianTime * v)
{
	if (v.year < u.year)
		return (u.year - v.year) * 365;
	else if (v.year > u.year)
		return (u.year - v.year) * 365;
	
	if (v.month < u.month)
		return (u.month - v.month)*31;
	else if (v.month > u.month)
		return (u.month - v.month)*31;
	
	return (u.day - v.day);
}


int gc_time_GetHour(gc_time p)
{
	return (int)(floor(p.shour*24));
}

int gc_time_GetMinute(gc_time p)
{
	return (int)(floor((p.shour*24 - (int)(p.shour*24)) * 60));
}

int gc_time_GetMinuteRound(gc_time p)
{
	return (int)(floor((p.shour*24 - (int)(p.shour*24)) * 60 + 0.5));
}

int gc_time_GetSecond(gc_time p)
{
	return (int)(floor((p.shour*1440 - (int)(floor(p.shour*1440))) * 60));
}

int gc_time_GetDayInteger(gc_time p)
{
	return p.year * 384 + p.month * 32 + p.day;
}

			

/************************************************************************
 
 Routines for gregorian calendar days, julian calendar, daylight saving time routines, etc.
 
 *************************************************************************/

double GetJulianDayInteger(int year, int month, int day)
{
    int yy = year - (int)((12 - month) / 10);
    int mm = month + 9;
    
    if (mm >= 12)
        mm -= 12;
    
    int k1, k2, k3;
    int j;
    
    k1 = (int) (floor(365.25 * (yy + 4712)));
    k2 = (int) (floor(30.6 * mm + 0.5));
    k3 = (int) (floor(floor((yy/100)+49)*.75))-38;
    j = k1 + k2 + day + 59;
    if (j > 2299160)
        j -= k3;
    
    return j;
}

double GetJulianDay(int year, int month, int day)
{
	return (double)GetJulianDayInteger(year, month, day);
}

double gc_time_GetJulianDay(gc_time date)
{
	// julian day is xxx.0 at 12:00 UTC
	// date.shour is time of event (0..1) = (0..24hour)
	// timezone shifts julian day - east longitude
	return GetJulianDay(date.year, date.month, date.day)
		- 0.5 + date.shour;
}

char g_year_days[2][367][2] = {
	{
		{1,1}, {2,1}, {3,1}, {4,1}, {5,1}, {6,1}, {7,1}, {8,1}, {9,1}, {10,1},
		{11,1}, {12,1}, {13,1}, {14,1}, {15,1}, {16,1}, {17,1}, {18,1}, {19,1}, {20,1},
		{21,1}, {22,1}, {23,1}, {24,1}, {25,1}, {26,1}, {27,1}, {28,1}, {29,1}, {30, 1}, {31,1},
		
		{1,2}, {2,2}, {3,2}, {4,2}, {5,2}, {6,2}, {7,2}, {8,2}, {9,2}, {10,2},
		{11,2}, {12,2}, {13,2}, {14,2}, {15,2}, {16,2}, {17,2}, {18,2}, {19,2}, {20,2},
		{21,2}, {22,2}, {23,2}, {24,2}, {25,2}, {26,2}, {27,2}, {28,2},
		
		{1,3}, {2,3}, {3,3}, {4,3}, {5,3}, {6,3}, {7,3}, {8,3}, {9,3}, {10,3},
		{11,3}, {12,3}, {13,3}, {14,3}, {15,3}, {16,3}, {17,3}, {18,3}, {19,3}, {20,3},
		{21,3}, {22,3}, {23,3}, {24,3}, {25,3}, {26,3}, {27,3}, {28,3}, {29,3}, {30, 3}, {31,3},
		
		{1,4}, {2,4}, {3,4}, {4,4}, {5,4}, {6,4}, {7,4}, {8,4}, {9,4}, {10,4},
		{11,4}, {12,4}, {13,4}, {14,4}, {15,4}, {16,4}, {17,4}, {18,4}, {19,4}, {20,4},
		{21,4}, {22,4}, {23,4}, {24,4}, {25,4}, {26,4}, {27,4}, {28,4}, {29,4}, {30, 4},
		
		{1,5}, {2,5}, {3,5}, {4,5}, {5,5}, {6,5}, {7,5}, {8,5}, {9,5}, {10,5},
		{11,5}, {12,5}, {13,5}, {14,5}, {15,5}, {16,5}, {17,5}, {18,5}, {19,5}, {20,5},
		{21,5}, {22,5}, {23,5}, {24,5}, {25,5}, {26,5}, {27,5}, {28,5}, {29,5}, {30, 5}, {31,5},
		
		{1,6}, {2,6}, {3,6}, {4,6}, {5,6}, {6,6}, {7,6}, {8,6}, {9,6}, {10,6},
		{11,6}, {12,6}, {13,6}, {14,6}, {15,6}, {16,6}, {17,6}, {18,6}, {19,6}, {20,6},
		{21,6}, {22,6}, {23,6}, {24,6}, {25,6}, {26,6}, {27,6}, {28,6}, {29,6}, {30, 6},
		
		{1,7}, {2,7}, {3,7}, {4,7}, {5,7}, {6,7}, {7,7}, {8,7}, {9,7}, {10,7},
		{11,7}, {12,7}, {13,7}, {14,7}, {15,7}, {16,7}, {17,7}, {18,7}, {19,7}, {20,7},
		{21,7}, {22,7}, {23,7}, {24,7}, {25,7}, {26,7}, {27,7}, {28,7}, {29,7}, {30, 7}, {31,7},
		
		{1,8}, {2,8}, {3,8}, {4,8}, {5,8}, {6,8}, {7,8}, {8,8}, {9,8}, {10,8},
		{11,8}, {12,8}, {13,8}, {14,8}, {15,8}, {16,8}, {17,8}, {18,8}, {19,8}, {20,8},
		{21,8}, {22,8}, {23,8}, {24,8}, {25,8}, {26,8}, {27,8}, {28,8}, {29,8}, {30, 8}, {31,8},
		
		{1,9}, {2,9}, {3,9}, {4,9}, {5,9}, {6,9}, {7,9}, {8,9}, {9,9}, {10,9},
		{11,9}, {12,9}, {13,9}, {14,9}, {15,9}, {16,9}, {17,9}, {18,9}, {19,9}, {20,9},
		{21,9}, {22,9}, {23,9}, {24,9}, {25,9}, {26,9}, {27,9}, {28,9}, {29,9}, {30, 9},
		
		{1,10}, {2,10}, {3,10}, {4,10}, {5,10}, {6,10}, {7,10}, {8,10}, {9,10}, {10,10},
		{11,10}, {12,10}, {13,10}, {14,10}, {15,10}, {16,10}, {17,10}, {18,10}, {19,10}, {20,10},
		{21,10}, {22,10}, {23,10}, {24,10}, {25,10}, {26,10}, {27,10}, {28,10}, {29,10}, {30, 10}, {31,10},
		
		{1,11}, {2,11}, {3,11}, {4,11}, {5,11}, {6,11}, {7,11}, {8,11}, {9,11}, {10,11},
		{11,11}, {12,11}, {13,11}, {14,11}, {15,11}, {16,11}, {17,11}, {18,11}, {19,11}, {20,11},
		{21,11}, {22,11}, {23,11}, {24,11}, {25,11}, {26,11}, {27,11}, {28,11}, {29,11}, {30, 11},
		
		{1,12}, {2,12}, {3,12}, {4,12}, {5,12}, {6,12}, {7,12}, {8,12}, {9,12}, {10,12},
		{11,12}, {12,12}, {13,12}, {14,12}, {15,12}, {16,12}, {17,12}, {18,12}, {19,12}, {20,12},
		{21,12}, {22,12}, {23,12}, {24,12}, {25,12}, {26,12}, {27,12}, {28,12}, {29,12}, {30, 12}, {31,12},
		
		{-1,-1}, {-1,-1}//end of year
	},
	{
		{1,1}, {2,1}, {3,1}, {4,1}, {5,1}, {6,1}, {7,1}, {8,1}, {9,1}, {10,1},
		{11,1}, {12,1}, {13,1}, {14,1}, {15,1}, {16,1}, {17,1}, {18,1}, {19,1}, {20,1},
		{21,1}, {22,1}, {23,1}, {24,1}, {25,1}, {26,1}, {27,1}, {28,1}, {29,1}, {30, 1}, {31,1},
		
		{1,2}, {2,2}, {3,2}, {4,2}, {5,2}, {6,2}, {7,2}, {8,2}, {9,2}, {10,2},
		{11,2}, {12,2}, {13,2}, {14,2}, {15,2}, {16,2}, {17,2}, {18,2}, {19,2}, {20,2},
		{21,2}, {22,2}, {23,2}, {24,2}, {25,2}, {26,2}, {27,2}, {28,2}, {29,2},
		
		{1,3}, {2,3}, {3,3}, {4,3}, {5,3}, {6,3}, {7,3}, {8,3}, {9,3}, {10,3},
		{11,3}, {12,3}, {13,3}, {14,3}, {15,3}, {16,3}, {17,3}, {18,3}, {19,3}, {20,3},
		{21,3}, {22,3}, {23,3}, {24,3}, {25,3}, {26,3}, {27,3}, {28,3}, {29,3}, {30, 3}, {31,3},
		
		{1,4}, {2,4}, {3,4}, {4,4}, {5,4}, {6,4}, {7,4}, {8,4}, {9,4}, {10,4},
		{11,4}, {12,4}, {13,4}, {14,4}, {15,4}, {16,4}, {17,4}, {18,4}, {19,4}, {20,4},
		{21,4}, {22,4}, {23,4}, {24,4}, {25,4}, {26,4}, {27,4}, {28,4}, {29,4}, {30, 4},
		
		{1,5}, {2,5}, {3,5}, {4,5}, {5,5}, {6,5}, {7,5}, {8,5}, {9,5}, {10,5},
		{11,5}, {12,5}, {13,5}, {14,5}, {15,5}, {16,5}, {17,5}, {18,5}, {19,5}, {20,5},
		{21,5}, {22,5}, {23,5}, {24,5}, {25,5}, {26,5}, {27,5}, {28,5}, {29,5}, {30, 5}, {31,5},
		
		{1,6}, {2,6}, {3,6}, {4,6}, {5,6}, {6,6}, {7,6}, {8,6}, {9,6}, {10,6},
		{11,6}, {12,6}, {13,6}, {14,6}, {15,6}, {16,6}, {17,6}, {18,6}, {19,6}, {20,6},
		{21,6}, {22,6}, {23,6}, {24,6}, {25,6}, {26,6}, {27,6}, {28,6}, {29,6}, {30, 6},
		
		{1,7}, {2,7}, {3,7}, {4,7}, {5,7}, {6,7}, {7,7}, {8,7}, {9,7}, {10,7},
		{11,7}, {12,7}, {13,7}, {14,7}, {15,7}, {16,7}, {17,7}, {18,7}, {19,7}, {20,7},
		{21,7}, {22,7}, {23,7}, {24,7}, {25,7}, {26,7}, {27,7}, {28,7}, {29,7}, {30, 7}, {31,7},
		
		{1,8}, {2,8}, {3,8}, {4,8}, {5,8}, {6,8}, {7,8}, {8,8}, {9,8}, {10,8},
		{11,8}, {12,8}, {13,8}, {14,8}, {15,8}, {16,8}, {17,8}, {18,8}, {19,8}, {20,8},
		{21,8}, {22,8}, {23,8}, {24,8}, {25,8}, {26,8}, {27,8}, {28,8}, {29,8}, {30, 8}, {31,8},
		
		{1,9}, {2,9}, {3,9}, {4,9}, {5,9}, {6,9}, {7,9}, {8,9}, {9,9}, {10,9},
		{11,9}, {12,9}, {13,9}, {14,9}, {15,9}, {16,9}, {17,9}, {18,9}, {19,9}, {20,9},
		{21,9}, {22,9}, {23,9}, {24,9}, {25,9}, {26,9}, {27,9}, {28,9}, {29,9}, {30, 9},
		
		{1,10}, {2,10}, {3,10}, {4,10}, {5,10}, {6,10}, {7,10}, {8,10}, {9,10}, {10,10},
		{11,10}, {12,10}, {13,10}, {14,10}, {15,10}, {16,10}, {17,10}, {18,10}, {19,10}, {20,10},
		{21,10}, {22,10}, {23,10}, {24,10}, {25,10}, {26,10}, {27,10}, {28,10}, {29,10}, {30, 10}, {31,10},
		
		{1,11}, {2,11}, {3,11}, {4,11}, {5,11}, {6,11}, {7,11}, {8,11}, {9,11}, {10,11},
		{11,11}, {12,11}, {13,11}, {14,11}, {15,11}, {16,11}, {17,11}, {18,11}, {19,11}, {20,11},
		{21,11}, {22,11}, {23,11}, {24,11}, {25,11}, {26,11}, {27,11}, {28,11}, {29,11}, {30, 11},
		
		{1,12}, {2,12}, {3,12}, {4,12}, {5,12}, {6,12}, {7,12}, {8,12}, {9,12}, {10,12},
		{11,12}, {12,12}, {13,12}, {14,12}, {15,12}, {16,12}, {17,12}, {18,12}, {19,12}, {20,12},
		{21,12}, {22,12}, {23,12}, {24,12}, {25,12}, {26,12}, {27,12}, {28,12}, {29,12}, {30, 12}, {31,12},
		
		{-1,-1}//end of year
	}
};

int GetGregorianYearLength(BOOL bOverlapped)
{
	return bOverlapped ? 366 : 365;
}

int GetGregorianDay(BOOL bOverlapped, int nDayIndex)
{
	return g_year_days[(bOverlapped ? 1 : 0)][nDayIndex][0];
}

int GetGregorianMonth(BOOL bOverlapped, int nDayIndex)
{
	return g_year_days[(bOverlapped ? 1 : 0)][nDayIndex][1];
}

BOOL IsLeapYear(int year)
{
	if ((year % 4) == 0)
	{
		if ((year % 100 == 0) && (year % 400 != 0))
			return false;
		else
			return true;
	}
	
	return false;
}

int GetMonthMaxDays(int year, int month)
{
	int m_months_ovr[13] = { 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }; 
	int m_months[13] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }; 
	
	if (IsLeapYear(year))
		return m_months_ovr[month];
	else
		return m_months[month];
}

void GetPrevDay(gc_time * day)
{
	day->day--;
	
	if (day->day < 1)
	{
		day->month--;
		if (day->month < 1)
		{
			day->month = 12;
			day->year--;
		}
		day->day = GetMonthMaxDays(day->year, day->month);
	}
}

void GetNextDay(gc_time * day)
{
	day->day++;
	if (day->day > GetMonthMaxDays(day->year, day->month))
	{
		day->day = 1;
		day->month ++;
	}
	
	if (day->month > 12)
	{
		day->month = 1;
		day->year++;
	}
}


void gc_time_NormalizeValues(gc_time * g)
{
	NormalizeValues(&(g->year), &(g->month), &(g->day), &(g->shour));
}

void gc_time_add_hours(gc_time * p, double val)
{
	p->shour += val;
	gc_time_NormalizeValues(p);
}

void gc_time_add_days(gc_time * p, int n)
{
	for(int i = 0; i < n; i++)
		GetNextDay(p);
}

void gc_time_sub_days(gc_time * p, int n)
{
	for(int i = 0; i < n; i++)
		GetPrevDay(p);
}

BOOL gc_time_lt(gc_time date1, gc_time date2)
{
	int y1, y2, m1, m2, d1, d2;
	double h1, h2;
	d1 = date1.day;
	d2 = date2.day;
	m1 = date1.month;
	m2 = date2.month;
	y1 = date1.year;
	y2 = date2.year;
	h1 = date1.shour + date1.tzone/24.0;
	h2 = date2.shour + date2.tzone/24.0;
	
	NormalizeValues(&y1, &m1, &d1, &h1);
	NormalizeValues(&y2, &m2, &d2, &h2);
	
	return ((y1*400+m1*32+d1) < (y2*400+m2*32+d2));
}

BOOL gc_time_le(gc_time date1, gc_time date2)
{
	int y1, y2, m1, m2, d1, d2;
	double h1, h2;
	d1 = date1.day;
	d2 = date2.day;
	m1 = date1.month;
	m2 = date2.month;
	y1 = date1.year;
	y2 = date2.year;
	h1 = date1.shour + date1.tzone/24.0;
	h2 = date2.shour + date2.tzone/24.0;
	
	NormalizeValues(&y1, &m1, &d1, &h1);
	NormalizeValues(&y2, &m2, &d2, &h2);
	
	return ((y1*400+m1*32+d1) <= (y2*400+m2*32+d2));
}

BOOL gc_time_gt(gc_time date1, gc_time date2)
{
	int y1, y2, m1, m2, d1, d2;
	double h1, h2;
	d1 = date1.day;
	d2 = date2.day;
	m1 = date1.month;
	m2 = date2.month;
	y1 = date1.year;
	y2 = date2.year;
	h1 = date1.shour + date1.tzone/24.0;
	h2 = date2.shour + date2.tzone/24.0;
	
	NormalizeValues(&y1, &m1, &d1, &h1);
	NormalizeValues(&y2, &m2, &d2, &h2);
	
	return ((y1*400+m1*32+d1) > (y2*400+m2*32+d2));
}

BOOL gc_time_ge(gc_time date1, gc_time date2)
{
	int y1, y2, m1, m2, d1, d2;
	double h1, h2;
	d1 = date1.day;
	d2 = date2.day;
	m1 = date1.month;
	m2 = date2.month;
	y1 = date1.year;
	y2 = date2.year;
	h1 = date1.shour + date1.tzone/24.0;
	h2 = date2.shour + date2.tzone/24.0;
	
	NormalizeValues(&y1, &m1, &d1, &h1);
	NormalizeValues(&y2, &m2, &d2, &h2);
	
	return ((y1*400+m1*32+d1) >= (y2*400+m2*32+d2));
}

BOOL gc_time_eq(gc_time date1, gc_time date2)
{
	int y1, y2, m1, m2, d1, d2;
	double h1, h2;
	d1 = date1.day;
	d2 = date2.day;
	m1 = date1.month;
	m2 = date2.month;
	y1 = date1.year;
	y2 = date2.year;
	h1 = date1.shour + date1.tzone/24.0;
	h2 = date2.shour + date2.tzone/24.0;
	
	NormalizeValues(&y1, &m1, &d1, &h1);
	NormalizeValues(&y2, &m2, &d2, &h2);
	
	return ((y1 == y2) && (m1 == m2) && (d1 == d2));
}

BOOL gc_time_IsBeforeThis(gc_time d1, gc_time d2)
{
	return gc_time_lt(d1, d2);
}

void NormalizeValues(int * y1, int * m1, int * d1, double * h1)
{
	//NSLog(@"nv: 1 %d/%d/%d/%f\n", *y1, *m1, *d1, *h1);
	if (*h1 < 0.0)
	{
		(*d1)--;
		*h1 += 1.0;
		//NSLog(@"nv: 2\n");
	}
	if (*h1 >= 1.0)
	{
		*h1 -= 1.0;
		//NSLog(@"nv: 3 d=%d\n", *d1);
		(*d1)++;
		//NSLog(@"nv: 3 d=%d\n", *d1);
	}
	if (*d1 < 1)
	{
		//NSLog(@"nv: 4\n");
		(*m1)--;
		if (*m1 < 1)
		{
			*m1 = 12;
			(*y1)--;
		}
		*d1 = GetMonthMaxDays(*y1, *m1);
	}
	else if (*d1 > GetMonthMaxDays(*y1, *m1))
	{
		//NSLog(@"nv: 5\n");
		(*m1)++;
		if (*m1 > 12)
		{
			*m1 = 1;
			(*y1)++;
		}
		*d1 = 1;
	}
}

BOOL gc_time_IsLeapYear(gc_time g)
{
	return IsLeapYear(g.year);
}

void gc_time_ChangeTimeZone(gc_time * g, double tZone)
{
	g->shour += (tZone - g->tzone)/24;
	NormalizeValues(&(g->year), &(g->month), &(g->day), &(g->shour));
	g->tzone = tZone;
}


double gc_time_GetJulian(gc_time * g)
{
	int yy = g->year - (int)((12 - g->month) / 10);
	int mm = g->month + 9;
	
	if (mm >= 12)
		mm -= 12;
	
	int k1, k2, k3;
	int j;
	
	k1 = (int)(floor(365.25 * (yy + 4712)));
	k2 = (int)(floor(30.6 * mm + 0.5));
	k3 = (int)(floor(floor((yy/100)+49)*.75))-38;
	j = k1 + k2 + g->day + 59;
	if (j > 2299160)
		j -= k3;
	
	return (double)j;
}


double gc_time_GetJulianDetailed(gc_time * p)
{
	return gc_time_GetJulian(p) - 0.5 + p->shour;
}

double gc_time_GetJulianComplete(gc_time * p)
{
	return gc_time_GetJulian(p) - 0.5 + p->shour - p->tzone/24.0;
}


void gc_time_InitWeekDay(gc_time * p)
{
	p->dayOfWeek = ((int)(gc_time_GetJulian(p)) + 1) % 7;
}

void gc_time_SetFromJulian(gc_time * p, JULIANDATE jd)
{
	double z = floor(jd + 0.5);
	double f = (jd + 0.5) - z;
	double A, B, C, D, E, alpha;
	
	if (z < 2299161.0)
	{
		A = z;
	} 
	else 
	{
		alpha = floor((z - 1867216.25)/36524.25);
		A = z + 1.0 + alpha - floor(alpha/4.0);
	}
	
	B = A + 1524;
	C = floor((B - 122.1)/365.25);
	D = floor(365.25 * C);
	E = floor((B - D)/30.6001);
	p->day = (int) floor(B - D - floor(30.6001 * E) + f);
	p->month = (int)((E < 14) ? E - 1 : E - 13);
	p->year = (int)((p->month > 2) ? C - 4716 : C - 4715);
	p->tzone = 0.0;
	p->shour = modf(jd + 0.5, &z);
}


// n - is order number of given day
// x - is number of day in week (0-sunday, 1-monday, ..6-saturday)
// if x >= 5, then is calculated whether day is after last x-day

BOOL is_n_xday(gc_time vc, int n, int x)
{
	int xx[7] = {1, 7, 6, 5, 4, 3, 2};
	
	int fdm, fxdm, nxdm, max;
	
	// prvy den mesiaca
	fdm = xx[ (7 + vc.day - vc.dayOfWeek) % 7 ];
	
	// 1. x-day v mesiaci ma datum
	fxdm = xx[ (fdm - x + 7) % 7 ];
	
	// n-ty x-day ma datum
	if ((n < 0) || (n >= 5))
	{
		nxdm = fxdm + 28;
		max = GetMonthMaxDays(vc.year, vc.month);
		while(nxdm > max)
		{
			nxdm -= 7;
		}
	}
	else
	{
		nxdm = fxdm + (n - 1)* 7;
	}
	
	return (vc.day >= nxdm) ? YES : NO;
}

// This table has 8 items for each line:
//  [0]: starting month
//  [4]: ending month
// 
//  [1]: type of day, 0-day is given as n-th x-day of month, 1- day is given as DATE
//  [2]: for [1]==1 this means day of month
//     : for [1]==0 this order number of occurance of the given day (1,2,3,4 is acceptable, 5 means *last*)
//  [3]: used only for [1]==0, and this means day of week (0=sunday,1=monday,2=tuesday,3=wednesday,...)
//     : [1] to [3] are used for starting month
//  [5] to [7] is used for ending month in the same way as [1] to [3] for starting month
//
// EXAMPLE: (first line)   3 0 5 0 10 0 5 0
// [0] == 3, that means starting month is March
// [1] == 0, that means starting system is (day of week)
// [2] == 5, that would mean that we are looking for 5th occurance of given day in the month, but 5 here means,
//           that we are looking for *LAST* occurance of given day
// [3] == 0, this is *GIVEN DAY*, and it is SUNDAY
//
//         so, DST is starting on last sunday of March
//
// similarly analysed, DST is ending on last sunday of October
//
void timeZone_ExpandVal(NSUInteger val, int a[])
{
	a[7] = val & 0xf;
	val >>= 4;
	a[6] = val & 0x3f;
	val >>= 6;
	a[5] = val & 0x3;
	val >>= 2;
	a[4] = val & 0xf;
	val >>= 4;
	a[3] = val & 0xf;
	val >>= 4;
	a[2] = val & 0x3f;
	val >>= 6;
	a[1] = val & 0x3;
	val >>= 2;
	a[0] = val & 0xf;	
	
}

BOOL GetDaylightBias(gc_time vc, NSUInteger val)
{
	int DSTtable[8];
	int bias = 1;
	
	timeZone_ExpandVal(val, DSTtable);
	
	if (vc.month == DSTtable[0])
	{
		if (DSTtable[1] == 0)
			return is_n_xday(vc, DSTtable[2], DSTtable[3]) * bias;
		else
			return (vc.day >= DSTtable[2]) ? bias : 0;
	}
	else if (vc.month == DSTtable[4])
	{
		if (DSTtable[5] == 0)
			return (1 - is_n_xday(vc, DSTtable[6], DSTtable[7]))*bias;
		else
			return (vc.day >= DSTtable[6]) ? 0 : bias;
	}
	else 
	{
		if (DSTtable[0] > DSTtable[4])
		{
			// zaciatocny mesiac ma vyssie cislo nez koncovy
			// napr. pre australiu
			if ((vc.month > DSTtable[0]) || (vc.month < DSTtable[4]))
				return bias;
		}
		else
		{
			// zaciatocny mesiac ma nizsie cislo nez koncovy
			// usa, europa, asia
			if ((vc.month > DSTtable[0]) && (vc.month < DSTtable[4]))
				return bias;
		}
		
		return 0;
	}
}


BOOL is_daylight_time(gc_time vc, NSUInteger nValue)
{
	return GetDaylightBias(vc, nValue);
}


int gc_time_set_int(gc_time * t, int i)
{
	t->year = i;
	t->month = i;
	t->day = i;
	t->shour = 0.0;
	t->tzone = 0.0;
	
	return i;
}

NSString * gc_time_getDayHumanTitle(gc_time p)
{
	gc_time vc;
	int n;
	
	gc_time_Today(&vc);

	n = (int)(gc_time_GetJulian(&vc) - gc_time_GetJulian(&p));
	
	if (n == 1)
		return @"[Yesterday]";
	else if (n == 0)
		return @"[Today]";
	else if (n == -1)
		return @"[Tomorrow]";
	return @"";
}



#pragma mark ===== gc_daytime_functions =====

void gc_daytime_add_minutes(gc_daytime * d,int mn) 
{
	d->minute += mn;
	while(d->minute < 0) { d->minute += 60; d->hour--;}
	while(d->minute > 59) { d->minute -= 60; d->hour++;}
}

void gc_daytime_sub_minutes(gc_daytime * d,int mn) 
{
	d->minute -= mn;
	while(d->minute < 0) { d->minute += 60; d->hour--;}
	while(d->minute > 59) { d->minute -= 60; d->hour++;}
}



////////////////////////////////////////////////////////////////
//
//  Conversion time from DEGREE fromat to H:M:S:MS format
//
//  time - output
//  time_deg - input time in range 0 deg to 360 deg
//             where 0 deg = 0:00 AM and 360 deg = 12:00 PM
//
void gc_daytime_SetDegTime(gc_daytime * pd, double time_deg)
{
	double time_hr = 0.0;
	
	time_deg = put_in_360(time_deg);
	
	// hour
	time_hr = time_deg / 360 * 24;
	pd->hour = (int)( floor(time_hr) );
	
	// minute
	time_hr -= pd->hour;
	time_hr *= 60;
	pd->minute = (int)( floor(time_hr) );
	
	// second
	time_hr -= pd->minute;
	time_hr *= 60;
	pd->sec = (int)( floor(time_hr) );
	
	// miliseconds
	time_hr -= pd->sec;
	time_hr *= 1000;
	pd->mili = (int)( floor(time_hr) );
}


void gc_daytime_SetDayTime(gc_daytime * pd, double d)
{
	double time_hr = 0.0;
	
	// hour
	time_hr = d * 24;
	pd->hour = (int) floor(time_hr) ;
	
	// minute
	time_hr -= pd->hour;
	time_hr *= 60;
	pd->minute = (int) floor(time_hr) ;
	
	// second
	time_hr -= pd->minute;
	time_hr *= 60;
	pd->sec = (int) floor(time_hr) ;
	
	// miliseconds
	time_hr -= pd->sec;
	time_hr *= 1000;
	pd->mili = (int) floor(time_hr) ;
}

gc_daytime gc_daytime_initFromDegTime(double d)
{
	gc_daytime dat;
	gc_daytime_SetDegTime(&dat, d);
	return dat;
}

void gc_daytime_SetValue(gc_daytime * p, int i)
{
	p->hour = p->minute = p->sec = p->mili = i;
}

gc_daytime gc_daytime_init(int a)
{
	gc_daytime g;
	gc_daytime_SetValue(&g, a);
	return g;
}

BOOL gc_daytime_gt(gc_daytime d1, gc_daytime d2)
{
	if (d1.hour*3600+d1.minute*60+d1.sec 
		> 
		d2.hour*3600+d2.minute*60+d2.sec)
		return true;
	
	if (d1.mili > d2.mili)
		return true;
	
	return false;
}

BOOL gc_daytime_ge(gc_daytime d1, gc_daytime d2)
{
	if (d1.hour*3600+d1.minute*60+d1.sec 
		>=
		d2.hour*3600+d2.minute*60+d2.sec)
		return true;
	
	if (d1.mili >= d2.mili)
		return true;
	
	return false;
}

BOOL gc_daytime_lt(gc_daytime d1, gc_daytime d2)
{
	if (d1.hour*3600+d1.minute*60+d1.sec 
		< 
		d2.hour*3600+d2.minute*60+d2.sec)
		return true;
	
	if (d1.mili < d2.mili)
		return true;
	
	return false;
}

BOOL gc_daytime_le(gc_daytime d1, gc_daytime d2)
{
	if (d1.hour*3600+d1.minute*60+d1.sec 
		<= 
		d2.hour*3600+d2.minute*60+d2.sec)
		return true;
	
	if (d1.mili <= d2.mili)
		return true;
	
	return false;
}

double gc_daytime_GetDayTime(gc_daytime p)
{
	return ((p.hour*60.0 + p.minute)*60.0 + p.sec) / 86400.0;
}


#pragma mark ===== gc_earth functions =====

void gc_earth_init(gc_earth * e)
{ 
	e->obs = 0;
	e->longitude_deg = 0.0;
	e->latitude_deg = 0.0;
	e->tzone = 0.0;
	e->dst = 0;
}



#pragma mark ===== combo masa functions =====

int AvcComboMasaToMasa(int nComboMasa)
{
	return (nComboMasa == 12) ? 12 : ((nComboMasa + 11) % 12);
}

int AvcMasaToComboMasa(int nMasa)
{
	return (nMasa == 12) ? 12 : ((nMasa + 1) % 12);
}

int ctoi(char c)
{
	if ((c >= '0') && (c <= '9'))
		return c - '0';
	else
		return 0;
}






