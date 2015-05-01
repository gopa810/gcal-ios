//
//  GcStringRec.h
//  gcal
//
//  Created by Gopal on 9.3.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GcStringRec : NSObject {
	NSString * text;
	int index;
	NSString * desc;
}

@property (strong, readwrite) NSString * text;
@property (assign) int index;
@property (strong, readwrite) NSString * desc;

@end
