//
//  GcResultToday.h
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCStrings.h"
#import "gcalAppDisplaySettings.h"
#import "GcResultCalendar.h"
#import "GcLocation.h"
#import "gc_dtypes.h"

@interface GcResultToday : NSObject {
	IBOutlet GCStrings  * gstr;
	IBOutlet gcalAppDisplaySettings * disp;
	IBOutlet GcResultCalendar * calend;
	IBOutlet GcLocation * myLocation;
	
	gc_time current;

	int timeInDST;
	int ab;
	int bc;
	int cd;
	gc_time titA;
	gc_time titB;
	gc_time titC;
	gc_time titD;

	int nak_ab;
	int nak_bc;
	int nak_cd;
	gc_time nakA;
	gc_time nakB;
	gc_time nakC;
	gc_time nakD;
}


@property(assign) gc_time current;

-(gcalAppDisplaySettings *)disp;
-(void)recalc;
-(void)calcDate:(gc_time)vc;
-(void)setDay:(gc_time)vc;
-(NSString *)formatTodayHtml;
-(NSString *)formatTodayText;
-(NSString *)formatInitialHtml;

-(void)setNextDay;
-(void)setPrevDay;

@end
