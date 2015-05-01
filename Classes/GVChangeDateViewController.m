//
//  GVChangeDateViewController.m
//  GCAL
//
//  Created by Peter Kollath on 08/03/15.
//
//

#import "GVChangeDateViewController.h"
#import "MainViewController.h"

@interface GVChangeDateViewController ()

@end

@implementation GVChangeDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onSelect:(id)sender
{
    NSDate * date = [self.datePicker date];
    NSCalendar * cal = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
    NSDateComponents * dc = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                   fromDate:date];
    
    [self.mainController setCurrentDay:dc.day month:dc.month year:dc.year];
    [self.view removeFromSuperview];
    
}


-(IBAction)onCancel:(id)sender
{
    [self.view removeFromSuperview];
}



@end
