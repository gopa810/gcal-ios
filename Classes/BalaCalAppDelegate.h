//
//  BalaCalAppDelegate.h
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright GPSL 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainViewController.h"
#import "GCDisplaySettings.h"
#import "LGroup.h"
#import "LCity.h"

@class DayResultsView;
@class GCStrings;
@class HUScrollView, VUScrollView;
@class GCStoreObserver;
@class GCGregorianTime;

@interface BalaCalAppDelegate : NSObject <UIApplicationDelegate> {
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic) IBOutlet UIWindow *window;
@property IBOutlet UIView * mainView;
@property IBOutlet GCEngine * theEngine;
//@property IBOutlet HUScrollView * scrollViewH;
@property IBOutlet UIScrollView * scrollViewD;
@property IBOutlet VUScrollView * scrollViewV;
@property IBOutlet DayResultsView * dayView;
@property IBOutlet GCStrings * gstrings;
@property IBOutlet GcLocation * myLocation;
@property IBOutlet GCDisplaySettings * dispSettings;
@property IBOutlet UIView * menuBar;
@property IBOutlet GCStoreObserver * storeObserver;
@property (strong) NSMutableArray * defaultEvents;

@property (strong) MainViewController * mainViewCtrl;
@property (strong) NSString * lastNotificationDateTomorrow;
@property (strong) NSString * lastNotificationDateToday;
@property (strong) UISwipeGestureRecognizer * leftSwipe;
@property (strong) UISwipeGestureRecognizer * rightSwipe;
@property (strong) UISwipeGestureRecognizer * leftSwipe2;
@property (strong) UISwipeGestureRecognizer * rightSwipe2;
@property IBOutlet UIButton * nextDay;
@property IBOutlet UIButton * prevDay;
@property BOOL defaultsChangesPending;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
-(void)initLocationsDb;
-(NSArray *)locSubgroupsForContextKey:(NSString *)strKey inContext:(NSManagedObjectContext *)ctx;
-(NSArray *)locCitiesForContextKey:(NSString *)strKey inContext:(NSManagedObjectContext *)ctx;
-(void)setGpsLongitude:(double)longitude latitude:(double)latitude
				  city:(NSString *)inCity country:(NSString *)inCountry timeZone:(NSString *)inTimeZone;
-(NSArray *)getLocationsRoot:(NSManagedObjectContext *)ctx;

-(void)setLocationData:(GcLocation *)locationdata;
-(void)setViewMode:(NSInteger)sm;
-(void)showDate:(GCGregorianTime *)dateToShow;

@end

