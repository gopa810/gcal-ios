    //
//  MainViewController.m
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewTableController.h"
#import "BalaCalAppDelegate.h"

@implementation MainViewController

@synthesize myWebView;
@synthesize mySettingsNavigator;
@synthesize btnSettings;
@synthesize myLocation;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.view.hidden = YES;
	//[myWebView loadHTMLString:[calcToday formatInitialHtml] baseURL:nil];
	NSLog(@"gstr prepare strings");
	[gstrings prepareStrings];
	
	//BalaCalAppDelegate * appDeleg = [[UIApplication sharedApplication] delegate];
	//calcToday.disp = appDeleg.appDispSettings;
	//calcCalendar.disp = appDeleg.appDispSettings;
	BalaCalAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
	[dispSettings readFromFile:[appDelegate dispAppSettingsFileName]];
	
	myLocation.city = dispSettings.locCity;
	myLocation.country = dispSettings.locCountry;
	myLocation.latitude = dispSettings.locLatitude;
	myLocation.longitude = dispSettings.locLongitude;
	myLocation.timeZone = [NSTimeZone timeZoneWithName:dispSettings.locTimeZone];
	if (myLocation.timeZone == nil)
		myLocation.timeZone = [NSTimeZone systemTimeZone];

	//NSLog(@"view will calculate");
	//[self actionToday:self];
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
	if (mySettingsNavigator.view != nil)
	{
		//return YES;
		return interfaceOrientation == UIInterfaceOrientationPortrait;
	}
	else 
	{
		return YES;
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.myWebView = nil;
	self.mySettingsNavigator = nil;
	self.myLocation = nil;
}


- (void)dealloc {
	[myWebView release];
	[mySettingsNavigator release];
	[myLocation release];
    [super dealloc];
}

-(IBAction)actionPrevDay:(id)sender
{
	[calcToday setPrevDay];
	[myWebView loadHTMLString:[calcToday formatTodayHtml]
					  baseURL:nil];
}

-(IBAction)actionNextDay:(id)sender
{
	[calcToday setNextDay];
	[myWebView loadHTMLString:[calcToday formatTodayHtml]
					  baseURL:nil];
	
}

-(void)opCalcToday
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	gc_time d;
	gc_time_Today(&d);
	[calcToday calcDate:d];
	[myWebView loadHTMLString:[calcToday formatTodayHtml]
					  baseURL:nil];
	[pool drain];
    self.view.hidden = NO;
}

-(void)opRecalc
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[calcToday recalc];
	[myWebView loadHTMLString:[calcToday formatTodayHtml] baseURL:nil];
	[pool drain];
    self.view.hidden = NO;
}

-(void)setRecalculationPage
{
    self.view.hidden = YES;
	//[myWebView loadHTMLString:@"<html><head></head><body bgcolor=\"4A4A4A\"><p align=center style='font-size:12pt;font-family:Verdana;color:white'><br><br>Calculating..</p></body></html>"
	//				  baseURL:nil];
}

-(IBAction)actionToday:(id)sender
{
	if (calcToday != nil && myWebView != nil)
	{
		[self setRecalculationPage];
		[self performSelectorInBackground:@selector(opCalcToday) withObject:nil];
	}
	
}

-(IBAction)actionNormalView:(id)sender
{
	if (self.mySettingsNavigator != nil)
	{
		self.mySettingsNavigator.view = nil;
		self.mySettingsNavigator = nil;
	}
	[self setRecalculationPage];
	[self performSelectorInBackground:@selector(opRecalc) withObject:nil];
}

-(IBAction)actionSettings:(id)sender
{
	// create nac controller and register in this controller
	// self.mySettingsNavigator = ...
	SettingsViewTableController * settingsTable = [[SettingsViewTableController alloc] initWithStyle: UITableViewStyleGrouped];
	settingsTable.title = @"GCAL Settings";
	UIBarButtonItem * rbItem = [[UIBarButtonItem alloc] initWithTitle:@"Calendar" 
																style:UIBarButtonItemStyleBordered 
															   target:self 
															   action:@selector(actionNormalView:)];
	settingsTable.navigationItem.leftBarButtonItem = rbItem;
	[rbItem release];
	settingsTable.appDispSettings = calcToday.disp;
	//settingsTable.navigationItem
	UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:settingsTable];
	[settingsTable setNavigParent:nav];
	[settingsTable release];
	
