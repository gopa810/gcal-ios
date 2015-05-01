//
//  GCGregorianTime.m
//  GCAL
//
//  Created by Peter Kollath on 28/02/15.
//
//

#import "GCGregorianTime.h"
#import "GCStrings.h"

@implementation GCGregorianTime


-(id)init
{
    self = [super init];
    if (self) {
        self.day = 0;
        self.dayOfWeek = -1;
        self.month = 0;
        self.year = 0;
        self.shour = 0.0;
        self.tzone = 0.0;
    }
    return self;
}

-(id)copy
{
    GCGregorianTime * gc = [GCGregorianTime new];
    
    [gc copyParamsFrom:self];
    
    return gc;
}

-(id)copyWithZone:(NSZone *)zone
{
    GCGregorianTime * gc = [[GCGregorianTime allocWithZone:zone] init];
    
    [gc copyParamsFrom:self];
    
    return gc;
}

-(void)copyParamsFrom:(GCGregorianTime *)gc
{
    self.year = gc.year;
    self.month = gc.month;
    self.day = gc.day;
    self.dayOfWeek = gc.dayOfWeek;
    self.shour = gc.shour;
    self.tzone = gc.tzone;
}

+(GCGregorianTime *)today
{
    GCGregorianTime * today = [GCGregorianTime new];
    
    time_t st;
    
    time(&st);
    struct tm * pt;
    
    pt = localtime(&st);
    
    today.day = pt->tm_mday;
    today.month = pt->tm_mon + 1;
    today.year = pt->tm_year + 1900;
    today.shour = 0.5;
    today.tzone = 0.0;
    
    
    return today;
}

#pragma mark -
#pragma mark JULIAN DAY

-(int)getJulianInteger
{
    int yy = self.year - (int)((12 - self.month) / 10);
    int mm = self.month + 9;
    
    if (mm >= 12)
        mm -= 12;
    
    int k1, k2, k3;
    int j;
    
    k1 = (int)(floor(365.25 * (yy + 4712)));
    k2 = (int)(floor(30.6 * mm + 0.5));
    k3 = (int)(floor(floor((yy/100)+49)*.75))-38;
    j = k1 + k2 + self.day + 59;
    if (j > 2299160)
        j -= k3;
    
    return j;
}

-(double)julian
{
    return (double)[self getJulianInteger] - 0.5 + self.shour;
}

-(double)julianComplete
{
    return (double)[self getJulianInteger] - 0.5 + self.shour - self.tzone/24.0;
}

-(void)setJulian:(double)jd
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
    self.day = (int) floor(B - D - floor(30.6001 * E) + f);
    self.month = (int)((E < 14) ? E - 1 : E - 13);
    self.year = (int)((self.month > 2) ? C - 4716 : C - 4715);
    self.tzone = 0.0;
    self.shour = modf(jd + 0.5, &z);
    self.dayOfWeek = -1;
}

#pragma mark -
#pragma mark DAY OF WEEK

-(int)dayOfWeek
{
    if (self->_dayOfWeek < 0)
    {
        self->_dayOfWeek = ([self getJulianInteger] + 1) % 7;
    }
    return self->_dayOfWeek;
}

-(void)setDayOfWeek:(int)dow
{
    self->_dayOfWeek = dow;
}

#pragma mark -
#pragma mark STRINGS

-(NSString *)relativeTodayString
{
    GCGregorianTime * today = [GCGregorianTime today];
    
    int n = (int)([today getJulianInteger] - [self getJulianInteger]);
    
    if (n == 1)
        return @"[Yesterday]";
    else if (n == 0)
        return @"[Today]";
    else if (n == -1)
        return @"[Tomorrow]";
    return @"";
}

-(NSString *)longDateString
{
    return [NSString stringWithFormat:@"%d %@ %d", self.day, [[GCStrings shared] GetMonthAbr:self.month], self.year];
    
}

