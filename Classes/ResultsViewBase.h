//
//  ResultsViewBase.h
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import <UIKit/UIKit.h>
#import "GCTodayInfoData.h"
#import "GCEngine.h"


@class GCGregorianTime;

#define DRV_MODE_FREE                       0
#define DRV_MODE_ASSIGNED_WAITING           1
#define DRV_MODE_ASSIGNED_WAITING_CONTAINER 2
#define DRV_MODE_ASSIGNED_CONTAINER         3
#define DRV_MODE_ASSIGNED                   4

@interface ResultsViewBase : UIView

@property BOOL alignedHeight;
@property int  viewState;
@property BOOL hasAttachedDate;
@property (copy) GCGregorianTime * attachedDate;
@property (nonatomic,strong) GCTodayInfoData * data;
@property (weak) ResultsViewBase * prevPane;
@property (weak) ResultsViewBase * nextPane;
@property (weak) IBOutlet GCEngine * engine;
@property CGFloat drawBottom;

-(void)attachDate:(GCGregorianTime *)date;
-(void)detachDate;
-(BOOL)hasAttachedDate;
-(void)addToContainer:(UIView *)parentView;
-(void)refreshDateAttachement;
-(CGSize)calculateContentSize;

@end
