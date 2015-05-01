//
//  GCEngine.h
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import <Foundation/Foundation.h>

@class GCTodayInfoData;
@class DayResultsView;
@class GcLocation;
@class GCStrings;
@class GCDisplaySettings;
@class ResultsViewBase;

@interface GCEngine : NSObject

@property (strong) NSLock * pagesLock;
@property (strong) NSMutableArray * pages;
@property IBOutlet GcLocation * myLocation;
@property IBOutlet GCStrings * myStrings;
@property IBOutlet GCDisplaySettings * theSettings;
@property NSMutableDictionary * styles;

@property UIColor * highlightedText;
@property UIColor * basicText;
@property UIColor * invertedText;
@property UIColor * h1Background;
@property UIColor * h2Background;
@property UIColor * h3Background;
@property UIColor * sunTimesBackground;
@property UIColor * backgroundColor;
@property UIColor * subheaderBackground;


-(GCTodayInfoData *)requestPage:(int)pageNo view:(ResultsViewBase *)view itemIndex:(int)index;
-(GCTodayInfoData *)requestPageSynchronous:(int)pageNo itemIndex:(int)index;
-(void)reset;

@end
