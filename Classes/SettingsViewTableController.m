//
//  SettingsViewTableController.m
//  GCAL
//
//  Created by Peter Kollath on 8/8/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "BalaCalAppDelegate.h"
#import "SettingsViewTableController.h"
#import "SettingsItem.h"
#import "UISwitchWithTag.h"
#import "LocationViewTableController.h"
#import "GpsViewController.h"

@implementation SettingsViewTableController
@synthesize theTableView;
@synthesize theSettings;
@synthesize appDispSettings;



-(void)setNavigParent:(UINavigationController *)navig
{
	navigParent = navig;
}

-(UINavigationController *)navigParent
{
	return navigParent;
}

#pragma mark  ==== view controller methpds ===

-(void)loadView
{
	[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
	
	UITableView * tableView = [[UITableView alloc]
							   initWithFrame:[[UIScreen mainScreen] applicationFrame]
							   style:UITableViewStyleGrouped];
	
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	tableView.delegate = self;
	tableView.dataSource = self;
	
	self.theTableView = tableView;
	self.view = tableView;
	[tableView release];
	
	// initialize the settings arrays
	//
	
	// array of display settings
	NSArray * disps = [NSArray arrayWithObjects: MakeSettingsItem(@"Sunrise Time", 2, YES, @"t_sunrise"),
					   MakeSettingsItem(@"Noon Time", 2, YES, @"t_noon"),
					   MakeSettingsItem(@"Sunset Time", 2, YES, @"t_sunset"),
					   MakeSettingsItem(@"Sandhya Info", 2, YES, @"t_sandhya"),
					   MakeSettingsItem(@"Sunrise Info", 2, YES, @"t_riseinfo"),
					   MakeSettingsItem(@"Brahma-muhurta", 2, YES, @"t_brahma"),
					   //MakeSettingsItem(@"Tithi Details", 2, YES, @"t_det_tithi"),
					   //MakeSettingsItem(@"Naksatra Details", 2, YES, @"t_det_naksatra"),
					   nil];
	NSArray * disp2 = [NSArray arrayWithObjects:MakeSettingsItem(@"Manual Set ", 1, NO, @"loc_man"),
					   MakeSettingsItem(@"Automatic Set", 1, NO, @"loc_gps"),
					   nil];
	NSArray * disp3 = [NSArray arrayWithObjects: 
					   MakeSettingsItem(@"Tithi Details", 2, YES, @"t_det_tithi"),
					   MakeSettingsItem(@"Naksatra Details", 2, YES, @"t_det_naksatra"),
					   nil];
	
	NSArray * disp4 = [NSArray arrayWithObjects:
							   MakeSettingsItem(@"Purnima System", 2, YES, @"catur_purn"),
							   MakeSettingsItem(@"Pratipat System", 2, NO, @"catur_prat"),
							   MakeSettingsItem(@"Ekadasi System", 2, NO, @"catur_ekad"),
					   nil];
	
	self.theSettings = [NSArray arrayWithObjects:
						MakeSettingsDir(@"Location", disp2),
						MakeSettingsDir(@"Display", disps),
						MakeSettingsDir(@"Caturmasya", disp4),
						MakeSettingsDir(@"Advanced", disp3),
						nil];
	
}

#pragma mark === memory management ===

-(void)viewDidUnload
{
	self.theSettings = nil;
	self.theTableView.delegate = nil;
	self.theTableView.dataSource = nil;
	self.theTableView = nil;
	self.appDispSettings = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
	[theTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


-(void)dealloc
{
	theTableView.delegate = nil;
	theTableView.dataSource = nil;
	[theTableView release];
	[theSettings release];
	[appDispSettings release];
	[super dealloc];
}

#pragma mark === datasource ===

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [theSettings count];
}

#pragma mark === Customized Access to dataSource ===

-(NSArray *)dataRow:(NSInteger)row
{
	SettingsItem * item = (SettingsItem *)[theSettings objectAtIndex:row];
	if (item)
	{
		return item.nodes;
	}
	else {
		return nil;
	}

}

#pragma mark === Table view delegate methods ===

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)row
{
	NSArray * ar = [self dataRow:row];
	return [ar count];
}

-(SettingsItem *)itemAtIndexPath:(NSIndexPath *)path
{
	SettingsItem * item = (SettingsItem *)[theSettings objectAtIndex:path.section];
	if (item)
	{
		return [item.nodes objectAtIndex:path.row];
	}
	else 
	{
		return nil;
	}

}

-(LGroup *)rootLocationGroup
{
	BalaCalAppDelegate * deleg = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext * ctx = [deleg managedObjectContext];
	NSArray * a = [deleg getLocationsRoot:ctx];

	if ([a count] < 1) return nil;
	return [a objectAtIndex:0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	[tableView deselectRowAtIndexPath:newIndexPath animated:YES];
	
	// push view into navigation controller
	
	SettingsItem * stw = [self itemAtIndexPath:newIndexPath];
	
	if (!stw) return;
	
	if ([stw.tag isEqual:@"loc_man"])
	{
		LocationViewTableController * locs = [[LocationViewTableController alloc] initWithStyle:UITableViewStylePlain];
		if (navigParent)
		{
			locs.title = @"Locations";
			[locs setNavigParent:navigParent];
			[locs setContentArrays:@"ROOT"];
			[navigParent pushViewController:locs animated:YES];
		}
		[locs release];
	}
	else if ([stw.tag isEqual:@"loc_gps"])
	{
		GpsViewController * gps = [[GpsViewController alloc] initWithNibName:@"GpsViewController" bundle:nil];
		if (navigParent)
		{
			gps.title = @"GPS";
			[navigParent pushViewController:gps animated:YES];
		}
		[gps release];
	}
	
}


-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SettingsItem * myItem = [self itemAtIndexPath:indexPath];
	if (myItem == nil) return nil;
	NSString * sIdentifier = nil;
	
	//NSLog(@"%@ %@ %d - ", myItem.title, myItem.tag, myItem.type);
	switch (myItem.type)
	{
		case kMySettingNoneType: sIdentifier = @"noneType";break;
		case kMySettingDirType: sIdentifier = @"dirType";break;
		case kMySettingSwitchType: sIdentifier = @"switchType";break;
		default: sIdentifier = @"defType";break;
	}
	//NSLog(sIdentifier);
	UITableViewCell *cell =
	[tableView dequeueReusableCellWithIdentifier:sIdentifier];
	if  (cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithFrame:CGRectZero
				 reuseIdentifier:sIdentifier] autorelease];
		if (myItem.type == kMySettingSwitchType)
		{
			//NSLog(@"[switch]\n");
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.accessoryView = [[[UISwitchWithTag alloc] initWithFrame:CGRectZero] autorelease];
		}
		if (myItem.type == kMySettingDirType)
		{
			//NSLog(@"[dir]\n");
			cell.accessoryView = nil;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		// UISwitch instance.on = YES or NO
	}
	// Set up the cell
	cell.textLabel.text = myItem.title;
	
	if (myItem.type == kMySettingSwitchType)
	{
		UISwitchWithTag * swt = (UISwitchWithTag *)cell.accessoryView;
		swt.strTag = myItem.tag;
		swt.on = [[appDispSettings valueForKey:myItem.tag] boolValue];
		[swt addTarget:self action:@selector(switchValueChanged:) 
			forControlEvents:UIControlEventValueChanged];
	}

	
	return cell;
}
-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	
	SettingsItem * item = (SettingsItem *)[theSettings objectAtIndex:section];
	if (item)
	{
		return item.title;
	}
	else {
		return nil;
	}
	
	return title;
}

#pragma mark === switch delegate methods ===

-(IBAction)switchValueChanged:(id)sender
{
	UISwitchWithTag * swt = (UISwitchWithTag *)sender;
	NSLog(@"Value has been changed for tag \"%@\".\n", swt.strTag);
	[appDispSettings setValue:[NSNumber numberWithBool:swt.on] forKey:swt.strTag];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