//	nav.interfaceOrientation = UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft |
//	UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortraitUpsideDown;
	//nav.navigationBar
	
	self.mySettingsNavigator = nav;
	[nav release];
	
	// self.rootView insertSubView:navigator atIndex:0
	[nav viewWillAppear:YES];
	//NSLog(@"NavView %@\n-------------\n", nav.view);
	[self.view.superview addSubview:nav.view];
	[self.view.superview bringSubviewToFront:nav.view];
	[nav viewDidAppear:YES];
}

-(NSString *)firstCountryWithCode:(NSString *)code inContext:(NSManagedObjectContext *)ctx
{
	NSFetchRequest * freq = [[[NSFetchRequest alloc] init] autorelease];
	[freq setEntity:[NSEntityDescription entityForName:@"LGroup" inManagedObjectContext:ctx]];
	[freq setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"code = \"%@\"", code]]];
	[freq setSortDescriptors:nil];
	NSArray * tzones = [ctx executeFetchRequest:freq error:NULL];
	if (tzones != nil && [tzones count] > 0)
	{
		return (NSString *)[[tzones objectAtIndex:0] valueForKey:@"title"];
	}
	return @"";
}
-(void)storeMyLocation
{
	dispSettings.locCity = myLocation.city;
	dispSettings.locCountry = myLocation.country;
	dispSettings.locLatitude = myLocation.latitude;
	dispSettings.locLongitude = myLocation.longitude;
	dispSettings.locTimeZone = [myLocation.timeZone name];
}

-(void)setNewLocation:(NSManagedObject *)location
{
	BalaCalAppDelegate * deleg = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext * ctx = [deleg managedObjectContext];
	
	// set new location
	NSString * tzone = (NSString *)[location valueForKey:@"tzone"];
	NSString * parentCode = (NSString *)[location valueForKey:@"parentCode"];
	NSArray * parentCodeComponents = [parentCode componentsSeparatedByString:@"."];
	if ([parentCodeComponents count] > 0)
		parentCode = (NSString *)[parentCodeComponents objectAtIndex:0];
	
	myLocation.city = [location valueForKey:@"title"];
	myLocation.country = [self firstCountryWithCode:parentCode inContext:ctx];
	myLocation.latitude = [[location valueForKey:@"latitude"] doubleValue];
	myLocation.longitude = [[location valueForKey:@"longitude"] doubleValue];
	myLocation.timeZone = [NSTimeZone timeZoneWithName:tzone];
	if (myLocation.timeZone == nil)
		myLocation.timeZone = [NSTimeZone systemTimeZone];

	[self storeMyLocation];

	/*NSFetchRequest * freq = [[[NSFetchRequest alloc] init] autorelease];
	[freq setEntity:[NSEntityDescription entityForName:@"LTimezone" inManagedObjectContext:ctx]];
	[freq setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"title = \"%@\"", tzone]]];
	[freq setSortDescriptors:nil];
	NSArray * tzones = [ctx executeFetchRequest:freq error:NULL];
	if (tzones != nil && [tzones count] > 0)
	{
		NSManagedObject * tzobj = (NSManagedObject *)[tzones objectAtIndex:0];
		myLocation.start_month = [[tzobj valueForKey:@"start_month"] intValue];
		myLocation.start_monthday = [[tzobj valueForKey:@"start_month_day"] intValue];
		myLocation.start_weekday = [[tzobj valueForKey:@"start_week_day"] intValue];
		myLocation.start_order   = [[tzobj valueForKey:@"start_month_week"] intValue];
		myLocation.end_month = [[tzobj valueForKey:@"end_month"] intValue];
		myLocation.end_monthday = [[tzobj valueForKey:@"end_month_day"] intValue];
		myLocation.end_weekday = [[tzobj valueForKey:@"end_week_day"] intValue];
		myLocation.end_order   = [[tzobj valueForKey:@"end_month_week"] intValue];
		//myLocation.tzone = [[tzobj valueForKey:@"offset"] intValue] / 60.0;
		//myLocation.bias  = [[tzobj valueForKey:@"bias"] intValue] / 60.0;
		//myLocation.timezoneName = [NSString stringWithFormat:@"%@ %@", 
								   //[gstrings GetTextTimeZone:myLocation.tzone], 
								   //[location valueForKey:@"tzone"]];
	}*/
	
	// close settings window
	[self performSelectorOnMainThread:@selector(actionNormalView:) withObject:nil waitUntilDone:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
		btnSettings.enabled = YES;
	else
		btnSettings.enabled = NO;
}

@end
