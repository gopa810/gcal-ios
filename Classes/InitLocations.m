
#import <UIKit/UIKit.h>
#import "LGroup.h"
#import "LCity.h"
#import <CoreData/CoreData.h>

#pragma mark === declarations of functions ===

void ADD_COUNTRY(NSManagedObjectContext * ctx, NSString *code, NSString *title, NSString *continent);
void ADD_ADMIN1(NSManagedObjectContext * ctx, NSString *code, NSString * title);
//void ADD_ADMIN2(NSManagedObjectContext * ctx, NSString *code, NSString * title);
void ADD_CITY(NSManagedObjectContext * ctx, NSString * title, NSString * latitude, NSString * longitude,
				NSString * country, NSString * admin1, NSString * admin2,
				NSString * tzone);
void ADD_CONTINENT(NSManagedObjectContext * ctx, NSString * code, NSString * title);
/*void ADD_TIMEZONE(NSManagedObjectContext * ctx, NSString * title, NSString * offset, NSString * bias,
				  NSString * sm, NSString * smd, NSString * smw, NSString * swd,
				  NSString * em, NSString * emd, NSString * emw, NSString * ewd);*/

void ADD_COUNTRIES(NSManagedObjectContext * ctx, NSString *);
void ADD_ADMIN1CODES(NSManagedObjectContext * ctx, NSString *);
//void ADD_ADMIN2CODES(NSManagedObjectContext * ctx, NSString *);
void ADD_CITIES(NSManagedObjectContext * ctx, NSString *);
void ADD_CONTINENTS(NSManagedObjectContext * ctx);
//void ADD_TIMEZONES(NSManagedObjectContext *ctx, NSString *);

#pragma mark === main adding function ===

void ADD_ALL_LOCATION_ITEMS(NSManagedObjectContext * ctx)
{	
	// adding
	ADD_COUNTRIES(ctx,   @"/Users/gopalapriya/Projects/GCal Software/Locations Data Prepare/tsv_files/tsv_countries.txt");
	//ADD_ADMIN2CODES(ctx, @"/Users/gopalapriya/Projects/GCal Software/Locations Data Prepare/csv_admin2.txt");
	ADD_ADMIN1CODES(ctx, @"/Users/gopalapriya/Projects/GCal Software/Locations Data Prepare/tsv_files/tsv_admin1.txt");
	ADD_CITIES(ctx,      @"/Users/gopalapriya/Projects/GCal Software/Locations Data Prepare/tsv_files/tsv_cities.txt");
	ADD_CONTINENTS(ctx);
	//ADD_TIMEZONES(ctx,   @"/Users/gopalapriya/Projects/GCal Software/Locations Data Prepare/tzones.csv");
}

#pragma mark === groups adding functions ===

void ADD_COUNTRIES(NSManagedObjectContext * ctx, NSString * fileName)
{	
	NSString * strFile = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:NULL];
	NSArray * arr = [strFile componentsSeparatedByString:@"\n"];
	for (NSString * tu in arr)
	{
		NSString * line =  [tu stringByReplacingOccurrencesOfString:@"\r" withString:@""];
		NSArray * comps = [line componentsSeparatedByString:@"\t"];
		if ([comps count] == 3)
		{
			ADD_COUNTRY(ctx, [comps objectAtIndex:0], [comps objectAtIndex:1], [comps objectAtIndex:2]);
		}
	}
}

void ADD_ADMIN1CODES(NSManagedObjectContext * ctx, NSString * fileName)
{
	NSString * strFile = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:NULL];
	NSArray * arr = [strFile componentsSeparatedByString:@"\n"];
	for (NSString * tu in arr)
	{
		NSString * line =  [tu stringByReplacingOccurrencesOfString:@"\r" withString:@""];
		NSArray * comps = [line componentsSeparatedByString:@"\t"];
		if ([comps count] == 2)
		{
			ADD_ADMIN1(ctx, [comps objectAtIndex:0], [comps objectAtIndex:1]);
		}
	}
}

