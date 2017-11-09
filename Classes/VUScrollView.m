//
//  VUScrollView.m
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import "VUScrollView.h"
#import "CalendarResultsView.h"
#import "gc_func.h"
#import "GCGregorianTime.h"
#import <QuartzCore/QuartzCore.h>

//#define CAL_PANE_WIDTH 500
#define CAL_PANE_HEIGHT 60


@implementation VUScrollView


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initMyOwn];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initMyOwn];
    }
    return self;
}

/*
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"redraw main rect %d", (int)self.desiredMovement.count);
    
    NSValue * lastDesire = nil;
    NSString * action = nil;
    BOOL repeatPaint = NO;
    
    [self.desiredMovementLock lock];
    if (self.desiredMovement.count > 0)
    {
        action = [self.desiredMovement objectAtIndex:0];
        [self.desiredMovement removeObjectAtIndex:0];
    }
    if ([action isEqualToString:@"move"])
    {
        if (self.desiredMovement.count > 0)
        {
            lastDesire = [self.desiredMovement objectAtIndex:0];
            [self.desiredMovement removeObjectAtIndex:0];
        }
    }
    // this should be the last check
    // in this lock / unlock block
    if (self.desiredMovement.count > 0)
    {
        repeatPaint = YES;
    }
    [self.desiredMovementLock unlock];

    if ([action isEqualToString:@"move"])
    {
        [self moveSubviews:lastDesire];
        CGPoint newDesire = [lastDesire CGPointValue];
        NSLog(@"LAST_CHANGE %f,%f", newDesire.x, newDesire.y);
        newDesire.x *= 0.99;
        newDesire.y *= 0.99;
        if (abs(newDesire.x) + abs(newDesire.y) > 2)
        {
            [self postMovement:newDesire];
        }
    }
    else if ([action isEqualToString:@"rearrange"])
    {
        [self rearrangeSubviewsInDirection];
        [self refreshAllViews];
    }
    
    if (repeatPaint)
    {
        [self setNeedsDisplay];
    }
}
*/

-(void)initMyOwn
{
    self.readyViews = [NSMutableArray new];
    self.visibleViews = [NSMutableArray new];
    self.readyViewsLock = [NSLock new];
    self.panGestures = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    self.isCreatingAnimation = NO;
    //self.rearrangeLock = [NSLock new];
    //self.desiredMovementLock = [NSLock new];
    //self.desiredMovement = [NSMutableArray new];
    self.speedratio = [[NSUserDefaults standardUserDefaults] doubleForKey:@"calendarspeed"];
    
    //TODO: add pinch gesture recognizer for resizing views
    
    [self addGestureRecognizer:self.panGestures];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    
    self.normalSubviewWidth = MIN(self.frame.size.width, self.frame.size.height);
}

-(void)dealloc
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void)defaultsChanged:(NSNotification *)notification {
    // Get the user defaults
    NSUserDefaults *defaults = (NSUserDefaults *)[notification object];
    
    self.speedratio = [defaults doubleForKey:@"calendarspeed"];
    if (self.speedratio < 1.0)
        self.speedratio = 1.0;
    else if (self.speedratio > 4.0)
        self.speedratio = 4.0;
    
}

//-(void)postMovement:(CGPoint)dx
//{
//    [self.desiredMovementLock lock];
//    [self.desiredMovement addObject:@"move"];
//    [self.desiredMovement addObject:[NSValue valueWithCGPoint:dx]];
//    [self.desiredMovementLock unlock];
//    
//    [self setNeedsDisplay];
//}

