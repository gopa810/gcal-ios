//
//  LocationViewTableController.h
//  GCAL
//
//  Created by Peter Kollath on 8/11/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGroup.h"
#import "LCity.h"


@interface LocationViewTableController : UITableViewController {

	UINavigationController * navigParent;
	NSString * content;
	NSArray * contGroups;
	NSArray * contCities;

}

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSArray * contGroups;
@property (nonatomic, retain) NSArray * contCities;

-(void)setNavigParent:(UINavigationController *)navig;
-(UINavigationController *)navigParent;

-(void)setContentArrays:(NSString *)grp;


@end
