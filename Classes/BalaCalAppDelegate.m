//
//  BalaCalAppDelegate.m
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright GPSL 2010. All rights reserved.
//

#import "BalaCalAppDelegate.h"
#import "LGroup.h"
#import "LCity.h"
#import "MainViewController.h"
#import "GCStrings.h"
#import "GcLocation.h"
#import "HUScrollView.h"
#import "VUScrollView.h"
#import "GCGregorianTime.h"
#import "GCCalendarDay.h"
#import "GCTodayInfoData.h"
#import "GCStoreObserver.h"
#import "DayResultsView.h"

@implementation BalaCalAppDelegate

#pragma mark === from InitLocations.h ===

int ADD_ALL_LOCATION_ITEMS(NSManagedObjectContext * ctx);

#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.

//    @try {
//        if ([application respondsToSelector:@selector(setMinimumBackgroundFetchInterval:)])
//        {
//            [application setMinimumBackgroundFetchInterval:7200];
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    @finally {
//    }
    self.defaultsChangesPending = NO;
    
	//NSLog(@"appl did finish 1");
    //[myWebView loadHTMLString:[calcToday formatInitialHtml] baseURL:nil];
    NSLog(@"gstr prepare strings");
    [self.gstrings prepareStrings];
    
    //BalaCalAppDelegate * appDeleg = [[UIApplication sharedApplication] delegate];
    //calcToday.disp = appDeleg.appDispSettings;
    //calcCalendar.disp = appDeleg.appDispSettings;
    [self.dispSettings readFromFile];
    
    self.myLocation.city = self.dispSettings.locCity;
    self.myLocation.country = self.dispSettings.locCountry;
    self.myLocation.latitude = self.dispSettings.locLatitude;
    self.myLocation.longitude = self.dispSettings.locLongitude;
    self.myLocation.timeZone = [NSTimeZone timeZoneWithName:self.dispSettings.locTimeZone];
    if (self.myLocation.timeZone == nil)
        self.myLocation.timeZone = [NSTimeZone systemTimeZone];
    

    GCGregorianTime * dateToShow = [GCGregorianTime today];

    @try {
        UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotif) {
            NSString * itemName = [localNotif.userInfo objectForKey:@"action"];
            if ([itemName isEqualToString:@"ShowDate"])
            {
                NSString * date = [localNotif.userInfo objectForKey:@"date"];
                NSArray * cp = [date componentsSeparatedByString:@"."];
                if (cp.count == 3)
                {
                    dateToShow.year = [[cp objectAtIndex:0] intValue];
                    dateToShow.month = [[cp objectAtIndex:1] intValue];
                    dateToShow.day = [[cp objectAtIndex:2] intValue];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    self.mainViewCtrl = [[MainViewController alloc] init];
    self.window.rootViewController = self.mainViewCtrl;
    //self.mainViewCtrl.view.frame = self.mainView.frame;
    //[self.mainView addSubview:self.mainViewCtrl.view];
    [self.window makeKeyAndVisible];

    self.mainViewCtrl.view = self.mainView;
    self.mainViewCtrl.mainView = self.mainView;
//    self.mainViewCtrl.scrollViewH = self.scrollViewH;
    self.mainViewCtrl.scrollViewD = self.scrollViewD;
    self.mainViewCtrl.nextDay = self.nextDay;
    self.mainViewCtrl.prevDay = self.prevDay;
    self.mainViewCtrl.dayView = self.dayView;
    self.mainViewCtrl.scrollViewV = self.scrollViewV;
    self.mainViewCtrl.theSettings = self.dispSettings;
    

    self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.mainViewCtrl.scrollViewD addGestureRecognizer:self.leftSwipe];
    
    self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mainViewCtrl.scrollViewD addGestureRecognizer:self.rightSwipe];

    self.leftSwipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
    self.leftSwipe2.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainView addGestureRecognizer:self.leftSwipe2];
    
    self.rightSwipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
    self.rightSwipe2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mainView addGestureRecognizer:self.rightSwipe2];

    
    CGFloat minn = MIN(self.mainView.frame.size.width, self.mainView.frame.size.height);
    CGRect oframe = self.mainViewCtrl.scrollViewV.frame;
    oframe.size.width = ceil((1 - (minn - 320)/1200.0)*minn);
    oframe.origin.x = (self.mainView.frame.size.width - oframe.size.width) / 2;
    self.mainViewCtrl.scrollViewV.frame = oframe;
    self.mainViewCtrl.scrollViewV.normalSubviewWidth = oframe.size.width;
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSInteger viewMode = [ud integerForKey:@"viewMode"];
    [self setViewMode:viewMode];
	
	// init data if not initialized
