//
//  SettingsItem.m
//  GCAL
//
//  Created by Peter Kollath on 8/10/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "SettingsItem.h"


@implementation SettingsItem

-(id)initWithTitle:(NSString *)strTitle
{
	if ((self = [super init]) != nil)
	{
		self.title = strTitle;
		self.nodes = nil;
		self.tag = nil;
		self.checked = NO;
		self.type = 0;
	}
	
	return self;
}

@end


SettingsItem * MakeSettingsItem(NSString * iTitle, int iType, BOOL iOn, NSString * iTag)
{
	SettingsItem * p = [[SettingsItem alloc] initWithTitle:iTitle];
	p.tag = iTag;
	p.checked = iOn;
	p.type = iType;
	return p;
}

SettingsItem * MakeSettingsItemEx(NSString * iTitle, NSString * iSubtitle, NSString * iTag)
{
    SettingsItem * p = [[SettingsItem alloc] initWithTitle:iTitle];
    p.tag = iTag;
    p.subtitle = iSubtitle;
    p.type = 4;
    return p;
}

SettingsItem * MakeSettingsDir(NSString * iTitle, NSArray * arr)
{
	SettingsItem * p = [[SettingsItem alloc] initWithTitle:iTitle];
	p.nodes = arr;
	return p;
}

SettingsItem * MakeSettingsDirEx(NSString * iTitle, NSArray * arr, NSString * tag)
{
    SettingsItem * p = [[SettingsItem alloc] initWithTitle:iTitle];
    p.nodes = arr;
    p.tag = tag;
    return p;
}
