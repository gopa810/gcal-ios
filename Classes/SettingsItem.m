//
//  SettingsItem.m
//  GCAL
//
//  Created by Peter Kollath on 8/10/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "SettingsItem.h"


@implementation SettingsItem

@synthesize type;
@synthesize title;
@synthesize checked;
@synthesize tag;
@synthesize nodes;

-(id)initWithTitle:(NSString *)strTitle
{
	if ((self = [super init]) != nil)
	{
		title = strTitle;
		nodes = nil;
		tag = nil;
		checked = NO;
		type = 0;
	}
	
	return self;
}

@end


SettingsItem * MakeSettingsItem(NSString * iTitle, int iType, BOOL iOn, NSString * iTag)
{
	SettingsItem * p = [[[SettingsItem alloc] initWithTitle:iTitle] autorelease];
	p.tag = iTag;
	p.checked = iOn;
	p.type = iType;
	return p;
}

SettingsItem * MakeSettingsDir(NSString * iTitle, NSArray * arr)
{
	SettingsItem * p = [[[SettingsItem alloc] initWithTitle:iTitle] autorelease];
	p.nodes = arr;
	return p;
}
