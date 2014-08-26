//
//  SettingsViewTableController.h
//  GCAL
//
//  Created by Peter Kollath on 8/8/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "gcalAppDisplaySettings.h"
#import "LGroup.h"

#define kMySettingNoneType    0
#define kMySettingDirType     1
#define kMySettingSwitchType  2

@interface SettingsViewTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{

	UITableView * theTableView;
	NSArray * theSettings;
	gcalAppDisplaySettings * appDispSettings;
	UINavigationController * navigParent;
}

@property (nonatomic, retain) UITableView * theTableView;
@property (nonatomic, retain) NSArray * theSettings;
@property (nonatomic, retain) gcalAppDisplaySettings * appDispSettings;


-(void)setNavigParent:(UINavigationController *)navig;
-(UINavigationController *)navigParent;
-(IBAction)switchValueChanged:(id)sender;
-(LGroup *)rootLocationGroup;



@end
