//
//  GpsViewController.m
//  GCAL
//
//  Created by Peter Kollath on 8/18/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "GpsViewController.h"
#import "BalaCalAppDelegate.h"
#import "MainViewController.h"
#import "GcLocation.h"

@implementation GpsViewController

@synthesize locationManager;
@synthesize myLocation;
@synthesize labelLatitude;
@synthesize labelLongitude;
@synthesize labelCity;
@synthesize button;
@synthesize working;
@synthesize foundCity;
@synthesize foundCountry;
@synthesize foundTimeZone;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	startButtonStatus = 0;
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;

    // this is new in iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.working.hidden = YES;
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (![CLLocationManager locationServicesEnabled])
    {
        self.labelCity.text = @"Location services are not enabled!";
        self.labelCity.hidden = NO;
    }
    else
    {
        self.labelCity.text = @"Location services are enabled.";
        self.labelCity.hidden = NO;
    }
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)onClose:(id)sender
{
    self.labelCity.hidden = YES;
    self.working.hidden = YES;
    [self.working stopAnimating];
    [self.locationManager stopUpdatingLocation];
    [self.view removeFromSuperview];
}

-(IBAction)onStartButton:(id)sender
{
	if (startButtonStatus == 0)
	{
		[self.button setTitle:@"Cancel" forState:UIControlStateNormal];
		self.working.hidden = NO;
        self.labelCity.text = @"Searching ...";
		self.labelCity.hidden = NO;
		[self.working startAnimating];
		startButtonStatus = 1;
		[self.locationManager startUpdatingLocation];
	}
	else if (startButtonStatus == 1)
	{
		[self.button setTitle:@"Start" forState:UIControlStateNormal];
		self.working.hidden = YES;
		self.labelCity.hidden = YES;
		[self.working stopAnimating];
		[self.locationManager stopUpdatingLocation];
		startButtonStatus = 0;
	}
	else if (startButtonStatus == 2)
	{
		BalaCalAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate setGpsLongitude:[labelLongitude.text doubleValue]
							latitude:[labelLatitude.text doubleValue]
								city:self.foundCity
							 country:self.foundCountry
							timeZone:self.foundTimeZone
		 ];
        [self.view removeFromSuperview];
	}
	
}

-(void)locationManager:(CLLocationManager *)manager 
   didUpdateToLocation:(CLLocation *)newLocation
		  fromLocation:(CLLocation *)oldLocation
{
	NSString * tempStr;
	
	self.myLocation = newLocation;
	
	tempStr = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
	labelLatitude.text = tempStr;
	
	tempStr = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
	labelLongitude.text = tempStr;
	
	// stop updating location
	[self.locationManager stopUpdatingLocation];
	
	
	// find nearest city
	[self findNearestCity];
	
	// stop animating waitcursor
	self.working.hidden = YES;
	[self.working stopAnimating];

	// set button text
	[self.button setTitle:@"Use" forState:UIControlStateNormal];
	startButtonStatus = 2;
}

-(void)findNearestCity
{
	BalaCalAppDelegate * appDeleg = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext * ctx = [appDeleg managedObjectContext];
	
	NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
	
	[fetch setEntity:[NSEntityDescription entityForName:@"LCity"
								 inManagedObjectContext:ctx]];
	double lati = [labelLatitude.text doubleValue];
	double longi = [labelLongitude.text doubleValue];
	NSString * predText = [NSString stringWithFormat:@"latitude < %f and latitude > %f and"
						   " longitude < %f and longitude > %f",
						   lati + 0.75, lati - 0.75,
						   longi + 0.75, longi - 0.75];
	[fetch setPredicate:[NSPredicate predicateWithFormat:predText]];
	BOOL cityWasFound = NO;
	NSArray * arr = [ctx executeFetchRequest:fetch error:NULL];
	if (arr != nil && [arr count] > 0)
	{
		double minDist = 1000.0;
		NSManagedObject * foundObject = nil;
		double latc;
		double lonc;
		double disc;
		for(NSManagedObject * mo in arr)
		{
			latc = [[mo valueForKey:@"latitude"] doubleValue];
			lonc = [[mo valueForKey:@"longitude"] doubleValue];
			disc = (fabs(latc-lati)+fabs(lonc-longi));
			if (disc < minDist)
			{
				foundObject = mo;
				minDist = disc;
			}
		}
		
		if (foundObject != nil)
		{
			cityWasFound = YES;
			self.foundCity = [foundObject valueForKey:@"title"];
			self.foundCountry = [self findCountryFromAdminCode:[foundObject valueForKey:@"parentCode"]
													 inContext:ctx];
			self.foundTimeZone = [foundObject valueForKey:@"tzone"];
			
			self.labelCity.text = [NSString stringWithFormat:@"%@\n%@\n%@",
								   self.foundCity, self.foundCountry, self.foundTimeZone];
		}
	}
			
	if (cityWasFound == NO)
	{
		self.foundCity = @"Current Location";
		self.foundCountry = @"";
		self.foundTimeZone = [[NSTimeZone systemTimeZone] name];
	}

}

-(NSString *)findCountryFromAdminCode:(NSString *)adminCode inContext:(NSManagedObjectContext *)ctx
{
	NSArray * arr = [adminCode componentsSeparatedByString:@"."];
	if (arr == nil || [arr count] < 1)
		return @"";
	
	NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[NSEntityDescription entityForName:@"LGroup" 
								 inManagedObjectContext:ctx]];
	[fetch setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"code = '%@'", [arr objectAtIndex:0]]]];
	arr = [ctx executeFetchRequest:fetch error:NULL];
	
	if (arr == nil || [arr count] < 1)
		return @"";
	
	NSManagedObject * mo = (NSManagedObject *)[arr objectAtIndex:0];
	return [mo valueForKey:@"title"];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if ([error code] == kCLErrorLocationUnknown)
	{
        self.labelCity.text = [NSString stringWithFormat:@"Location unknown: %@", error.description];
	}

    [self.button setTitle:@"Search" forState:UIControlStateNormal];
    self.working.hidden = YES;
    [self.working stopAnimating];
    startButtonStatus = 0;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.locationManager.delegate = nil;
	self.locationManager = nil;
	self.myLocation = nil;
	self.labelLatitude = nil;
	self.labelLongitude = nil;
	self.labelCity = nil;
	self.button = nil;
}


- (void)dealloc 
{
	locationManager.delegate = nil;
	
}


@end
