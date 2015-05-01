//
//  GVExtensionPurchaseViewController.h
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import <UIKit/UIKit.h>

@class GCDisplaySettings;
@class GCStoreObserver;

@interface GVExtensionPurchaseViewController : UIViewController


@property UINavigationController * navigParent;
@property GCDisplaySettings * theDispSettings;
@property GCStoreObserver * storeObserver;

@property IBOutlet UILabel * labelDescription;
@property IBOutlet UILabel * labelPrice;
@property IBOutlet UILabel * labelMessage;
@property IBOutlet UIButton * purchaseButton;
@property IBOutlet UIButton * restoreButton;
@property IBOutlet UIButton * cancelButton;
@property IBOutlet UIButton * closeButton;
@property IBOutlet UIButton * retryButton;
@property IBOutlet UIProgressView * progressView;

-(IBAction)onPurchase:(id)sender;
-(IBAction)onCancel:(id)sender;
-(IBAction)purchaseOK:(id)sender;
-(IBAction)purchaseFail:(NSString *)message;

@end
