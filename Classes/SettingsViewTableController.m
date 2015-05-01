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
#import "GVExtensionPurchaseViewController.h"
#import "GCGregorianTime.h"

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
	
	// initialize the settings arrays
	//
	
    // TODO: t_sunset and t_noon should be removed
    // TODO: t_sunrise can hide times for sun
    // TODO: note_fd_... and note_bk_.. should be taken into calculation in sending notifications
    
	// array of display settings
	NSArray * disps = [NSArray arrayWithObjects: MakeSettingsItem(@"Sunrise/Sunset Time", 2, YES, @"t_sunrise"),
					   MakeSettingsItem(@"Sandhya Info", 2, YES, @"t_sandhya"),
					   MakeSettingsItem(@"Sunrise Info", 2, YES, @"t_riseinfo"),
					   MakeSettingsItem(@"Brahma-muhurta", 2, YES, @"t_brahma"),
                       MakeSettingsItem(@"Core Events", 2, YES, @"t_core"),
					   nil];

	NSArray * disp3 = [NSArray arrayWithObjects: 
					   MakeSettingsItem(@"Fasting days (1 day in advance)", 2, YES, @"note_fd_tomorrow"),
                       MakeSettingsItem(@"Fasting days (current day)", 2, NO, @"note_fd_today"),
					   MakeSettingsItem(@"Break fast (1 day in advance) ", 2, YES, @"note_bf_tomorrow"),
                       MakeSettingsItem(@"Break fast (current day) ", 2, NO, @"note_bf_today"),
					   nil];
	
	NSArray * disp4 = [NSArray arrayWithObjects:
							   MakeSettingsItem(@"Caturmasya system", 3, YES, @"caturmasya"),
					   nil];
    
    NSArray * modes = [NSArray arrayWithObjects:MakeSettingsItem(@"Display mode", 3, YES, @"viewmodes"), nil];
	
	self.theSettings = [NSArray arrayWithObjects:
                        MakeSettingsDirEx(@"View Mode", modes, @"modes"),
						MakeSettingsDir(@"Today Screen", disps),
						MakeSettingsDir(@"General", disp4),
						MakeSettingsDirEx(@"Notifications", disp3, @"notif"),
						nil];
    
    self.notifExtUpd = [NSArray arrayWithObject:MakeSettingsItemEx(@"Notifications", @"Upgrade with Basic Extension", @"ext_upgrade")];
	
}

#pragma mark -
#pragma mark View Management

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
}

#pragma mark -
#pragma mark Table View Datasource