#ifdef GCAL_DEBUG_BUILD_LOCATIONS
	NSLog(@"Now it is going to build locations list.\n");
	[self initLocationsDb];
	NSLog(@"Building locations list is completed.\n");
#endif

    [self showDate:dateToShow];
    
    [self applicationRegisterForLocalNotifications];
    
    [self.storeObserver registerAsObserver];

    @try {
        [self.mainViewCtrl startHelp];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(userDefaultsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [self performSelectorInBackground:@selector(generateFutureNotifications) withObject:nil];
    //[self performSelector:@selector(scheduleNotificationWithItem:) withObject:@"Tomorrow is Ekadasi" afterDelay:2];
	return YES;
}

-(void)userDefaultsChanged:(NSNotification *)notification {

    if (self.defaultsChangesPending == YES)
        return;

    [self resetFutureNotifications];
    
}

-(void)resetFutureNotifications
{
    self.defaultsChangesPending = YES;
    NSUserDefaults * udef = [NSUserDefaults standardUserDefaults];
    [udef setDouble:0.0 forKey:@"nextFutureCalc"];
    [udef synchronize];

    [self performSelectorInBackground:@selector(generateFutureNotifications) withObject:nil];
}

-(void)generateFutureNotifications
{
    @try {
        NSUserDefaults * udef = [NSUserDefaults standardUserDefaults];
        NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval last = [udef doubleForKey:@"nextFutureCalc"];
        if (last > ti)
        {
            NSLog(@"Calculation for future is not necessary");
            return;
        }

//        NSArray * arr = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSMutableArray * ma = [NSMutableArray new];
//        for (UILocalNotification * ln in arr) {
//            NSLog(@"--- Notification: %@", ln.alertBody);
//            NSLog(@"    Date: %@", ln.fireDate);
//            NSLog(@"");
//        }
        
        GCGregorianTime * gc = [GCGregorianTime today];
        
        int julDay = [gc getJulianInteger];
        NSMutableString * str = [NSMutableString new];
        int type = 0;
        int julPage, julPageIndex;
        GCTodayInfoData * tid;
        NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        for(int i = 0; i < 30; i++)
        {
            julPage = julDay / 32;
            julPageIndex = julDay % 32;

            tid = [self.theEngine requestPage:julPage view:nil itemIndex:julPageIndex];
            julDay++;
            [str setString:@""];
            type = 0;
        
            for (GcDayFestival * gdf in tid.calendarDay.festivals) {
                if (gdf.highlight > 0)
                {
                    type = 1;
                    //NSLog(@"%@ Festival %d: %@", [tid.calendarDay.date longDateString], gdf.highlight, gdf.name);
                    [str appendString:gdf.name];
                    [str appendString:@"\n"];
                }
            }
            if (type > 0 && self.dispSettings.note_fd_today)
            {
                UILocalNotification * note = [UILocalNotification new];
                //note.alertTitle = @"GCAL Break fast";
                note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                note.timeZone = [NSTimeZone defaultTimeZone];
                NSDateComponents * dc = [NSDateComponents new];
                GCGregorianTime * tt = tid.calendarDay.date;
                dc.timeZone = note.timeZone;
                dc.year = tt.year;
                dc.month = tt.month;
                dc.day = tt.day;
                dc.hour = tid.calendarDay.astrodata.sun.rise.hour;
                dc.minute = tid.calendarDay.astrodata.sun.rise.minute;
                note.fireDate = [calendar dateFromComponents:dc];
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"FestivalToday", @"GCALEvent", nil];
                note.userInfo = infoDict;
                note.alertAction = @"View Details";
                note.soundName = UILocalNotificationDefaultSoundName;
                [ma addObject:note];
            }
            if (type > 0 && self.dispSettings.note_fd_tomorrow)
            {
                UILocalNotification * note = [UILocalNotification new];
                //note.alertTitle = @"GCAL Break fast";
                note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                note.timeZone = [NSTimeZone defaultTimeZone];
                NSDateComponents * dc = [NSDateComponents new];
                GCGregorianTime * tt = tid.calendarDay.date;
                dc.timeZone = note.timeZone;
                dc.year = tt.year;
                dc.month = tt.month;
                dc.day = tt.day;
                dc.hour = 16;
                dc.minute = 0;
                note.fireDate = [[calendar dateFromComponents:dc] dateByAddingTimeInterval:-86400];
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"FestivalToday", @"GCALEvent", nil];
                note.userInfo = infoDict;
                note.alertAction = @"View Details";
                note.soundName = UILocalNotificationDefaultSoundName;
                [ma addObject:note];
            }
            
            if (tid.calendarDay.isEkadasiParana)
            {
                type = 3;
                //NSLog(@"%@ Parana: %@", tid.calendarDay.date.longDateString, [tid.calendarDay GetTextEP:self.gstrings]);
                [str appendString:[tid.calendarDay GetTextEP:self.gstrings]];
                [str appendString:@"\n"];
                
                if (self.dispSettings.note_bf_today)
                {
                    UILocalNotification * note = [UILocalNotification new];
                    //note.alertTitle = @"GCAL Break fast";
                    note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                    note.timeZone = [NSTimeZone defaultTimeZone];
                    NSDateComponents * dc = [NSDateComponents new];
                    GCGregorianTime * tt = tid.calendarDay.date;
                    dc.timeZone = note.timeZone;
                    dc.year = tt.year;
                    dc.month = tt.month;
                    dc.day = tt.day;
                    dc.hour = (int)tid.calendarDay.hrEkadasiParanaStart;
                    dc.minute = (int)(tid.calendarDay.hrEkadasiParanaStart * 60) % 60;
                    note.fireDate = [calendar dateFromComponents:dc];
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"ParanaToday", @"GCALEvent", nil];
                    note.userInfo = infoDict;
                    note.alertAction = @"View Details";
                    note.soundName = UILocalNotificationDefaultSoundName;
                    [ma addObject:note];
                }
                if (self.dispSettings.note_bf_tomorrow)
                {
                    UILocalNotification * note = [UILocalNotification new];
                    //note.alertTitle = @"GCAL Break fast";
                    note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                    note.timeZone = [NSTimeZone defaultTimeZone];
                    NSDateComponents * dc = [NSDateComponents new];
                    GCGregorianTime * tt = tid.calendarDay.date;
                    dc.timeZone = note.timeZone;
                    dc.year = tt.year;
                    dc.month = tt.month;
                    dc.day = tt.day;
                    dc.hour = 19;
                    dc.minute = 0;
                    note.fireDate = [[calendar dateFromComponents:dc] dateByAddingTimeInterval:-86400];
                    //NSLog(@"fire date %@", note.fireDate);
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"ParanaTomorrow", @"GCALEvent", nil];
                    note.userInfo = infoDict;
                    note.alertAction = @"View Details";
                    note.soundName = UILocalNotificationDefaultSoundName;
                    note.hasAction = YES;
                    [ma addObject:note];
                }
            }
            
            

            
        }

        if (1)
        {
            julPage = julDay / 32;
            julPageIndex = julDay % 32;
            
            tid = [self.theEngine requestPage:julPage view:nil itemIndex:julPageIndex];
            NSLog(@"Final notification scheduled for %@", [tid.calendarDay.date longDateString]);
            
            UILocalNotification * note = [UILocalNotification new];
            //note.alertTitle = @"GCAL Break fast";
            note.alertBody = @"Run GCAL to generate calendar notifications for next 30 days.";
            note.timeZone = [NSTimeZone defaultTimeZone];
            NSDateComponents * dc = [NSDateComponents new];
            GCGregorianTime * tt = tid.calendarDay.date;
            dc.timeZone = note.timeZone;
            dc.year = tt.year;
            dc.month = tt.month;
            dc.day = tt.day;
            dc.hour = 7;
            dc.minute = 0;
            note.fireDate = [calendar dateFromComponents:dc];
            //NSLog(@"fire date %@", note.fireDate);
            NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"RunGCAL", @"GCALEvent", nil];
            note.userInfo = infoDict;
            note.alertAction = @"View Details";
            note.soundName = UILocalNotificationDefaultSoundName;
            note.hasAction = YES;
            [ma addObject:note];
        }
        
        [udef setDouble:[[NSDate date] timeIntervalSince1970] + 15*86400.0 forKey:@"nextFutureCalc"];
        [udef synchronize];
        
        [[UIApplication sharedApplication] setScheduledLocalNotifications:ma];
        
    }
    @catch (NSException *exception) {
    }
    @finally {
        self.defaultsChangesPending = NO;
    }
}

