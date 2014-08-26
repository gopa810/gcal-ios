#ifndef _GC_DTYPES_H___
#define _GC_DTYPES_H___


#pragma mark ===== MATH FUNCTIONS =====

double cos_d(double x);
double sin_d(double x);
double tan_d(double x);
double arcsin_d(double x);
double arctan_d(double x);
double arccos_d(double x);

double arctan2_d(double x, double y);
double put_in_360(double id);
double put_in_180(double in_d);
double norm_val(double v);
int    sgn(double d);
double rad2deg(double x);
double deg2rad(double x);
void NormalizeValues(int * y1, int * m1, int * d1, double * h1);

#pragma mark ===== ASTRONOMICAL FUNCTIONS ===== 

typedef double JULIANDATE;
typedef double DAYHOURS;

typedef struct _ga_time
{
	int tithi;
	int masa;
	int gyear;
} ga_time;

void ga_time_init(ga_time * S, int t, int m, int y); 
void ga_time_prev(ga_time * S);
void ga_time_next(ga_time * S);

typedef struct _gc_time
{
    int year;
    int month;
    int dayOfWeek;
    int day;
	DAYHOURS shour;
	double tzone;
} gc_time;

BOOL IsLeapYear(int);
BOOL gc_time_eq(gc_time, gc_time);
BOOL gc_time_IsBeforeThis(gc_time, gc_time);
BOOL gc_time_IsLeapYear(gc_time year);
BOOL gc_time_le(gc_time, gc_time);
BOOL gc_time_lt(gc_time, gc_time);
NSString * gc_time_getDayHumanTitle(gc_time);
double gc_time_GetJulian(gc_time *);
double gc_time_GetJulianComplete(gc_time *);
double gc_time_GetJulianDetailed(gc_time *);
int  gc_time_CompareYMD(gc_time, gc_time);
int  gc_time_GetDayInteger(gc_time);
int  gc_time_GetHour(gc_time);
int  gc_time_GetMinute(gc_time);
int  gc_time_GetMinuteRound(gc_time);
int  gc_time_GetMonthMaxDays(gc_time *, int year, int month);
int  gc_time_GetSecond(gc_time);
int  gc_time_set_int(gc_time *, int i);
void gc_time_add_days(gc_time *, int);
void gc_time_ChangeTimeZone(gc_time *, double);
void gc_time_init(gc_time *);
void gc_time_InitWeekDay(gc_time *);
//void gc_time_NextDay(gc_time *);
void gc_time_NormalizeValues(gc_time *);
//void gc_time_PreviousDay(gc_time *);
void gc_time_SetFromJulian(gc_time *, JULIANDATE jd);
void gc_time_sub_days(gc_time *, int);
void gc_time_Today(gc_time *);


typedef struct _gc_daytime
{
	int hour;
	int minute;
	int sec;
	int mili;
}
gc_daytime;

double gc_daytime_GetDayTime(gc_daytime);
BOOL gc_daytime_lt(gc_daytime,gc_daytime dt);
BOOL gc_daytime_gt(gc_daytime,gc_daytime dt);
BOOL gc_daytime_ge(gc_daytime,gc_daytime dt);
BOOL gc_daytime_le(gc_daytime,gc_daytime dt);
void gc_daytime_SetValue(gc_daytime *,int i);
void gc_daytime_SetDayTime(gc_daytime *,double d);
void gc_daytime_SetDegTime(gc_daytime *,double);
void gc_daytime_add_minutes(gc_daytime *,int mn);
void gc_daytime_sub_minutes(gc_daytime *,int mn);
gc_daytime gc_daytime_init(int a);
gc_daytime gc_daytime_initFromDegTime(double d);

typedef struct _gc_moon 
{
	/*// illumination (synodic) phase
	 double ip;
	 // age of moon
	 int age;
	 // distance from anomalistic phase
	 double di;*/
	// latitude from nodal (draconic) phase
	double latitude_deg;
	// longitude from sidereal motion
	double longitude_deg;
	double radius; //(* lambda, beta, R *)
	double rektaszension, declination;  //(* alpha, delta *)
	double parallax;
	double elevation, azimuth;//          (* h, A *)
} gc_moon;


typedef struct _gc_earth
{
	int dst;
	// terrestrial longitude of observation
	double longitude_deg;
	
	// terrestrial latitude of observation
	double latitude_deg;
	
	// time zone (hours)
	double tzone;
	
	// observated event
	// 0 - center of the sun
	// 1 - civil twilight
	// 2 - nautical twilight
	// 3 - astronomical twilight
	int obs;
}
gc_earth;

void gc_earth_init(gc_earth *);


typedef struct _gc_sun
{
	double length_deg;
	double arunodaya_deg;
	double sunrise_deg;
	double sunset_deg;
	
	double declination_deg;
	double longitude_deg;
	double longitude_set_deg;
	double longitude_arun_deg;
	double right_asc_deg;
	
	// time of arunodaya - 96 mins before sunrise
	gc_daytime arunodaya;
	// time of sunrise
	gc_daytime rise;
	// time of noon
	gc_daytime noon;
	// time of sunset
	gc_daytime set;
	// length of the day
	gc_daytime length;
}
gc_sun;


typedef struct _gc_astro
{
	// date of Julian epoch
	JULIANDATE jdate;
	// sun
	gc_sun sun;
	// moon
	gc_moon moon;
	// year of Gaurabda epoch
	int nGaurabdaYear;
	// value of ayanamsa for this date
	double msAyanamsa;
	// sign of zodiac
	int nRasi;
	// tithi #
	int nTithi;
	// tithi at arunodaya
	int nTithiArunodaya;
	// tithi at sunset
	int nTithiSunset;
	// tithi elaps.
	double nTithiElapse;
	// paksa
	int nPaksa;
	// yoga
	int nYoga;
	// yoga elaps.
	double nYogaElapse;
	// naksatra
	int nNaksatra;
	// naksatra elaps.
	double nNaksatraElapse;
	// masa
	int nMasa;
	// distance of moon and sun in degrees
	double msDistance;
} gc_astro;


#endif

