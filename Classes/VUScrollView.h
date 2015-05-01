//
//  VUScrollView.h
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import <UIKit/UIKit.h>
#import "GCEngine.h"

@class CalendarResultsView;
@class GCGregorianTime;


@interface VUScrollView : UIView

@property CGFloat speedratio;
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
@property (weak) CalendarResultsView * startView;
@property CGRect startRect;
//@property NSLock * rearrangeLock;
//@property NSInteger rearrangeCounter;
//@property NSMutableArray * desiredMovement;
//@property NSLock * desiredMovementLock;
@property CGFloat normalSubviewWidth;

-(void)showDate:(GCGregorianTime *)date;
-(CalendarResultsView *)getFreeView:(CGRect)desiredFrame;

-(void)paneDidMove:(CalendarResultsView *)pane;
-(void)refreshAllViews;
//-(void)setNeedsRealignFrames;
-(void)moveSubviews:(NSValue *)diffValue;
-(void)adjustWidth:(CGFloat)width;
-(void)postMovement:(CGPoint)dx;
//-(void)postRearrange;
-(void)reloadData;

@end
