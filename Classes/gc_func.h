#import "gc_const.h"
#import "gc_dtypes.h"


@class GcDay;

int AvcComboMasaToMasa(int nComboMasa);
int AvcMasaToComboMasa(int nMasa);
int ctoi(char c);

void gc_time_add_hours(gc_time * p, double val);
double gc_time_GetJulianDay(gc_time);
double GetJulianDay(int, int, int);
int GetGregorianYearLength(BOOL bOverlapped);
int GetGregorianDay(BOOL bOverlapped, int nDayIndex);
int GetGregorianMonth(BOOL bOverlapped, int nDayIndex);
void GetNextDay(gc_time * day);
void GetPrevDay(gc_time * day);
int  GetMonthMaxDays(int year, int month);
BOOL IsLeapYear(int year);
int GetAyanamsaType();
int SetAyanamsaType(int i);
NSString * GetAyanamsaName(int nType);

//double GetSunLongitude(JULIANDATE jDate);

double GetSunLongitude(gc_time  date);
void SunPosition(gc_time  vct, gc_earth ed, gc_sun * sun, DAYHOURS DayHours);
void SunCalc(gc_time , gc_earth, gc_sun * );
double GetAyanamsa(JULIANDATE);
int GetRasi(double SunLongitude, double Ayanamsa);
gc_time GetNextSankranti( gc_time  startDate, int * zodiac);
void MoonCalc(JULIANDATE, gc_moon * , gc_earth);
void calc_horizontal(gc_moon * , JULIANDATE, double, double);
DAYHOURS GetTithiTimes(gc_earth, gc_time  vc, DAYHOURS * titBeg, DAYHOURS * titEnd, DAYHOURS sunRise);
double GetPrevConjunction(gc_time , gc_time * , BOOL, gc_earth);
double GetNextConjunction(gc_time , gc_time * , BOOL, gc_earth);
gc_astro DayCalc(gc_time date, gc_earth earth);
gc_astro MasaCalc(gc_time date, gc_astro day, gc_earth earth);
gc_time  GetFirstDayOfYear(gc_earth,int);
gc_time  GetFirstDayOfMasa(gc_earth earth, int GYear, int nMasa);
int GetNextNaksatra(gc_earth ed, gc_time  startDate, gc_time * nextDate);
int GetPrevNaksatra(gc_earth ed, gc_time  startDate, gc_time * prevDate);
int GetPrevTithiStart(gc_earth ed, gc_time  startDate, gc_time * nextDate);
int GetNextTithiStart(gc_earth ed, gc_time  startDate, gc_time * nextDate);
double DayCalcEx(gc_time  date, gc_earth earth, int nType);
gc_time  CalcTithiEnd(int nGYear, int nMasa, int nPaksa, int nTithi, gc_earth, gc_time * );
gc_time  CalcTithiEndEx(gc_time  vcStart, int GYear, int nMasa, int nPaksa, int nTithi, gc_earth earth, gc_time *  endTithi);
gc_time  CalcTithiDate(int nGYear, int nMasa, int nPaksa, int nTithi, gc_earth earth);
int	GetGaurabdaYear(gc_time  vc, gc_earth earth);
void VATIMEtoVCTIME (ga_time va, gc_time * vc, gc_earth earth);
void VCTIMEtoVATIME(gc_time  vc, ga_time * va, gc_earth earth);
BOOL is_daylight_time(gc_time  vc, NSUInteger nValue);
int GetSankrantiType();
int CalculateEParana(GcDay * s, GcDay * t, double *begin, double * end, gc_earth earth);
void CalcMoonTimes(gc_earth e, gc_time vc, double biasHours, gc_daytime * rise, gc_daytime * set);
BOOL IsFestivalDay(GcDay * yesterday, GcDay * today, int nTithi);