-(IBAction)onSwipeLeft:(id)sender
{
    GCGregorianTime * date = [[self.dayView attachedDate] nextDay];
    
    [self.mainViewCtrl showDateSingle:date];
}

-(IBAction)onSwipeRight:(id)sender
{
    GCGregorianTime * date = [[self.dayView attachedDate] previousDay];
    
    [self.mainViewCtrl showDateSingle:date];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.dispSettings writeToFile];
    [self.mainViewCtrl releaseDialogs];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"");
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.mainViewCtrl actionToday:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.dispSettings writeToFile];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    NSError *error = nil;
    if (managedObjectContext_ != nil)
    {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark -
#pragma mark OS Notification Center

- (void)applicationRegisterForLocalNotifications {
    UIApplication * app = [UIApplication sharedApplication];
    @try {
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            
            UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            
            [app registerUserNotificationSettings:mySettings];
            
//            self.lastNotificationDateTomorrow = @"";
//            self.lastNotificationDateToday = @"";
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

//-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    //NSLog(@"BACKGROUND FETCH WORKS");
//    completionHandler(UIBackgroundFetchResultNoData);
//    
//    GCGregorianTime * today = [GCGregorianTime today];
//    
//    NSString * key = [today longDateString];
//
//    // calculation for today only after 3 AM
//    if (today.shour >= 3/24.0 && ![self.lastNotificationDateToday isEqualToString:key])
//    {
//        NSString * notice = [self getTodayNotifications:today];
//        
//        if (notice)
//        {
//            NSString * date = [NSString stringWithFormat:@"%d.%d.%d", today.year, today.month, today.day];
//            [self scheduleNotificationWithItem:notice date:date];
//        }
//        self.lastNotificationDateToday = key;
//
//    }
//
//    // here get data for tomorrow
//    today = [today nextDay];
//    key = [today longDateString];
//
//    // calculation for tomorrow only after 9 AM
//    if (today.shour > 9/24.0 && ![self.lastNotificationDateTomorrow isEqualToString:key])
//    {
//        NSString * notice = [self getTomorrowNotifications:today];
//        
//        if (notice)
//        {
//            NSString * date = [NSString stringWithFormat:@"%d.%d.%d", today.year, today.month, today.day];
//            [self scheduleNotificationWithItem:notice date:date];
//        }
//        self.lastNotificationDateTomorrow = key;
//    }
//}

//-(NSString *)getTodayNotifications:(GCGregorianTime *)today
//{
//    int julDay = [today getJulianInteger];
//    int julPage = julDay / 32;
//    int julPageIndex = julDay % 32;
//    
//    GCTodayInfoData * data = [self.theEngine requestPageSynchronous:julPage itemIndex:julPageIndex];
//    NSMutableString * notice = [NSMutableString new];
//    [notice appendString:@"GCAL Today: "];
//    NSInteger initialLength = [notice length];
//    if (data.calendarDay.isEkadasiParana && self.dispSettings.note_bf_today)
//    {
//        [notice appendString:[data.calendarDay GetTextEP:self.gstrings]];
//    }
//    
//    for (GcDayFestival * fest in data.calendarDay.festivals) {
//        if ((fest.highlight == 1 || fest.highlight == 2) && (self.dispSettings.note_fd_today))
//        {
//            if ([notice length] > initialLength)
//            {
//                [notice appendString:@", "];
//            }
//            [notice appendString:fest.name];
//        }
//    }
//    
//    if (notice.length > initialLength)
//        return notice;
//    return nil;
//}
//
//-(NSString *)getTomorrowNotifications:(GCGregorianTime *)today
//{
//    int julDay = [today getJulianInteger];
//    int julPage = julDay / 32;
//    int julPageIndex = julDay % 32;
//    
//    GCTodayInfoData * data = [self.theEngine requestPageSynchronous:julPage itemIndex:julPageIndex];
//    NSMutableString * notice = [NSMutableString new];
//    [notice appendString:@"GCAL Tomorrow: "];
//    NSInteger initialLength = [notice length];
//    if (data.calendarDay.isEkadasiParana && self.dispSettings.note_bf_tomorrow)
//    {
//        [notice appendString:[data.calendarDay GetTextEP:self.gstrings]];
//    }
//    
//    for (GcDayFestival * fest in data.calendarDay.festivals) {
//        if ((fest.highlight == 1 || fest.highlight == 2) && (self.dispSettings.note_fd_tomorrow))
//        {
//            if ([notice length] > initialLength)
//            {
//                [notice appendString:@", "];
//            }
//            [notice appendString:fest.name];
//        }
//    }
//
//    if (notice.length > initialLength)
//        return notice;
//    return nil;
//}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *itemName = [notification.userInfo objectForKey:@"GCALEvent"];
    NSLog(@"In background ItemName: %@", itemName);
}

//- (void)scheduleNotificationWithItem:(NSString *)eventTitle date:(NSString *)date
//{
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    if (localNotif == nil)
//        return;
//    localNotif.fireDate = nil;
//    localNotif.timeZone = [NSTimeZone defaultTimeZone];
//    localNotif.alertBody = eventTitle;
//    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
//    
//    localNotif.soundName = UILocalNotificationDefaultSoundName;
//    localNotif.applicationIconBadgeNumber = 0;
//    
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", date, @"date", nil];
//    localNotif.userInfo = infoDict;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//}


#pragma mark -
#pragma mark User Actions

-(IBAction)onTodayButton:(id)sender
{
    GCGregorianTime * today = [GCGregorianTime today];
    [self showDate:today];
}

-(IBAction)onFindButton:(id)sender
{
    [self.mainViewCtrl onFindButton:sender];
}

-(IBAction)onSettingsButton:(id)sender
{
    [self.mainViewCtrl onSettingsButton:sender];
}


#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil)
    {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"BalaCal" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
	NSLog(@"Path to DataContext: %@\n", modelURL);
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GCalLoc" ofType:@"sqlite"]];
	
#ifdef GCAL_DEBUG_BUILD_LOCATIONS
	NSFileManager * fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtURL:storeURL error:NULL];
#endif
	
    NSError *error = nil;
    NSDictionary * storeOptions = @{NSReadOnlyPersistentStoreOption : @YES};
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
}




#pragma mark === location database ===

-(NSArray *)getLocationsRoot:(NSManagedObjectContext *)ctx
{
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	NSEntityDescription * ed = [NSEntityDescription entityForName:@"LGroup"
										   inManagedObjectContext:ctx];
	NSPredicate * prd = [NSPredicate predicateWithFormat:@"title = \"ROOT\""];
	
	[request setEntity:ed];
	[request setPredicate:prd];
	
	return [ctx executeFetchRequest:request error:NULL];
}

-(NSArray *)locSubgroupsForContextKey:(NSString *)strKey inContext:(NSManagedObjectContext *)ctx
{
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	NSEntityDescription * ed = [NSEntityDescription entityForName:@"LGroup"
										   inManagedObjectContext:ctx];
	NSPredicate * prd = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"parentCode = \"%@\"",strKey]];
	
	[request setEntity:ed];
	[request setPredicate:prd];
	
	return [ctx executeFetchRequest:request error:NULL];
}