void ADD_CONTINENTS(NSManagedObjectContext * root)
{	
	ADD_CONTINENT(root, @"AF", @"Africa");
	ADD_CONTINENT(root, @"AS", @"Asia");
	ADD_CONTINENT(root, @"EU", @"Europe");
	ADD_CONTINENT(root, @"NA", @"North America");
	ADD_CONTINENT(root, @"OC", @"Australia and Oceania");
	ADD_CONTINENT(root, @"SA", @"South America");
	ADD_CONTINENT(root, @"AN", @"Antarctica");
}

void ADD_CITIES(NSManagedObjectContext * ctx, NSString * fileName)
{
	NSString * strFile = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:NULL];
	NSArray * arr = [strFile componentsSeparatedByString:@"\n"];
	for (NSString * tu in arr)
	{
		NSString * line =  [tu stringByReplacingOccurrencesOfString:@"\r" withString:@""];
		NSArray * comps = [line componentsSeparatedByString:@"\t"];
		if ([comps count] == 7)
		{
			ADD_CITY(ctx, [comps objectAtIndex:0], [comps objectAtIndex:1],
					 [comps objectAtIndex:2], [comps objectAtIndex:3], [comps objectAtIndex:4], 
					 [comps objectAtIndex:5], [comps objectAtIndex:6]);
		}
	}
}

/*void ADD_ADMIN2CODES(NSManagedObjectContext * ctx, NSString * fileName)
{
	NSString * strFile = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:NULL];
	NSArray * arr = [strFile componentsSeparatedByString:@"\n"];
	for (NSString * tu in arr)
	{
		NSString * line =  [tu stringByReplacingOccurrencesOfString:@"\r" withString:@""];
		NSArray * comps = [line componentsSeparatedByString:@"\t"];
		if ([comps count] == 2)
		{
			ADD_ADMIN2(ctx, [comps objectAtIndex:0], [comps objectAtIndex:1]);
		}
	}
	[strFile release];
}*/

/*void ADD_TIMEZONES(NSManagedObjectContext * ctx, NSString * fileName)
{
	NSString * strFile = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:NULL];
	NSArray * arr = [strFile componentsSeparatedByString:@"\n"];
	for (NSString * tu in arr)
	{
		NSString * line =  [tu stringByReplacingOccurrencesOfString:@"\r" withString:@""];
		NSArray * comps = [line componentsSeparatedByString:@"\t"];
		if ([comps count] == 11)
		{
			ADD_TIMEZONE(ctx, (NSString *)[comps objectAtIndex:0], (NSString *)[comps objectAtIndex:1],
						 (NSString *)[comps objectAtIndex:2], (NSString *)[comps objectAtIndex:3],
						 (NSString *)[comps objectAtIndex:4], (NSString *)[comps objectAtIndex:5],
						 (NSString *)[comps objectAtIndex:6], (NSString *)[comps objectAtIndex:7], 
						 (NSString *)[comps objectAtIndex:8], (NSString *)[comps objectAtIndex:9],
						 (NSString *)[comps objectAtIndex:10]);
		}
	}
	[strFile release];
}*/

#pragma mark === add individual items ===

void ADD_COUNTRY(NSManagedObjectContext * ctx, NSString *code, NSString *title, 
				NSString *continent)
{
	NSManagedObject * con = [NSEntityDescription insertNewObjectForEntityForName:@"LGroup"
														  inManagedObjectContext:ctx];
	//NSLog(@"ManagedObject: %@\n", con );
	[con setValue:title forKey:@"title"];
	[con setValue:code forKey:@"code"];
	[con setValue:[NSString stringWithFormat:@"CONT=%@",continent] forKey:@"parentCode"];
	//NSLog(@"ManagedObject: %@\n", con );
}

void ADD_ADMIN1(NSManagedObjectContext * ctx, NSString *code, NSString * title)
{
	NSArray * comp = [code componentsSeparatedByString:@"."];

	if ([comp count] == 2)
	{
		NSManagedObject * con = [NSEntityDescription insertNewObjectForEntityForName:@"LGroup"
															  inManagedObjectContext:ctx];
		[con setValue:title forKey:@"title"];
		[con setValue:code forKey:@"code"];
		[con setValue:[comp objectAtIndex:0] forKey:@"parentCode"];
	}
}

