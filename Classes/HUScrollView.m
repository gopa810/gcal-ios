//
//  HUScrollView.m
//  GCAL
//
//  Created by Peter Kollath on 24/02/15.
//
//

#import "HUScrollView.h"
#import "DayResultsView.h"
#import "gc_func.h"
#import "GCGregorianTime.h"

#define CAL_PANE_WIDTH 320
#define CAL_PANE_HEIGHT 768

@implementation HUScrollView


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

-(void)initMyOwn
{
    self.readyViews = [NSMutableArray new];
    self.visibleViews = [NSMutableArray new];
    self.readyViewsLock = [NSLock new];
    self.panGestures = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    self.isCreatingAnimation = NO;
    
    //TODO: add pinch gesture recognizer for resizing views
    
    [self addGestureRecognizer:self.panGestures];
}

-(IBAction)handlePanGestures:(id)sender
{
    CGPoint current = [self.panGestures locationInView:self];
    CGPoint diff;
    
    if (self.panGestures.state == UIGestureRecognizerStateBegan)
    {
        //NSLog(@"state BEGAN, pos %f,%f", current.x, current.y);
        self.startPoint = current;
        self.startView = nil;
        for (UIView * view in self.subviews) {
            if (CGRectContainsPoint(view.frame, current))
            {
                self.startView = (DayResultsView *)view;
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
        diff = CGPointMake((current.x - self.lastPoint.x)*2, current.y - self.lastPoint.y);
        //NSLog(@"state CHANGED, pos %f,%f", diff.x, diff.y);
        self.lastPoint = current;
        if (diff.x * self.lastDiff.x <= -1)
            self.lastChangedDirection = YES;
        self.lastDiff = diff;
        
        [self performSelector:@selector(moveSubviews:) withObject:[NSValue valueWithCGPoint:diff]];
        //CGPoint totalDiff = CGPointMake(self.lastPoint.x - self.startPoint.x, self.lastPoint.y - self.startPoint.y);
        //NSLog(@"TOTAL_CHANGE %f,%f", totalDiff.x, totalDiff.y);
        
//        [self performSelectorOnMainThread:@selector(moveSubviews:) withObject:[NSValue valueWithCGPoint:diff]
//                            waitUntilDone:NO];
    }
    else if (self.panGestures.state == UIGestureRecognizerStateEnded)
    {
        /*CGFloat totalX = self.lastPoint.x - self.startPoint.x;
        int oper = 1;
        if (!self.lastChangedDirection) {
            if (totalX < -60) {
                oper = 2;
            }
            else if (totalX > 60) {
                oper = 3;
            }
        }*/
        CGFloat maxViewHeight = CAL_PANE_HEIGHT;
        if (self.startView != nil)
            maxViewHeight = self.startView.drawBottom;
        [UIView beginAnimations:@"moving" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        CGRect prevFrame = CGRectZero;
        
        for (DayResultsView * view in self.visibleViews) {
            CGRect nf = view.frame;
        
            if (view.prevPane != nil)
            {
                prevFrame = view.prevPane.frame;
                //NSLog(@"%f   <==>    %f", nf.origin.x, prevFrame.origin.x + prevFrame.size.width);
                nf.origin.x = prevFrame.origin.x + prevFrame.size.width;
            }

            if (nf.origin.y + maxViewHeight < self.frame.size.height)
                nf.origin.y = self.frame.size.height - maxViewHeight;
            
            if (nf.origin.y > 0)
                nf.origin.y = 0;
            view.frame = nf;
        }
        [UIView commitAnimations];
    }
    else if (self.panGestures.state == UIGestureRecognizerStateFailed)
    {
        NSLog(@"state FAIL, pos %f,%f", current.x, current.y);
    }
}

-(void)moveSubviews:(NSValue *)diffValue
{
    CGPoint diff = [diffValue CGPointValue];
    CGFloat maxViewHeight = CAL_PANE_HEIGHT;
    if (self.startView != nil)
        maxViewHeight = self.startView.drawBottom;
    CGFloat minY = 0;
    CGFloat maxY = 0;
    
    if (self.frame.size.height < CAL_PANE_HEIGHT)
    {
        minY = self.frame.size.height - CAL_PANE_HEIGHT;
        maxY = 0;
    }
    
    for (UIView * view in self.subviews) {
        CGRect nf = CGRectOffset(view.frame, diff.x, diff.y);
        
        // due to differences between heights of views
        // sometimes it can happen
        // that current view frame is out of range eligible for this view
        // therefore we should apply the difference gently
        // if we apply the difference at once, then user sees
        CGFloat proposal = MIN(MAX(nf.origin.y, minY), maxY);

        if (fabs(nf.origin.y - proposal) > 4)
        {
            CGFloat desired = (nf.origin.y - proposal) / abs(nf.origin.y - proposal) * 5;
            nf.origin.y -= desired;
        }
        else
        {
            nf.origin.y = proposal;
        }
        // end of gentle application of difference
        //
        
        
        view.frame = nf;
    }
    
}


-(DayResultsView *)getFreeView:(CGRect)desiredFrame
{
    //int freec = [self.readyViews count];
    //int nonfreec = [self.visibleViews count];
    
    //NSLog(@"- GETFREEVIEW ---------");
    //NSLog(@"  - free views  %d", freec);
    //NSLog(@"  - nonfree vs  %d", nonfreec);
    //NSLog(@"           SUM  %d", freec + nonfreec);
    //NSLog(@"-----------------------");

    for (DayResultsView * sv in self.readyViews) {
        if (sv.data == nil)
        {
            sv.frame = desiredFrame;
            //NSLog(@"getFreeView --- view reused");
            return sv;
        }
    }
    
    DayResultsView * nv = [[DayResultsView alloc] initWithFrame:desiredFrame];
//    nv.viewState = DRV_MODE_FREE;
    nv.backgroundColor = [UIColor whiteColor];
    nv.engine = self.engine;
    [self.readyViews addObject:nv];
    
    //NSLog(@"getFreeView --- view created");
    return nv;
}

-(CGRect)getCenterFrame
{
    CGRect my = self.frame;
    CGFloat centerX = CGRectGetMidX(my);
    
    CGRect rv = CGRectMake(centerX - CAL_PANE_WIDTH/2, 0, CAL_PANE_WIDTH, CAL_PANE_HEIGHT);
    
    return rv;
}

-(void)showDate:(GCGregorianTime *)date
{
    // locking views array
    [self.readyViewsLock lock];

    // remove views from chain
    while(self.subviews.count > 0)
    {
        DayResultsView * drv = self.subviews[0];
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
    DayResultsView * d = [self getFreeView:[self getCenterFrame]];
    [self.readyViews removeObjectIdenticalTo:d];
    [self.visibleViews addObject:d];
    [d attachDate:date];
    [d addToContainer:self];

    [self checkDateViewsLayout];

    [self.readyViewsLock unlock];
    // now, views are again free
    
}

-(void)reloadData
{
    for (DayResultsView * view in self.visibleViews) {
        [view refreshDateAttachement];
    }
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
        DayResultsView * minView = [self.visibleViews objectAtIndex:0];
        while (minView.frame.origin.x >= -CAL_PANE_WIDTH)
        {
            minView = [self addPaneToLeft:minView];
        }
        
        minView = [self.visibleViews objectAtIndex:0];
        while(minView.frame.origin.x < -CAL_PANE_WIDTH * 5)
        {
            if (minView.nextPane != nil)
            {
                minView.nextPane.prevPane = nil;
            }
            minView.nextPane = nil;
            minView.prevPane = nil;
            minView.data = nil;
            minView.frame = CGRectOffset(minView.frame, 0, -1000);
//            minView.viewState = DRV_MODE_FREE;
            [self.visibleViews removeObjectAtIndex:0];
            [self.readyViews addObject:minView];
            minView = [self.visibleViews objectAtIndex:0];
        }

        DayResultsView * maxView = [self.visibleViews lastObject];
        while (maxView.frame.origin.x + maxView.frame.size.width < self.frame.size.width + CAL_PANE_WIDTH)
        {
            maxView = [self addPaneToRight:maxView];
        }
        
        maxView = [self.visibleViews lastObject];
        while(maxView.frame.origin.x > CAL_PANE_WIDTH * 6)
        {
            if (maxView.prevPane != nil)
            {
                maxView.prevPane.nextPane = nil;
            }
            maxView.prevPane = nil;
            maxView.nextPane = nil;
            maxView.data = nil;
//            maxView.viewState = DRV_MODE_FREE;
            maxView.frame = CGRectOffset(maxView.frame, 0, -1000);
            [self.visibleViews removeLastObject];
            [self.readyViews addObject:maxView];
            maxView = [self.visibleViews lastObject];
        }
    }
    
    self.isCreatingAnimation = NO;
}

- (DayResultsView *)addPaneToLeft:(DayResultsView *)pane
{
    DayResultsView * d = [self getFreeView:CGRectOffset(pane.frame, -pane.frame.size.width, 0)];
    [self.readyViews removeObjectIdenticalTo:d];
    [self.visibleViews insertObject:d atIndex:0];
    GCGregorianTime * firstDate = [pane attachedDate];
    [d attachDate:[firstDate previousDay]];
    [self insertSubview:d atIndex:0];
    
    d.nextPane = pane;
    pane.prevPane = d;
    
    return d;
}

- (DayResultsView *)addPaneToRight:(DayResultsView *)pane
{
    DayResultsView * d = [self getFreeView:CGRectOffset(pane.frame, pane.frame.size.width, 0)];
    [self.readyViews removeObjectIdenticalTo:d];
    [self.visibleViews addObject:d];
    GCGregorianTime * firstDate = [pane attachedDate];
    [d attachDate:[firstDate nextDay]];
    [self insertSubview:d atIndex:0];
    
    pane.nextPane = d;
    d.prevPane = pane;
    return d;
}

-(void)paneDidMove:(DayResultsView *)pane
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
    for (DayResultsView * view in self.visibleViews) {
        [view setNeedsDisplay];
    }
}

@end
