#import "gc_const.h"
#import "gc_dtypes.h"


@class GCCalendarDay;
@class GCGregorianTime;

int AvcComboMasaToMasa(int nComboMasa);
int AvcMasaToComboMasa(int nMasa);
int ctoi(char c);

void gc_time_add_hours(gc_time * p, double val);
double gc_time_GetJulianDay(gc_time);
double GetJulianDay(int, int, int);
double GetJulianDayInteger(int year, int month, int day);
int GetGregorianYearLength(BOOL bOverlapped);
int GetGregorianDay(BOOL bOverlapped, int nDayIndex);
int GetGregorianMonth(BOOL bOverlapped, int nDayIndex);
void GetNextDay(gc_time * day);
void GetPrevDay(gc_time * day);
int  GetMonthMaxDays(int year, int month);
BOOL IsLeapYear(int year);
int GetAyanamsaType(void);
int SetAyanamsaType(int i);
NSString * GetAyanamsaName(int nType);

//double GetSunLongitude(JULIANDATE jDate);

double GetSunLongitude(GCGregorianTime * date);
void SunPosition(GCGregorianTime * vct, gc_earth ed, gc_sun * sun, DAYHOURS DayHours);
void SunCalc(GCGregorianTime * , gc_earth, gc_sun * );
double GetAyanamsa(JULIANDATE);
int GetRasi(double SunLongitude, double Ayanamsa);
GCGregorianTime * GetNextSankranti( GCGregorianTime * startDate, int * zodiac);
void MoonCalc(JULIANDATE, gc_moon * , gc_earth);
void calc_horizontal(gc_moon * , JULIANDATE, double, double);
DAYHOURS GetTithiTimes(gc_earth, GCGregorianTime * vc, DAYHOURS * titBeg, DAYHOURS * titEnd, DAYHOURS sunRise);
double GetPrevConjunction(GCGregorianTime * , GCGregorianTime ** , BOOL, gc_earth);
double GetNextConjunction(GCGregorianTime *, GCGregorianTime ** , BOOL, gc_earth);
gc_astro DayCalc(GCGregorianTime * date, gc_earth earth);
gc_astro MasaCalc(GCGregorianTime * date, gc_astro day, gc_earth earth);
GCGregorianTime *  GetFirstDayOfYear(gc_earth,int);
GCGregorianTime *  GetFirstDayOfMasa(gc_earth earth, int GYear, int nMasa);
int GetNextNaksatra(gc_earth ed, GCGregorianTime * startDate, GCGregorianTime ** nextDate);
int GetPrevNaksatra(gc_earth ed, GCGregorianTime *  startDate, GCGregorianTime ** prevDate);
int GetPrevTithiStart(gc_earth ed, GCGregorianTime * startDate, GCGregorianTime ** nextDate);
int GetNextTithiStart(gc_earth ed, GCGregorianTime * startDate, GCGregorianTime ** nextDate);
double DayCalcEx(GCGregorianTime * date, gc_earth earth, int nType);
GCGregorianTime *  CalcTithiEnd(int nGYear, int nMasa, int nPaksa, int nTithi, gc_earth, GCGregorianTime ** );
GCGregorianTime *  CalcTithiEndEx(GCGregorianTime * vcStart, int GYear, int nMasa, int nPaksa, int nTithi, gc_earth earth, GCGregorianTime **  endTithi);
GCGregorianTime *  CalcTithiDate(int nGYear, int nMasa, int nPaksa, int nTithi, gc_earth earth);
int	GetGaurabdaYear(GCGregorianTime * vc, gc_earth earth);
GCGregorianTime * VATIMEtoVCTIME (ga_time va, gc_earth earth);
ga_time VCTIMEtoVATIME(GCGregorianTime * vc, gc_earth earth);
BOOL is_daylight_time(GCGregorianTime * vc, NSUInteger nValue);
int GetSankrantiType(void);
int CalculateEParana(GCCalendarDay * s, GCCalendarDay * t, gc_earth earth);
void CalcMoonTimes(gc_earth e, GCGregorianTime * vc, double biasHours, gc_daytime * rise, gc_daytime * set);
BOOL IsFestivalDay(GCCalendarDay * yesterday, GCCalendarDay * today, int nTithi);