-(SettingsItem *)itemAtIndexPath:(NSIndexPath *)path
{
//    SettingsItem * item = (SettingsItem *)[theSettings objectAtIndex:path.section];
    NSArray * row = [self dataRow:path.section];
    if (row)
    {
        return [row objectAtIndex:path.row];
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

#pragma mark -
#pragma mark Customized Access to dataSource

-(NSArray *)dataRow:(NSInteger)row
{
	SettingsItem * item = (SettingsItem *)[theSettings objectAtIndex:row];
	if (item)
	{
        if ([item.tag isEqualToString:@"notif"])
        {
//            if (appDispSettings.extendedFunctionality)
//            {
                return item.nodes;
//            }
//            else
//            {
//                return self.notifExtUpd;
//            }
        }
        else
        {
            return item.nodes;
        }
	}
	else {
		return nil;
	}

}

#pragma mark -
#pragma mark Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.masterKeyIdentity isEqualToString:@"caturmasya"])
    {
        return 1;
    }
    else if ([self.masterKeyIdentity isEqualToString:@"viewmodes"])
    {
        return 1;
    }
    else
    {
        return [theSettings count];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)row
{
    if ([self.masterKeyIdentity isEqualToString:@"caturmasya"])
    {
        return 4;
    }
    else if ([self.masterKeyIdentity isEqualToString:@"viewmodes"])
    {
        return 2;
    }
    else
    {
        NSArray * ar = [self dataRow:row];
        return [ar count];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    if ([self.masterKeyIdentity isEqualToString:@"caturmasya"])
    {
        appDispSettings.caturmasya = newIndexPath.row;
        [self.navigParent popViewControllerAnimated:YES];
    }
    else if ([self.masterKeyIdentity isEqualToString:@"viewmodes"])
    {
        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        [ud setInteger:newIndexPath.row forKey:@"viewMode"];
        [ud synchronize];
        
        BalaCalAppDelegate * delegate = (BalaCalAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setViewMode:newIndexPath.row];
        [delegate showDate:[GCGregorianTime today]];
        [self.navigParent popViewControllerAnimated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
        
        // push view into navigation controller
        
        SettingsItem * stw = [self itemAtIndexPath:newIndexPath];
        
        if (!stw) return;
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:newIndexPath];
        if (cell.accessoryType == UITableViewCellAccessoryNone
            && cell.accessoryView != nil
            && [cell.accessoryView class] == [UISwitchWithTag class])
        {
            UISwitchWithTag * swt = (UISwitchWithTag *)cell.accessoryView;
            swt.on = !swt.on;
            [appDispSettings setValue:[NSNumber numberWithBool:swt.on] forKey:swt.strTag];
        }
        else if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
        {
            if ([stw.tag isEqualToString:@"caturmasya"] || [stw.tag isEqualToString:@"viewmodes"])
            {
                SettingsViewTableController * subview = [[SettingsViewTableController alloc] initWithStyle:UITableViewStylePlain];
                subview.masterKeyIdentity = stw.tag;
                subview.appDispSettings = self.appDispSettings;
                
                [subview setNavigParent:navigParent];
                [navigParent pushViewController:subview animated:YES];
            }
            
            if ([stw.tag isEqualToString:@"ext_upgrade"])
            {
                GVExtensionPurchaseViewController * ep = [[GVExtensionPurchaseViewController alloc] initWithNibName:@"GVExtensionPurchaseViewController" bundle:nil];
                ep.theDispSettings = appDispSettings;
                ep.navigParent = navigParent;
                ep.storeObserver = ((BalaCalAppDelegate *)[[UIApplication sharedApplication] delegate]).storeObserver;
                [navigParent pushViewController:ep animated:YES];
                
            }
        }
    }

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if ([self.masterKeyIdentity isEqualToString:@"caturmasya"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"infoType"];
        if  (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoType"];
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        // Set up the cell
        cell.textLabel.text = [appDispSettings textForKey:self.masterKeyIdentity atIndex:indexPath.row];
    }
    else if ([self.masterKeyIdentity isEqualToString:@"viewmodes"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"infoType"];
        if  (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoType"];
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        // Set up the cell
        cell.textLabel.text = [appDispSettings textForKey:self.masterKeyIdentity atIndex:indexPath.row];
    }
    else
    {

        SettingsItem * myItem = [self itemAtIndexPath:indexPath];
        if (myItem == nil) return nil;
        NSString * sIdentifier = nil;
        UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
        
        switch (myItem.type)
        {
            case kMySettingNoneType:
                sIdentifier = @"noneType";
                break;
            case kMySettingDirType:
                sIdentifier = @"dirType";
                break;
            case kMySettingSwitchType:
                sIdentifier = @"switchType";
                break;
            case kMySettingMultivalueType:
                sIdentifier = @"multiType";
                cellStyle = UITableViewCellStyleSubtitle;
                break;
            case kMySettingSubtitled:
                sIdentifier = @"subTitled";
                cellStyle = UITableViewCellStyleSubtitle;
            default:
                sIdentifier = @"defType";
                break;
        }
        //NSLog(sIdentifier);
        cell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
        if  (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:sIdentifier];
            if (myItem.type == kMySettingSwitchType)
            {
                UISwitchWithTag * swt = [[UISwitchWithTag alloc] initWithFrame:CGRectZero];

                //NSLog(@"[switch]\n");
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryView = swt;

                [swt addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            }
            else if (myItem.type == kMySettingDirType)
            {
                //NSLog(@"[dir]\n");
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (myItem.type == kMySettingMultivalueType || myItem.type == kMySettingSubtitled)
            {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }

        
        if (myItem.type == kMySettingSwitchType)
        {
            UISwitchWithTag * swt = (UISwitchWithTag *)cell.accessoryView;
            
            swt.strTag = myItem.tag;
            swt.on = [[appDispSettings valueForKey:myItem.tag] boolValue];
        }
        else if (myItem.type == kMySettingMultivalueType)
        {
            cell.detailTextLabel.text = [appDispSettings textForKey:myItem.tag];
        }
        else if (myItem.type == kMySettingSubtitled)
        {
            cell.detailTextLabel.text = myItem.subtitle;
        }

        // Set up the cell
        cell.textLabel.text = myItem.title;
    }

	return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    if (self.masterKeyIdentity == nil)
    {
        SettingsItem * item = (SettingsItem *)[theSettings objectAtIndex:section];
        return item ? item.title : nil;
    }
	
	return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    SettingsItem * si = [theSettings objectAtIndex:section];
//    if ([si.tag isEqualToString:@"notif"])
//    {
//        if (!appDispSettings.extendedFunctionality)
//        {
//            return @"Notifications are available after purchasing extension code. Click on item above for more information.";
//        }
//    }
    if ([si.tag isEqualToString:@"modes"])
    {/*
        if (!appDispSettings.extendedFunctionality)
        {
            return @"View modes are available after purchasing extension code. Available modes are: today screen (default) and calendar view.";
        }*/
    }
    
    return nil;
}

#pragma mark -
#pragma mark switch delegate methods

-(IBAction)switchValueChanged:(id)sender
{
	UISwitchWithTag * swt = (UISwitchWithTag *)sender;
	NSLog(@"Value has been changed for tag \"%@\".\n", swt.strTag);
	[appDispSettings setValue:[NSNumber numberWithBool:swt.on] forKey:swt.strTag];
}



@end
