//
//  GcResultCalendar.h
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import <CalendarStore/CalendarStore.h>
#import "gc_const.h"
#import "gc_dtypes.h"
#import "GcLocation.h"
#import "gcalAppDisplaySettings.h"
#import "GCStrings.h"
#import "GcDay.h"
// #import "asyncCalendExport.h"

@interface GcResultCalendar : NSObject {
	IBOutlet GcLocation * m_Location;
	IBOutlet GCStrings  * gstr;
	NSMutableArray * events;
	IBOutlet gcalAppDisplaySettings * disp;
	NSMutableArray * m_pData;
	
	gc_time m_vcStart;
	int m_nCount;
	int m_PureCount;
	int m_vcCount;
}


@property(assign) gc_time m_vcStart;
@property(assign) int m_nCount;
@property(assign) int m_PureCount;
@property(assign) int m_vcCount;
//@property(assign) int nBeg;
//@property(assign) int nTop;

-(void)freeEvents;
-(void)ResolveFestivalsFasting:(int)i;
-(int)FindDate:(gc_time)vc;
//-(BOOL)IsFestivalDay:(GcDay *)yesterday nextDay:(GcDay *)today ofTithi:(int)nTithi;
-(GcDay *)GetDay:(int)nIndex;
-(int)MahadvadasiCalc:(int)nIndex location:(gc_earth)earth;
-(int)CompleteCalc:(int)nIndex location:(gc_earth)earth;
-(int)EkadasiCalc:(int)nIndex location:(gc_earth)earth;
-(int)ExtendedCalc:(int)nIndex location:(gc_earth)earth;
-(int)CalculateCalendar:(gc_time)begDate count:(int)iCount;
-(BOOL)IsMhd58:(int)nIndex type:(int *)nMahaType;
-(BOOL)NextNewFullIsVriddhi:(int)nIndex location:(gc_earth)earth;
-(id)init;
-(void)dealloc;
-(void)recalc;

-(void)appendCalendarColumnsHeader:(NSMutableString *)str format:(int)iFormat;
-(NSString *)formatCalendarXml;
-(NSString *)formatCalendarHTML;
//-(NSString *)formatCalendarHtmlTable;
-(NSString *)formatCalendarPlainText;
-(NSString *)formatCalendarRtf;
-(GcDayFestival *)GetSpecFestivalRecord:(int)i forClass:(int)inClass;

@end
