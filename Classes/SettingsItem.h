//
//  SettingsItem.h
//  GCAL
//
//  Created by Peter Kollath on 8/10/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsItem : NSObject {

}

@property (assign) BOOL checked;
@property (assign) NSInteger type;
@property (strong) NSString * title;
@property (strong) NSString * tag;
@property (strong) NSArray * nodes;
@property (strong) NSString * subtitle;

-(id)initWithTitle:(NSString *)strTitle;


@end

SettingsItem * MakeSettingsItem(NSString * iTitle, int iType, BOOL iOn, NSString * tag);
SettingsItem * MakeSettingsItemEx(NSString * iTitle, NSString * iSubtitle, NSString * iTag);
SettingsItem * MakeSettingsDir(NSString * iTitle, NSArray * arr);
SettingsItem * MakeSettingsDirEx(NSString * iTitle, NSArray * arr, NSString * tag);
