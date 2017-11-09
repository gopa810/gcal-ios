//
//  LocationViewTableController.m
//  GCAL
//
//  Created by Peter Kollath on 8/11/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "LocationViewTableController.h"
#import "BalaCalAppDelegate.h"


@implementation LocationViewTableController

@synthesize content;
@synthesize contGroups;
@synthesize contCities;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/

-(void)setNavigParent:(UINavigationController *)navig
{
	navigParent = navig;
}

-(UINavigationController *)navigParent
{
	return navigParent;
}


#pragma mark -
#pragma mark View lifecycle


-(void)loadView
{
	UITableView * tableView = [[UITableView alloc]
							   initWithFrame:[[UIScreen mainScreen] applicationFrame]
							   style:UITableViewStylePlain];
	
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	tableView.delegate = self;
	tableView.dataSource = self;
	
	//self.theTableView = tableView;
	self.view = tableView;
	
}
/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)setContentArrays:(NSString *)grp
{
	BalaCalAppDelegate * deleg = [[UIApplication sharedApplication] delegate];
	NSLog(@"setContentArrays: (%@)\n", grp);
	self.content = grp;
	NSArray * descs = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
	self.contGroups = [[deleg locSubgroupsForContextKey:grp inContext:[deleg managedObjectContext]] sortedArrayUsingDescriptors:descs];
	self.contCities = [[deleg locCitiesForContextKey:grp inContext:[deleg managedObjectContext]] sortedArrayUsingDescriptors:descs];
	
	NSLog(@"setContentArray: contGroups count = %d\n", (int)[self.contGroups count]);
	NSLog(@"setContentArray: contCities count = %d\n", (int)[self.contCities count]);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSInteger value;
	
    if (section == 0)
	{
		value = [self.contGroups count];
	}
	else {
		value = [self.contCities count];
	}

	return value;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier[] = {@"Cell0", @"Cell1", @"Cell2"};
    
    UITableViewCell *cell = nil;
    
    // Configure the cell...
	if (indexPath.section == 0)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier[indexPath.section]];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
										   reuseIdentifier:CellIdentifier[indexPath.section]];
		}
		NSManagedObject * group = (NSManagedObject *)[self.contGroups objectAtIndex:indexPath.row];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = [group valueForKey:@"title"];
		cell.textLabel.textColor = [UIColor darkGrayColor];
    }
	else
	{
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier[indexPath.section]];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
										   reuseIdentifier:CellIdentifier[indexPath.section]];
		}
		NSManagedObject * city = (NSManagedObject *)[self.contCities objectAtIndex:indexPath.row];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.text = [city valueForKey:@"title"];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.text = [city valueForKey:@"tzone"];
		cell.detailTextLabel.textColor = [UIColor grayColor];
	}
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	
	//if (section == 0)
	//	title = self.content.subGroupsName;
	//else
	//	title = @"Cities";
	
	
	return title;
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	[tableView deselectRowAtIndexPath:newIndexPath animated:YES];
	
	// push view into navigation controller
	
	if (newIndexPath.section == 0)
	{
		LocationViewTableController * locs = [[LocationViewTableController alloc] initWithStyle:UITableViewStylePlain];
		if (navigParent)
		{
			NSManagedObject * lg = (NSManagedObject *)[self.contGroups objectAtIndex:newIndexPath.row];
			locs.title = [lg valueForKey:@"title"];
			[locs setNavigParent:navigParent];
			[locs setContentArrays:[lg valueForKey:@"code"]];
			[navigParent pushViewController:locs animated:YES];
		}
	}
	else if (newIndexPath.section == 1)
	{
		BalaCalAppDelegate * deleg = [[UIApplication sharedApplication] delegate];
		[deleg.mainViewCtrl setNewLocation:((NSManagedObject *)[self.contCities objectAtIndex:newIndexPath.row])];
	}
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.content = nil;
	self.contGroups = nil;
	self.contCities = nil;
}




@end

