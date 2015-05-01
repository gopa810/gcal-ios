//
//  SettingsViewTableController.h
//  GCAL
//
//  Created by Peter Kollath on 8/8/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GCDisplaySettings.h"
#import "LGroup.h"

#define kMySettingNoneType       0
#define kMySettingDirType        1
#define kMySettingSwitchType     2
#define kMySettingMultivalueType 3
#define kMySettingSubtitled      4


@interface SettingsViewTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{

	UITableView * theTableView;
	NSArray * theSettings;
	GCDisplaySettings * appDispSettings;
	UINavigationController * navigParent;
}

@property (strong) NSString * masterKeyIdentity;
@property (nonatomic, strong) UITableView * theTableView;
@property (nonatomic, strong) NSArray * theSettings;
@property (nonatomic, strong) NSArray * notifExtUpd;
@property (nonatomic, strong) GCDisplaySettings * appDispSettings;


-(void)setNavigParent:(UINavigationController *)navig;
-(UINavigationController *)navigParent;
-(IBAction)switchValueChanged:(id)sender;
-(LGroup *)rootLocationGroup;



@end
