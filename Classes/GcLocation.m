//
//  GcLocation.m
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GcLocation.h"
#import "gc_func.h"
#import "GCGregorianTime.h"

@implementation GcLocation

@synthesize country;
@synthesize city;
@synthesize longitude;
@synthesize latitude;
//@synthesize tzone;
//@synthesize dstData;
//@synthesize timezoneName;
//@synthesize bias;
@synthesize start_month;
@synthesize start_monthday;
@synthesize start_weekday;
@synthesize start_order;
@synthesize end_month;
@synthesize end_monthday;
@synthesize end_weekday;
@synthesize end_order;
@synthesize timeZone;

-(id)init
{
	if ((self = [super init]) != nil)
	{
		gregCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		dateComponents = [[NSDateComponents alloc] init];
		//[dateComponents setCalendar:gregCalendar];
		[self empty];
	}
	
	return self;
}

-(void)dealloc
{
	[self empty];
}

-(void)empty
{
	self.country = @"Slovakia";
	self.city = @"Bratislava";
	self.latitude = 48.12;
	self.longitude = 17.08;
	self.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Bratislava"];
	//self.tzone = 1.0;
	//self.timezoneName = @"+01:00 Europe/Bratislava";
	//self.bias = 1.0;
	//self.dstData = 0;
	self.start_monthday = 0;
	self.start_month = 3;
	self.start_weekday = 0;
	self.start_order = 5;
	self.end_month = 10;
	self.end_monthday = 0;
	self.end_weekday = 0;
	self.end_order = 5;
}

-(gc_earth)getEarth
{
	gc_earth e;
	
	e.latitude_deg = self.latitude; 
	e.longitude_deg = self.longitude;
	e.tzone = [self timeZoneOffset];
	e.obs = 0;
	e.dst = 0;
	
	return e;
}

//
// returns standard timezone offset in minutes
//
-(double)timeZoneOffset
{
	NSInteger secs = [timeZone secondsFromGMT];
	if ([timeZone isDaylightSavingTime])
	{
		return secs/3600.0 - [timeZone daylightSavingTimeOffset]/3600.0;
	}
	
	return secs/3600.0;
}

//
//
//

-(NSString *)fullName
{
	if ([self.country length] > 0)
	{
	return [NSString stringWithFormat:@"%@ [%@] %@ %@", 
			self.city, self.country,
			[self textLatitude], [self textLongitude]];
	}
	else 
	{
		return [NSString stringWithFormat:@"%@, %@ %@", 
				self.city,
				[self textLatitude], [self textLongitude]];
	}

}

-(NSString *)textLatitude
{
	double d = self.latitude;
	int a0, a1;
	char c0;
	
	if (d < 0.0) {
		c0 = 'S';
		d = -d;
	}
	else {
		c0 = 'N';
	}
	a0 = (int)(floor(d));
	a1 = (int)((d - (double)(a0))*60 + 0.5);
	
	return [NSString stringWithFormat:@"%02d%c%02d", a0, c0, a1];
}

-(NSString *)textLongitude
{
	int a0, a1;
	char c0;
	double d = self.longitude;
	
	if (d < 0.0) {
		c0 = 'W';
		d = -d;
	}
	else {
		c0 = 'E';
	}
	a0 = (int)(floor(d));
	a1 = (int)((d - (double)(a0))*60 + 0.5);
	
	return [NSString stringWithFormat:@"%03d%c%02d", a0, c0, a1];
}

-(NSString *)textTimezone
{
	int a4, a5;
	int sig;
	double d = [self timeZoneOffset];
	
	if (d < 0.0)
	{
		sig = -1;
		d = -d;
	}
	else
	{
		sig = 1;
	}
	
	a4 = (int)d;
	a5 = (int)((d - a4)*60 + 0.5);
	
	return [NSString stringWithFormat:@"%c%d:%02d", (sig < 0 ? '-' : '+'), a4, a5];
}

// n - is order number of given day
// x - is number of day in week (0-sunday, 1-monday, ..6-saturday)
// if x >= 5, then is calculated whether day is after last x-day

