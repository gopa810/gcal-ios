//
//  GVChangeLocationDlg.m
//  GCAL
//
//  Created by Peter Kollath on 08/03/15.
//
//

#import "GVChangeLocationDlg.h"
#import "MainViewController.h"
#import "BalaCalAppDelegate.h"

@interface GVChangeLocationDlg ()

@end

@implementation GVChangeLocationDlg

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]];
    [self.textField becomeFirstResponder];
    
    self.fieldLock = [NSLock new];
    self.fieldValue = @"";
    self.fieldChanged = NO;
    self.searchLabel.hidden = YES;
    
    //[self performSelectorInBackground:@selector(findCityByName:) withObject:@"brat"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onUse:(id)sender
{
    BalaCalAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSString * countryName = [self findCountryByCode:[self.selectedLocation valueForKey:@"country"]];
    
    [appDelegate setGpsLongitude:[[self.selectedLocation valueForKey:@"longitude"] doubleValue]
                        latitude:[[self.selectedLocation valueForKey:@"latitude"] doubleValue]
                            city:[self.selectedLocation valueForKey:@"title"]
                         country:countryName
                        timeZone:[self.selectedLocation valueForKey:@"tzone"]
     ];
    
    [self.view removeFromSuperview];
}

-(IBAction)onCancel:(id)sender
{
    [self.view removeFromSuperview];
}

-(IBAction)onTextChange:(id)sender
{
    [self.fieldLock lock];
    self.fieldChanged = YES;
    self.fieldValue = [self.textField text];
    [self.fieldLock unlock];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textField)
    {
        [self.textField resignFirstResponder];
        [self.searchLabel setHidden:NO];
        [self performSelectorInBackground:@selector(findCityByName:)
                               withObject:self.textField.text];
    }
    
    return YES;
}

-(void)findCityByName:(NSString *)partialName
{
    BalaCalAppDelegate * appDeleg = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * ctx = [appDeleg managedObjectContext];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSFetchRequest * fetch2 = [NSFetchRequest new];
    NSString * predText = [NSString stringWithFormat:@"title like[cd] '%@*'", partialName];
    NSString * predText2 = [NSString stringWithFormat:@"title like[cd] '?*%@*'", partialName];
    
    [fetch setEntity:[NSEntityDescription entityForName:@"LCity" inManagedObjectContext:ctx]];
    [fetch setFetchLimit:20];
    [fetch setPredicate:[NSPredicate predicateWithFormat:predText]];

    [fetch2 setEntity:[NSEntityDescription entityForName:@"LCity" inManagedObjectContext:ctx]];
    [fetch2 setPredicate:[NSPredicate predicateWithFormat:predText2]];
    [fetch2 setFetchLimit:20];

    NSArray * arr = [ctx executeFetchRequest:fetch error:NULL];
    NSArray * arr2 = [ctx executeFetchRequest:fetch2 error:NULL];

    NSArray * result = [arr arrayByAddingObjectsFromArray:arr2];
    NSMutableArray * resa = [NSMutableArray new];
    
    if (result != nil && [result count] > 0)
    {
        for(NSManagedObject * mo in result)
        {
            NSMutableDictionary * d = [NSMutableDictionary new];
            
            [d setObject:[mo valueForKey:@"latitude"] forKey:@"latitude"];
            [d setObject:[mo valueForKey:@"longitude"] forKey:@"longitude"];
            [d setObject:[mo valueForKey:@"title"] forKey:@"title"];
            [d setObject:[mo valueForKey:@"tzone"] forKey:@"tzone"];
            
            NSString * code = [mo valueForKey:@"parentCode"];
            NSRange range = [code rangeOfString:@"."];
            if (range.location != NSNotFound)
            {
                code = [code substringToIndex:range.location];
            }
            [d setObject:code forKey:@"country"];
            
            [resa addObject:d];
            NSLog(@"%@ ", [d objectForKey:@"country"]);
        }
    }
    else
    {
        [resa addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"No Results", @"title",
                         @"", @"country", @"", @"tzone", nil]];
    }
 
 
    [self performSelectorOnMainThread:@selector(resultDidFinish:) withObject:resa waitUntilDone:NO];

}

-(NSString *)findCountryByCode:(NSString *)adminCode
{
    BalaCalAppDelegate * appDeleg = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * ctx = [appDeleg managedObjectContext];

    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"LGroup"
                                 inManagedObjectContext:ctx]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"code = '%@'", adminCode]]];
    NSArray * arr = [ctx executeFetchRequest:fetch error:NULL];
    
    if (arr == nil || [arr count] < 1)
        return @"";
    
    NSManagedObject * mo = (NSManagedObject *)[arr objectAtIndex:0];
    return [mo valueForKey:@"title"];
}

-(void)resultDidFinish:(id)sender
{
    self.resultArray = (NSArray *)sender;
    self.selectedLocation = nil;
    self.searchLabel.hidden = YES;
    [self.tableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * myItem = [self.resultArray objectAtIndex:indexPath.row];
    if (myItem == nil) return nil;
    NSString * sIdentifier = @"location";
    
    //NSLog(sIdentifier);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
    if  (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sIdentifier];
    }

    // Set up the cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ [%@]", [myItem valueForKey:@"title"], [myItem valueForKey:@"country"]];
    cell.detailTextLabel.text = [myItem valueForKey:@"tzone"];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLocation = [self.resultArray objectAtIndex:indexPath.row];
}

@end
