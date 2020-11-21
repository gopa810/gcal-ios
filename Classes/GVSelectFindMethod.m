//
//  GVSelectFindMethod.m
//  GCAL
//
//  Created by Peter Kollath on 08/03/15.
//
//

#import "GVSelectFindMethod.h"
#import "../MainViewController.h"
#import "GCDisplaySettings.h"

@interface GVSelectFindMethod ()

@end

@implementation GVSelectFindMethod

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onGPS:(id)sender
{
    [self.mainController onShowGps:sender];
    [self.view removeFromSuperview];
}

-(IBAction)onManual:(id)sender
{
    [self.mainController onShowLocationDlg:sender];
    [self.view removeFromSuperview];
}

-(IBAction)onSelectDate:(id)sender
{
    [self.mainController onShowDateChangeView:sender];
    [self.view removeFromSuperview];
}

-(IBAction)onCancel:(id)sender
{
    [self.view removeFromSuperview];
}


@end