-(BOOL)isMonthsDay:(gc_time)vc ofWeekInMonth:(int)n ofDayInWeek:(int)x
{
	int xx[7] = {1, 7, 6, 5, 4, 3, 2};
	
	int fdm, fxdm, nxdm, max;
	
	// prvy den mesiaca
	fdm = xx[ (7 + vc.day - vc.dayOfWeek) % 7 ];
	//NSLog(@"input-of-week:%d, input-day-in-week:%d\nprvy den mesiaca: %d\n"
	//	  , n, x, fdm);
	
	// 1. x-day v mesiaci ma datum
	fxdm = xx[ (fdm - x + 7) % 7 ];
	//NSLog(@"prvy x-day mesiaca: %d\n", fdm);
	
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
	//NSLog(@"n-ty x-day mesiaca: %d\n", fdm);
	
	return (vc.day >= nxdm) ? YES : NO;
}

-(NSDate *)dateFromGcTime:(GCGregorianTime *)vc
{
	[dateComponents setDay:vc.day];
	[dateComponents setMonth:vc.month];
	[dateComponents setYear:vc.year];
    [dateComponents setHour:12];
	return [gregCalendar dateFromComponents:dateComponents];
}

-(BOOL)isDaylightTime:(GCGregorianTime *)vc
{
	return [self.timeZone isDaylightSavingTimeForDate:[self dateFromGcTime:vc]];
}

//
// return value from range 0.0 - 1.0 (can be added to gc_time.shour)
//
-(double)daytimeBiasForDate:(GCGregorianTime *)date
{
	return [self.timeZone daylightSavingTimeOffsetForDate:[self dateFromGcTime:date]] / 86400.0;
	//return ([self isDaylightTime:date] ? self.bias/24.0 : 0.0);
}

-(NSString *)timeNameForDate:(GCGregorianTime *)date
{
	return [timeZone abbreviationForDate:[self dateFromGcTime:date]];
}

-(NSString *)timeZoneNameForDate:(GCGregorianTime *)gt
{
    return [NSString stringWithFormat:@"%@ (%@)", [self.timeZone name],
            [self.timeZone abbreviationForDate:[gt getNSDate]]];
}

-(ga_time)getGaurabdaDate:(GCGregorianTime *)vc
{
	gc_earth earth = [self getEarth];
	return VCTIMEtoVATIME(vc, earth);
}

-(GCGregorianTime *)getGregorianDate:(ga_time)va
{
	gc_earth earth = [self getEarth];
	return VATIMEtoVCTIME(va, earth);
}

// returns in pResult
//  0 - not recognized
//  1 - argument is latitude
//  2 - argument is longitude

-(double)scanEarthPos:(NSString *)str result:(int *)pResult
{
	double l = 0.0;
	double sig = 1.0;
	double coma = 10.0;
	BOOL after_coma = NO;
	BOOL is_deg = NO;
	BOOL bNorth = NO;
	
	const char * s = [str UTF8String];
	
	if (s == nil)
	{
		if (pResult) *pResult = 0;
		return 0.0;
	}
	
	while(*s)
	{
		switch(*s)
		{
			case '0': case '1':
			case '2': case '3': case '4': case '5':
			case '6': case '7': case '8': case '9':
				if (after_coma)
				{
					if (is_deg)
					{
						l += (*s - '0') * 5.0 / (coma * 3.0);
					}
					else
					{
						l += (*s - '0') / coma;
					}
					coma *= 10.0;
				}
				else
				{
					l = l*10.0 + (*s - '0');
				}
				break;
			case 'n': case 'N':
				after_coma = true;
				is_deg = true;
				sig = 1.0;
				bNorth = true;
				break;
			case 's': case 'S':
				bNorth = true;
				after_coma = true;
				is_deg = true;
				sig = -1.0;
				break;
			case 'e': case 'E':
				bNorth = false;
				after_coma = true;
				is_deg = true;
				sig = 1.0;
				break;
			case 'w': case 'W':
				bNorth = false;
				after_coma = true;
				is_deg = true;
				sig = -1.0;
				break;
			case '.':
				after_coma = true;
				is_deg = false;
				break;
			case '-':
				sig = -1.0;
				break;
			case '+':
				sig = 1.0;
				break;
			default:
				if (pResult)
					*pResult = 0;
				return 0.0;
		}
		s++;
	}
	
	if (pResult)
		*pResult = (bNorth ? 1 : 2);

	if (bNorth)
		self.latitude = l * sig;
	else
		self.longitude = l*sig;
	
	return l * sig;
}


@end