//-(void)postRearrange
//{
//    //[self setNeedsRealignFrames];
//    
//    [self.desiredMovementLock lock];
//    [self.desiredMovement removeObject:@"rearrange"];
//    [self.desiredMovement addObject:@"rearrange"];
//    [self.desiredMovementLock unlock];
//    
//    [self setNeedsDisplay];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(IBAction)handlePanGestures:(id)sender
{
    CGPoint current = [self.panGestures locationInView:self];
    CGPoint diff;
    
    if (self.panGestures.state == UIGestureRecognizerStateBegan)
    {
        [self.layer removeAllAnimations];
        
        //NSLog(@"state BEGAN, pos %f,%f", current.x, current.y);
        self.startPoint = current;
        self.startView = nil;
        for (UIView * view in self.subviews) {
            if (CGRectContainsPoint(view.frame, current))
            {
                self.startView = (CalendarResultsView *)view;
                self.startRect = view.frame;
                break;
            }
        }
        self.lastDiff = CGPointZero;
        self.lastPoint = current;
        self.lastChangedDirection = NO;
    }
    else if (self.panGestures.state == UIGestureRecognizerStateChanged)
    {
        diff = CGPointMake(0, (current.y - self.lastPoint.y)*self.speedratio);
        self.lastPoint = current;
        if (diff.y * self.lastDiff.y <= -1)
            self.lastChangedDirection = YES;
        self.lastDiff = diff;
        
        [self moveSubviews:[NSValue valueWithCGPoint:diff]];
        
        [self checkDateViewsLayout];
    }
    else if (self.panGestures.state == UIGestureRecognizerStateEnded)
    {

    }
    else if (self.panGestures.state == UIGestureRecognizerStateFailed)
    {
        NSLog(@"state FAIL, pos %f,%f", current.x, current.y);
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //[self setNeedsRealignFrames];
    [self rearrangeSubviewsInDirection];
    [self checkDateViewsLayout];
}

-(void)moveSubviews:(NSValue *)diffValue
{
    CGPoint diff = [diffValue CGPointValue];
    CGFloat minX = 0;
    CGFloat maxX = 0;
    
//    if (self.frame.size.width > CAL_PANE_WIDTH)
//    {
//        minX = (self.frame.size.width - CAL_PANE_WIDTH) / 2;
//        maxX = minX;
//    }
//    else
//    {
//        minX = self.frame.size.width - CAL_PANE_WIDTH;
//        maxX = 0;
//    }
    
    CGFloat currentTop = 0;
    UIView * firstView = [[self subviews] objectAtIndex:0];
    if (firstView != nil)
    {
        currentTop = firstView.frame.origin.y;
    }
    
    for (CalendarResultsView * view in self.subviews) {
        CGRect nf = CGRectOffset(view.frame, diff.x, diff.y);

        if (nf.origin.x < minX)
            nf.origin.x = minX;
        if (nf.origin.x > maxX)
            nf.origin.x = maxX;
        
        /*nf.origin.y = currentTop;
        currentTop += view.drawBottom;*/
        
        view.frame = nf;
    }
    
    //[self rearrangeSubviews:nil];
    
}

-(void)reloadData
{
    for (CalendarResultsView * view in self.visibleViews) {
        [view refreshDateAttachement];
    }
}

-(void)adjustWidth:(CGFloat)width
{
    UIView * v = [self.visibleViews objectAtIndex:0];
    
    if (v != nil)
    {
        CGFloat currPos = v.frame.origin.x;
        CGFloat currWidth = v.frame.size.width;
        
        CGFloat minX = 0;
        CGFloat maxX = 0;
        
        if (width < currWidth)
        {
            minX = width - currWidth;
            maxX = 0;
        }
        else
        {
            minX = (width - currWidth) / 2;
            maxX = minX;
        }
        
        if (currPos < minX)
        {
            [self moveSubviews:[NSValue valueWithCGSize:CGSizeMake(minX - currPos, 0)]];
        }
        else if (maxX < currPos)
        {
            [self moveSubviews:[NSValue valueWithCGSize:CGSizeMake(maxX - currPos, 0)]];
        }
    }
}



-(CalendarResultsView *)getFreeView:(CGRect)desiredFrame
{
    /*int freec = [self.readyViews count];
    int nonfreec = [self.visibleViews count];
    
    NSLog(@"- GETFREEVIEW ---------");
    NSLog(@"  - free views  %d", freec);
    NSLog(@"  - nonfree vs  %d", nonfreec);
    NSLog(@"           SUM  %d", freec + nonfreec);
    NSLog(@"-----------------------");*/
    
    for (CalendarResultsView * sv in self.readyViews) {
        if (sv.data == nil)
        {
            sv.frame = desiredFrame;
      //      NSLog(@"getFreeView --- view reused");
            return sv;
        }
    }
    
    CalendarResultsView * nv = [[CalendarResultsView alloc] initWithFrame:desiredFrame];
//    nv.viewState = DRV_MODE_FREE;
    nv.backgroundColor = [UIColor whiteColor];
    nv.engine = self.engine;
    nv.scrollParent = self;
    //nv.hidden = NO;
    [self.readyViews addObject:nv];
    
    //[self bringSubviewToFront:nv];
    //NSLog(@"getFreeView --- view created");
    return nv;
}

-(CGRect)getCenterFrame
{
    return CGRectMake(0, 0, self.normalSubviewWidth, CAL_PANE_HEIGHT);
}

-(void)showDate:(GCGregorianTime *)date
{
    // locking views array
    [self.readyViewsLock lock];
    
    // remove views from chain
    while(self.subviews.count > 0)
    {
        CalendarResultsView * drv = self.subviews[0];
        [drv detachDate];
        drv.nextPane = nil;
        drv.prevPane = nil;
        drv.data = nil;
//        drv.viewState = DRV_MODE_FREE;
        [drv removeFromSuperview];
    }
    
    [self.readyViews addObjectsFromArray:self.visibleViews];
    [self.visibleViews removeAllObjects];
    
    // add new view and place it in the center
    CalendarResultsView * d = [self getFreeView:[self getCenterFrame]];
    [self.readyViews removeObjectIdenticalTo:d];
    [self.visibleViews addObject:d];
    [d attachDate:date];
    [d addToContainer:self];
    
    [self checkDateViewsLayout];
    
    [self.readyViewsLock unlock];
    // now, views are again free
    
}

//
// this will check if whole width of screen is covered by date views
// if not, creates miissing one
//
-(void)checkDateViewsLayout
{
    self.isCreatingAnimation = YES;
    
    if (self.visibleViews.count > 0)
    {
        CalendarResultsView * minView = [self.visibleViews objectAtIndex:0];
        while (minView.frame.origin.y >= -CAL_PANE_HEIGHT)
        {
            minView = [self addPaneAbove:minView];
        }
        
        minView = [self.visibleViews objectAtIndex:0];
        //NSLog(@"minView pos x %f", minView.frame.origin.y);
        while(minView.frame.origin.y < -CAL_PANE_HEIGHT * 5)
        {
            if (minView.nextPane != nil)
            {
                minView.nextPane.prevPane = nil;
            }
            minView.nextPane = nil;
            minView.prevPane = nil;
            minView.data = nil;
            minView.frame = CGRectOffset(minView.frame, 2000, 0);
//            minView.viewState = DRV_MODE_FREE;
            [self.visibleViews removeObjectAtIndex:0];
            [self.readyViews addObject:minView];
            minView = [self.visibleViews objectAtIndex:0];
            //NSLog(@"A minView pos x %f", minView.frame.origin.y);
        }
        
        CalendarResultsView * maxView = [self.visibleViews lastObject];
        while (maxView.frame.origin.y + maxView.frame.size.height < self.frame.size.height + CAL_PANE_HEIGHT)
        {
            maxView = [self addPaneBellow:maxView];
            NSLog(@"added below view Y = %f, height = %f, date = %@", maxView.frame.origin.y, maxView.frame.size.height,
                  [maxView.attachedDate longDateString]);
        }
        
        maxView = [self.visibleViews lastObject];
        while(maxView.frame.origin.y > self.frame.size.height + CAL_PANE_HEIGHT * 6)
        {
            if (maxView.prevPane != nil)
            {
                maxView.prevPane.nextPane = nil;
            }
            maxView.prevPane = nil;
            maxView.nextPane = nil;
            maxView.data = nil;
//            maxView.viewState = DRV_MODE_FREE;
            maxView.frame = CGRectOffset(maxView.frame, 2000, 0);
            [self.visibleViews removeLastObject];
            [self.readyViews addObject:maxView];
            maxView = [self.visibleViews lastObject];
        }
    }
    
    self.isCreatingAnimation = NO;
}

- (CalendarResultsView *)addPaneAbove:(CalendarResultsView *)pane
{
    CGFloat minOffset = pane.frame.size.height;
    if (minOffset < 40)
        minOffset = 40;
    CalendarResultsView * d = [self getFreeView:pane.frame];
    [self.readyViews removeObjectIdenticalTo:d];
    [self.visibleViews insertObject:d atIndex:0];
    GCGregorianTime * firstDate = [pane attachedDate];
    [d attachDate:[firstDate previousDay]];
    [self insertSubview:d atIndex:0];
    d.nextPane = pane;
    pane.prevPane = d;

    CGRect newRect = d.frame;
    newRect.origin.y -= newRect.size.height;
    d.frame = newRect;
    
    return d;
}

- (CalendarResultsView *)addPaneBellow:(CalendarResultsView *)pane
{
    CGFloat minOffset = pane.frame.size.height;
    if (minOffset < 40)
        minOffset = 40;
    CalendarResultsView * d = [self getFreeView:CGRectOffset(pane.frame, 0, minOffset)];
    [self.readyViews removeObjectIdenticalTo:d];
    [self.visibleViews addObject:d];
    GCGregorianTime * firstDate = [pane attachedDate];
    [d attachDate:[firstDate nextDay]];
    [self insertSubview:d atIndex:0];
    
    pane.nextPane = d;
    d.prevPane = pane;
    return d;
}

-(void)paneDidMove:(CalendarResultsView *)pane
{
    if (self.isCreatingAnimation)
        return;
    
    if (pane.prevPane == nil || pane.nextPane == nil)
    {
        if ([self.readyViewsLock tryLock])
        {
            [self checkDateViewsLayout];
            [self.readyViewsLock unlock];
        }
    }
}

-(void)refreshAllViews
{
    for (CalendarResultsView * view in self.visibleViews) {
        [view setNeedsDisplay];
    }
}

//-(void)setNeedsRealignFrames
//{
//    NSInteger a = 0;
//    [self.rearrangeLock lock];
//    a = self.rearrangeCounter;
//    self.rearrangeCounter++;
//    NSNumber * num = [NSNumber numberWithInteger:self.rearrangeCounter];
//    [self.rearrangeLock unlock];
//
//    if (a == 0)
//    {
//        [self performSelector:@selector(rearrangeSubviews:) withObject:num afterDelay:0.1];
//    }
//}

- (void)rearrangeSubviewsInDirection
{
    //NSLog(@"DO REARRANGE");

    
    NSLog(@"Last movement direction is : %f", self.lastDiff.y);
    
    if (self.lastDiff.y > 0)
    {
        CalendarResultsView * view = [self.visibleViews lastObject];
        while(view != nil)
        {
            if (view.nextPane != nil)
            {
                CGRect thisRect = view.frame;
                CGRect nextRect = view.nextPane.frame;
                thisRect.origin.y = nextRect.origin.y - thisRect.size.height;
                view.frame = thisRect;
            }
            view = (CalendarResultsView *)view.prevPane;
        }
    }
    else
    {
        for (CalendarResultsView * view in self.visibleViews) {
            if (view.prevPane != nil)
            {
                CGRect f = view.frame;
                CGRect prevRect = view.prevPane.frame;
                f.origin.y = prevRect.origin.y + prevRect.size.height;
                view.frame = f;
            }
            NSLog(@"VIEWFRAME   %@     %f  %f %p", view.attachedDate.longDateString, view.frame.origin.y, view.frame.size.height, view.prevPane);
        }
    }
        
/*        if (f.origin.y + f.size.height > 0)
        {
            if (currY < -9000)
                currY = f.origin.y;
            f.origin.y = currY;
            if (abs(f.size.height - view.drawBottom) > 1)
                redraw = YES;
            f.size.height = view.drawBottom;
            currY += view.drawBottom;
            view.frame = f;
        }*/
        
        /*if (redraw)
        {
            [view setNeedsDisplay];
            redraw = NO;
        }
    }*/
}

//-(void)rearrangeSubviews:(NSNumber *)num
//{
//    [self.rearrangeLock lock];
//    NSInteger a = self.rearrangeCounter;
//    [self.rearrangeLock unlock];
//    
//    if (a == [num integerValue])
//    {
//        NSLog(@"VIEW REARRANGING");
//        [self rearrangeSubviewsInDirection];
//        [self.rearrangeLock lock];
//        self.rearrangeCounter = 0;
//        [self.rearrangeLock unlock];
//    }
//    else
//    {
//        NSLog(@"POSPONE REARRANGE");
//        [self performSelector:@selector(rearrangeSubviews:) withObject:[NSNumber numberWithInteger:a] afterDelay:0.2];
//    }
//}



@end
