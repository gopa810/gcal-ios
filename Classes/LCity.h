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

@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * tzone;
@end
