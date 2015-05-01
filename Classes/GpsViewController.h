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

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation * myLocation;
@property (nonatomic, strong) UILabel * labelLongitude;
@property (nonatomic, strong) UILabel * labelLatitude;
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, strong) UIActivityIndicatorView * working;
@property (nonatomic, strong) NSString * foundCity;
@property (nonatomic, strong) NSString * foundCountry;
@property (nonatomic, strong) NSString * foundTimeZone;
@property (nonatomic, strong) UILabel * labelCity;
-(IBAction)onStartButton:(id)sender;
-(void)findNearestCity;
-(NSString *)findCountryFromAdminCode:(NSString *)adminCode inContext:(NSManagedObjectContext *)ctx;

@end
