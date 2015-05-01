//
//  CalendarResultsView.h
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import <UIKit/UIKit.h>
#import "GCTodayInfoData.h"
#import "GCEngine.h"
#import "ResultsViewBase.h"


@class GCGregorianTime;
@class VUScrollView;

@interface CalendarResultsView : ResultsViewBase

@property (weak) VUScrollView * scrollParent;

@end