-(NSString *)shortDateString
{
    return [NSString stringWithFormat:@"%d %@", self.day, [[GCStrings shared] GetMonthAbr:self.month]];
}

#pragma mark -

-(NSDate *)getNSDate
{
    NSDateComponents * dateComponents = [NSDateComponents new];
    NSCalendar * gregCalendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
    [dateComponents setDay:self.day];
    [dateComponents setMonth:self.month];
    [dateComponents setYear:self.year];
    return [gregCalendar dateFromComponents:dateComponents];
}

-(GCGregorianTime *)previousDay
{
    GCGregorianTime * day = [self copyWithZone:nil];
    
    day.day--;
    day.dayOfWeek = (day.dayOfWeek + 6) % 7;
    
    if (day.day < 1)
    {
        day.month--;
        if (day.month < 1)
        {
            day.month = 12;
            day.year--;
        }
        day.day = [GCGregorianTime getMaxDaysInYear:day.year month:day.month];
    }
    
    return day;
}

-(GCGregorianTime *)nextDay
{
    GCGregorianTime * day = [self copyWithZone:nil];
    
    day.day++;
    day.dayOfWeek = (day.dayOfWeek + 1) % 7;
    
    if (day.day > [GCGregorianTime getMaxDaysInYear:day.year month:day.month])
    {
        day.day = 1;
        day.month ++;
    }
    
    if (day.month > 12)
    {
        day.month = 1;
        day.year++;
    }
    
    return day;
}

-(GCGregorianTime *)addDays:(int)days
{
    GCGregorianTime * cd = [self copy];
    if (days > 0)
    {
        while(days > 0)
        {
            cd = [cd nextDay];
            days--;
        }
    }
    else
    {
        while(days < 0)
        {
            cd = [cd previousDay];
            days++;
        }
    }
    
    return cd;
}


+(BOOL)isLeapYear:(int)year
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

+(int)getMaxDaysInYear:(int)year month:(int)month
{
    int m_months_ovr[13] = { 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    int m_months[13] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    
    if ([GCGregorianTime isLeapYear:year])
        return m_months_ovr[month];
    else
        return m_months[month];
}


-(GCGregorianTime *)normalize
{
    if (self.shour < 0.0)
    {
        self.day--;
        self.shour += 1.0;
        //NSLog(@"nv: 2\n");
    }
    if (self.shour >= 1.0)
    {
        self.shour -= 1.0;
        //NSLog(@"nv: 3 d=%d\n", *d1);
        self.day++;
        //NSLog(@"nv: 3 d=%d\n", *d1);
    }
    if (self.day < 1)
    {
        //NSLog(@"nv: 4\n");
        self.month--;
        if (self.month < 1)
        {
            self.month = 12;
            self.year--;
        }
        self.day = [GCGregorianTime getMaxDaysInYear:self.year month:self.month];
    }
    else if (self.day > [GCGregorianTime getMaxDaysInYear:self.year month:self.month])
    {
        //NSLog(@"nv: 5\n");
        self.month++;
        if (self.month > 12)
        {
            self.month = 1;
            self.year++;
        }
        self.day = 1;
    }

    return self;
}

-(GCGregorianTime *)addDayHours:(double)dhours
{
    self.shour += dhours;
    [self normalize];
    return self;
}

-(NSString *)shortTimeString
{
    double h1, m1;
    m1 = modf(self.shour, &h1);
    m1 += 0.5;
    return [NSString stringWithFormat:@"%02d:%02d", (int)(h1), (int)(m1*60)];
}

-(NSString *)shortDowString
{
    NSString * str = [[GCStrings shared] string:[self dayOfWeek]];
    return [str substringToIndex:2];
}

-(NSString *)longDowString
{
    return [[GCStrings shared] string:[self dayOfWeek]];
}

-(GCGregorianTime *)timeByAddingMinutes:(double)minutes
{
    GCGregorianTime * gc = [self copy];
    
    gc.shour += minutes / 1440.0;
    [gc normalize];

    return gc;
}

@end



