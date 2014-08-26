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
#import "gcalAppDisplaySettings.h"
#import "LGroup.h"
#import "LCity.h"

@interface BalaCalAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	MainViewController * mainViewCtrl;
	gcalAppDisplaySettings * appDispSettings;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController * mainViewCtrl;
@property (nonatomic, retain) IBOutlet gcalAppDisplaySettings * appDispSettings;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSString *)dispAppSettingsFileName;
- (NSString *)applicationDocumentsDirectory;
-(void)initLocationsDb;
-(NSArray *)locSubgroupsForContextKey:(NSString *)strKey inContext:(NSManagedObjectContext *)ctx;
-(NSArray *)locCitiesForContextKey:(NSString *)strKey inContext:(NSManagedObjectContext *)ctx;
-(void)setGpsLongitude:(double)longitude latitude:(double)latitude
				  city:(NSString *)inCity country:(NSString *)inCountry timeZone:(NSString *)inTimeZone;
-(NSArray *)getLocationsRoot:(NSManagedObjectContext *)ctx;

@end