/*void ADD_ADMIN2(NSManagedObjectContext * ctx, NSString *code, NSString * title)
{
	NSArray * comp = [code componentsSeparatedByString:@"."];
	
	if ([comp count] == 3)
	{
		NSManagedObject * con = [NSEntityDescription insertNewObjectForEntityForName:@"LGroup"
															  inManagedObjectContext:ctx];
		[con setValue:title forKey:@"title"];
		[con setValue:code forKey:@"code"];
		[con setValue:[NSString stringWithFormat:@"%@.%@",[comp objectAtIndex:0],[comp objectAtIndex:1]]
			   forKey:@"parentCode"];
	}
}*/


void ADD_CITY(NSManagedObjectContext * ctx, NSString * title, NSString * latitude, NSString * longitude,
			  NSString * country, NSString * admin1, NSString * admin2,
			  NSString * tzone)
{
	NSString * parent = nil;
	if (admin1 == nil || [admin1 length] < 1)
	{
		parent = country;
	}
	else //if (admin2 == nil || [admin2 length] < 1)
	{
		parent = [NSString stringWithFormat:@"%@.%@", country, admin1];
	}
	/*else 
	{
		parent = [NSString stringWithFormat:@"%@.%@.%@", country, admin1, admin2];
	}*/

	NSManagedObject * con = [NSEntityDescription insertNewObjectForEntityForName:@"LCity"
														  inManagedObjectContext:ctx];
	[con setValue:title forKey:@"title"];
	[con setValue:[NSNumber numberWithDouble:[latitude doubleValue]]  forKey:@"latitude"];
	[con setValue:[NSNumber numberWithDouble:[longitude doubleValue]]  forKey:@"longitude"];
	[con setValue:tzone forKey:@"tzone"];
	[con setValue:parent forKey:@"parentCode"];

}

void ADD_CONTINENT(NSManagedObjectContext * ctx, NSString * code, NSString * title)
{
	NSManagedObject * con = [NSEntityDescription insertNewObjectForEntityForName:@"LGroup"
												 inManagedObjectContext:ctx];
	[con setValue:title forKey:@"title"];
	[con setValue:[NSString stringWithFormat:@"CONT=%@",code] forKey:@"code"];
	[con setValue:@"ROOT" forKey:@"parentCode"];
	//NSLog(@"ManagedObject: %@\n", con );
	
}

/*void ADD_TIMEZONE(NSManagedObjectContext * ctx, NSString * title, NSString * offset, NSString * bias,
				  NSString * sm, NSString * smd, NSString * smw, NSString * swd,
				  NSString * em, NSString * emd, NSString * emw, NSString * ewd)
{
	NSManagedObject * con = [NSEntityDescription insertNewObjectForEntityForName:@"LTimezone"
														  inManagedObjectContext:ctx];
	[con setValue:title forKey:@"title"];
	[con setValue:[NSNumber numberWithInteger:[offset integerValue]] forKey:@"offset"];
	[con setValue:[NSNumber numberWithInteger:[bias integerValue]] forKey:@"bias"];
	[con setValue:[NSNumber numberWithInteger:[sm  integerValue]]  forKey:@"start_month"];
	[con setValue:[NSNumber numberWithInteger:[smd integerValue]]  forKey:@"start_month_day"];
	[con setValue:[NSNumber numberWithInteger:[smw integerValue]]  forKey:@"start_month_week"];
	[con setValue:[NSNumber numberWithInteger:[swd integerValue]]  forKey:@"start_week_day"];
	[con setValue:[NSNumber numberWithInteger:[em  integerValue]]  forKey:@"end_month"];
	[con setValue:[NSNumber numberWithInteger:[emd integerValue]]  forKey:@"end_month_day"];
	[con setValue:[NSNumber numberWithInteger:[emw integerValue]]  forKey:@"end_month_week"];
	[con setValue:[NSNumber numberWithInteger:[ewd integerValue]]  forKey:@"end_week_day"];
}
*/