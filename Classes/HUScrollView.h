//
//  HUScrollView.h
//  GCAL
//
//  Created by Peter Kollath on 24/02/15.
//
//

#import <UIKit/UIKit.h>
#import "GCEngine.h"

@class DayResultsView;
@class GCGregorianTime;

@interface HUScrollView : UIView <UIGestureRecognizerDelegate>

@property IBOutlet GCEngine * engine;
@property NSMutableArray * readyViews;
@property NSMutableArray * visibleViews;
@property NSLock * readyViewsLock;
@property UIPanGestureRecognizer * panGestures;
@property CGPoint startPoint;
@property CGPoint lastPoint;
@property CGPoint lastDiff;
@property BOOL lastChangedDirection;
@property BOOL isCreatingAnimation;
@property (weak) DayResultsView * startView;
@property CGRect startRect;

-(void)showDate:(GCGregorianTime *)date;
-(DayResultsView *)getFreeView:(CGRect)desiredFrame;
-(void)reloadData;

-(void)paneDidMove:(DayResultsView *)pane;
-(void)refreshAllViews;

@end
