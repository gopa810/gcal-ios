//
//  GCStrings.h
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gc_dtypes.h"
#define GCAL_MAX_GSTRINGS 1024

//@class GcDayFestival;
@class gcalAppDisplaySettings;

@interface GCStrings : NSObject {
//	IBOutlet NSArrayController * _gstr;
	NSString * _mapped[GCAL_MAX_GSTRINGS];
//	NSString * _descr[GCAL_MAX_GSTRINGS];
}

-(void)initGlobalStrings;
-(void)prepareStrings;
-(void)clearMappedStrings;
-(BOOL)correctIndex:(int)nIndex;
-(NSString *)string:(int)nIndex;
-(NSString *)hoursToString:(double)shour;
-(NSString *)timeToString:(gc_time)time;
-(NSString *)fullDateString:(gc_time)time withHours:(double)shour;
-(NSString *)daytimeToString:(gc_daytime)time;
-(NSString *)timeShortToString:(gc_time)time;
-(NSString *)dateToString:(gc_time)time;
-(NSString *)dateShortToString:(gc_time)time;
-(NSString *)GetTithiName:(int)i;
-(NSString *)GetMonthAbr:(int)n;
-(NSString *)GetDSTSignature:(int)nDST;
-(NSString *)GetNaksatraName:(int)n;
-(NSString *)GetNaksatraChildSylable:(int)n forPada:(int)pada;
-(NSString *)GetRasiChildSylable:(int)n;
-(NSString *)GetYogaName:(int)n;
-(NSString *)GetSankrantiName:(int)i;
-(NSString *)GetSankrantiNameEn:(int)i;
-(char)GetPaksaChar:(int)i;
-(NSString *)GetPaksaName:(int)i;
-(NSString *)GetMasaName:(int)i;
-(NSString *)GetMahadvadasiName:(int)i;
-(NSString *)GetSpecFestivalName:(int)i;
-(NSString *)GetFastingName:(int)i;
-(NSString *)GetEkadasiName:(int)nMasa forPaksa:(int)nPaksa;
-(NSString *)GetVersionText;
-(NSString *)GetTextLatitude:(double)d;
-(NSString *)GetTextLongitude:(double)d;
-(NSString *)GetTextTimeZone:(double)d;
//-(GcDayFestival *)GetSpecFestivalRecord:(int)i forClass:(int)inClass;
-(void)appendRtfHeader:(NSMutableString *)m_text;
-(void)appendColorTable:(NSMutableString *)str;
-(void)addNoteRtf:(NSMutableString *)str display:(gcalAppDisplaySettings *)disp;
-(void)addHtmlStylesDef:(NSMutableString *)xml display:(gcalAppDisplaySettings *)disp;



@end
