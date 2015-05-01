//
//  GCCoreEvent.h
//  GCAL
//
//  Created by Peter Kollath on 01/03/15.
//
//

#import <Foundation/Foundation.h>

#define CET_SUNRISE  1
#define CET_NOON     2
#define CET_SUNSET   3
#define CET_ARUNODAYA 4
#define CET_NAKSATRA 5
#define CET_TITHI    6

@interface GCCoreEvent : NSObject

@property int seconds;
@property int type;
@property (copy) NSString * text;
@property BOOL daylightSavingTime;

@end
