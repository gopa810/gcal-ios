//
//  MainViewController.h
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GcResultToday.h"


@interface MainViewController : UIViewController 
{
	UIWebView * myWebView;
	UINavigationController * mySettingsNavigator;
	UIBarButtonItem * btnSettings;
	IBOutlet GcResultToday    * calcToday;
	IBOutlet GcResultCalendar * calcCalendar;
	IBOutlet GcLocation * myLocation;
	IBOutlet gcalAppDisplaySettings * dispSettings;
	IBOutlet GCStrings * gstrings;
}


@property (nonatomic, retain) IBOutlet UIWebView * myWebView;
@property (nonatomic, retain) UINavigationController * mySettingsNavigator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * btnSettings;
@property (nonatomic, retain) GcLocation * myLocation;

-(IBAction)actionPrevDay:(id)sender;
-(IBAction)actionNextDay:(id)sender;
-(IBAction)actionToday:(id)sender;
-(IBAction)actionSettings:(id)sender;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void)storeMyLocation;

-(void)setNewLocation:(NSManagedObject *)location;
-(IBAction)actionNormalView:(id)sender;

@end
