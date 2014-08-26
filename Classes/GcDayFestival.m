//
//  GcDayFestival.m
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GcDayFestival.h"


@implementation GcDayFestival

@synthesize group;
@synthesize name;
@synthesize fast;
@synthesize fastSubj;
@synthesize used;
@synthesize visible;
@synthesize tithi;
@synthesize masa;
@synthesize spec;

-(id)init
{
	if ((self = [super init]) != nil) {
		[self clear];
	}
	return self;
}

-(id)initWithDayFestival:(GcDayFestival *)src
{
	if ((self = [super init]) != nil) {
		self.fast = src.fast;
		self.name = [NSString stringWithString:src.name];
		self.group = src.group;
		self.fastSubj = [NSString stringWithString:src.fastSubj];
		self.used = src.used;
		self.visible = src.visible;
		self.spec = src.spec;
		self.tithi = src.tithi;
		self.masa = src.masa;
	}
	return self;
}


-(void)clear
{
	self.fast = 0;
	self.name = @"";
	self.group = 0;
	self.fastSubj = @"";
	self.used = NO;
	self.visible = NO;
	self.spec = 0;
	self.tithi = 0;
	self.masa = 0;
}

-(id)copyWithZone:(NSZone *)zone
{
	GcDayFestival * gcd = [[GcDayFestival allocWithZone:zone] initWithDayFestival:(GcDayFestival *)self];
	
	return gcd;
}

@end