-(NSArray *)locCitiesForContextKey:(NSString *)strKey inContext:(NSManagedObjectContext *)ctx
{
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	NSEntityDescription * ed = [NSEntityDescription entityForName:@"LCity"
										   inManagedObjectContext:ctx];
	NSPredicate * prd = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"parentCode = \"%@\"",strKey]];
	
	[request setEntity:ed];
	[request setPredicate:prd];
	
	return [ctx executeFetchRequest:request error:NULL];
}

-(void)setGpsLongitude:(double)longitude latitude:(double)latitude
				  city:(NSString *)inCity country:(NSString *)inCountry timeZone:(NSString *)inTimeZone
{
    [self.theEngine reset];
	self.myLocation.longitude = longitude;
	self.myLocation.latitude = latitude;
	self.myLocation.city = inCity;
	self.myLocation.country = inCountry;
	self.myLocation.timeZone = [NSTimeZone timeZoneWithName:inTimeZone];
	
	[self storeMyLocation];
	[self.mainViewCtrl actionNormalView:self];
//    if (self.scrollViewH.hidden == NO)
//        [self.scrollViewH reloadData];
    if (self.scrollViewD.hidden == NO)
        [self.dayView refreshDateAttachement];
    if (self.scrollViewV.hidden == NO)
        [self.scrollViewV reloadData];
    
    [self resetFutureNotifications];
}


