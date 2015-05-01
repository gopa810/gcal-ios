//
//  GcDayFestival.h
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GcDayFestival : NSObject <NSCopying>{
	int group;
	NSString * name;
	int fast;
	NSString * fastSubj;
	BOOL used;
	BOOL visible;
	int tithi;
	int masa;
	int spec;
}

@property (assign) int group;
@property (strong,readwrite) NSString * name;
@property (assign) int fast;
@property (strong,readwrite) NSString * fastSubj;
@property (assign) BOOL used;
@property (assign) BOOL visible;
@property (assign) int tithi;
@property (assign) int masa;
@property (assign) int spec;
@property int highlight;

-(id)initWithDayFestival:(GcDayFestival *)src;
-(void)clear;

@end
