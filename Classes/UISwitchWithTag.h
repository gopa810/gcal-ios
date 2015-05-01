//
//  UISwitchWithTag.h
//  GCAL
//
//  Created by Peter Kollath on 8/11/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UISwitchWithTag : UISwitch {

	NSString * strTag;
}

@property (strong, readwrite) NSString * strTag;

@end
