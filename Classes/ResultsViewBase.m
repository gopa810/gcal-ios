//
//  ResultsViewBase.m
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import "ResultsViewBase.h"
#import "GCGregorianTime.h"

@implementation ResultsViewBase

-(void)attachDate:(GCGregorianTime *)date
{
    self.attachedDate = date;
    self.hasAttachedDate = YES;

    [self refreshDateAttachement];
}

-(void)refreshDateAttachement
{
    int julDay = [self.attachedDate getJulianInteger];
    int julPage = julDay / 32;
    int julPageIndex = julDay % 32;
    
    self.data = [self.engine requestPage:julPage view:self itemIndex:julPageIndex];
//    if (self.data == nil)
//    {
//        self.viewState = DRV_MODE_ASSIGNED_WAITING;
//        //NSLog(@"Put to waiting for date %@", [date longDateString]);
//    }
//    else
//    {
//        self.viewState = DRV_MODE_ASSIGNED;
//    }
    
//    [self setNeedsDisplay];
    
    CGRect rect = self.frame;
    rect.size = [self calculateContentSize];
    self.frame = rect;
}


-(CGSize)calculateContentSize
{
    return CGSizeZero;
}

-(void)setData:(GCTodayInfoData *)D
{
    self.alignedHeight = NO;
    _data = D;
    //NSLog(@"Date %@   coreEvents %d", [D.calendarDay.date longDateString], D.calendarDay.coreEvents.count);
//    if (self.viewState == DRV_MODE_ASSIGNED_WAITING)
//    {
//        self.viewState = DRV_MODE_ASSIGNED;
//    }
//    else if (self.viewState == DRV_MODE_ASSIGNED_WAITING_CONTAINER)
//    {
//        self.viewState = DRV_MODE_ASSIGNED_CONTAINER;
//    }
//    else if (D != nil)
//    {
//        self.viewState = DRV_MODE_ASSIGNED;
//    }
    
    [self setNeedsDisplay];
}

-(void)detachDate
{
    self.data = nil;
    self.hasAttachedDate = NO;
}

-(void)addToContainer:(UIView *)parentView
{
    [parentView addSubview:self];
//    if (self.viewState == DRV_MODE_ASSIGNED)
//    {
//        self.viewState = DRV_MODE_ASSIGNED_CONTAINER;
//    }
//    else if (self.viewState == DRV_MODE_ASSIGNED_WAITING)
//    {
//        self.viewState = DRV_MODE_ASSIGNED_WAITING_CONTAINER;
//    }
//    else
//    {
//        NSLog(@"This should not happen: adding to container from state %d", self.viewState);
//    }
}


@end
