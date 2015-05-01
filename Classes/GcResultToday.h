//
//  GcResultToday.h
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCStrings.h"
#import "GCDisplaySettings.h"
#import "GcResultCalendar.h"
#import "GcLocation.h"
#import "gc_dtypes.h"

@class GCGregorianTime;

@interface GcResultToday : NSObject {
	IBOutlet GCStrings  * gstr;
	IBOutlet GCDisplaySettings * disp;
	IBOutlet GcResultCalendar * calend;
	IBOutlet GcLocation * myLocation;
	
	int timeInDST;
	int ab;
	int bc;
	int cd;

	int nak_ab;
	int nak_bc;
	int nak_cd;
}


@property (copy) GCGregorianTime * current;
@property (copy) GCGregorianTime * titA;
@property (copy) GCGregorianTime * titB;
@property (copy) GCGregorianTime * titC;
@property (copy) GCGregorianTime * titD;
@property (copy) GCGregorianTime * nakA;
@property (copy) GCGregorianTime * nakB;
@property (copy) GCGregorianTime * nakC;
@property (copy) GCGregorianTime * nakD;

-(GCDisplaySettings *)disp;
-(void)recalc;
-(void)calcDate:(GCGregorianTime *)vc;
-(void)setDay:(GCGregorianTime *)vc;
-(NSString *)formatTodayHtml;
-(NSString *)formatTodayText;
-(NSString *)formatInitialHtml;

-(void)setNextDay;
-(void)setPrevDay;

@end
