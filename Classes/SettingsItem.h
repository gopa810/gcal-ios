//
//  SettingsItem.h
//  GCAL
//
//  Created by Peter Kollath on 8/10/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsItem : NSObject {
	BOOL checked;
	NSString * title;
	NSInteger type;
	NSString * tag;
	NSArray * nodes;
}

@property (assign) BOOL checked;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * tag;
@property (assign) NSInteger type;
@property (nonatomic, retain) NSArray * nodes;

-(id)initWithTitle:(NSString *)strTitle;


@end

SettingsItem * MakeSettingsItem(NSString * iTitle, int iType, BOOL iOn, NSString * tag);
SettingsItem * MakeSettingsDir(NSString * iTitle, NSArray * arr);
