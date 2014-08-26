//
//  GpsViewController.h
//  GCAL
//
//  Created by Peter Kollath on 8/18/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GpsViewController : UIViewController <CLLocationManagerDelegate> {

	CLLocationManager * locationManager;
	CLLocation * myLocation;
	IBOutlet UILabel * labelLongitude;
	IBOutlet UILabel * labelLatitude;
	IBOutlet UILabel * labelCity;
	IBOutlet UIActivityIndicatorView * working;
	IBOutlet UIButton * button;
	int startButtonStatus;
	NSString * foundCity;
	NSString * foundCountry;
	NSString * foundTimeZone;
}

@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic, retain) CLLocation * myLocation;
@property (nonatomic, retain) UILabel * labelLongitude;
@property (nonatomic, retain) UILabel * labelLatitude;
@property (nonatomic, retain) UIButton * button;
@property (nonatomic, retain) UIActivityIndicatorView * working;
@property (nonatomic, retain) NSString * foundCity;
@property (nonatomic, retain) NSString * foundCountry;
@property (nonatomic, retain) NSString * foundTimeZone;
@property (nonatomic, retain) UILabel * labelCity;
-(IBAction)onStartButton:(id)sender;
-(void)findNearestCity;
-(NSString *)findCountryFromAdminCode:(NSString *)adminCode inContext:(NSManagedObjectContext *)ctx;

@end
