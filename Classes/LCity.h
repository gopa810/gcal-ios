//
//  LCity.h
//  GCAL
//
//  Created by Peter Kollath on 8/11/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LCity : NSManagedObject {

	NSNumber * latitude;
	NSNumber * longitude;
	NSString * title;
	NSString * tzone;
	
}

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * tzone;
@end