-(void)initLocationsDb
{
	NSManagedObjectContext * ctx = [self managedObjectContext];
	
	// reload all items
	ADD_ALL_LOCATION_ITEMS(ctx);

	// save all items
	[ctx save:NULL];
}

-(void)setLocationData:(GcLocation *)locationdata
{
    self.myLocation.city = locationdata.city;
    self.myLocation.country = locationdata.country;
    self.myLocation.latitude = locationdata.latitude;
    self.myLocation.longitude = locationdata.longitude;
    self.myLocation.timeZone = locationdata.timeZone;
    
    [self storeMyLocation];
}


-(void)storeMyLocation
{
    self.dispSettings.locCity = self.myLocation.city;
    self.dispSettings.locCountry = self.myLocation.country;
    self.dispSettings.locLatitude = self.myLocation.latitude;
    self.dispSettings.locLongitude = self.myLocation.longitude;
    self.dispSettings.locTimeZone = [self.myLocation.timeZone name];
}

-(void)setViewMode:(NSInteger)sm
{
    if (sm == 0)
    {
        self.mainViewCtrl.scrollViewD.hidden = NO;
        self.mainViewCtrl.nextDay.hidden = NO;
        self.mainViewCtrl.prevDay.hidden = NO;
        self.mainViewCtrl.scrollViewV.hidden = YES;
    }
    else if (sm == 1)
    {
        self.mainViewCtrl.scrollViewD.hidden = YES;
        self.mainViewCtrl.nextDay.hidden = YES;
        self.mainViewCtrl.prevDay.hidden = YES;
        self.mainViewCtrl.scrollViewV.hidden = NO;
    }
}

-(void)showDate:(GCGregorianTime *)dateToShow
{
//    if (!self.scrollViewH.hidden)
//        [self.scrollViewH showDate:dateToShow];
    if (!self.scrollViewD.hidden)
    {
        [self.dayView attachDate:dateToShow];
        [self.dayView refreshDateAttachement];
        self.scrollViewD.contentOffset = CGPointZero;
        self.scrollViewD.contentSize = self.dayView.frame.size;
        [self.dayView setNeedsDisplay];
    }
    if (!self.scrollViewV.hidden)
        [self.scrollViewV showDate:dateToShow];

}

@end

