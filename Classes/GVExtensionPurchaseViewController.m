//
//  GVExtensionPurchaseViewController.m
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import "GVExtensionPurchaseViewController.h"
#import "GCStoreObserver.h"

@interface GVExtensionPurchaseViewController ()

@end

@implementation GVExtensionPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.storeObserver.theViewController = self;
    [self.storeObserver validateProductIdentifiers:[NSArray arrayWithObject:@"com.gpsl.gcal.extra"]];
    self.purchaseButton.enabled = NO;
    self.restoreButton.enabled = NO;
    self.cancelButton.hidden = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    self.labelMessage.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onPurchase:(id)sender
{
    [self.storeObserver purchaseSelectedProduct];
    [self performSelectorOnMainThread:@selector(updatePurchaseButton:) withObject:@"Wait..." waitUntilDone:NO];
    /*
    self.purchaseButton.titleLabel.text = @"Purchasing...";
    [self.storeObserver purchaseSelectedProduct];*/
}

-(IBAction)onRestore:(id)sender
{
    [self.storeObserver restoreProducts];
    [self performSelectorOnMainThread:@selector(updateRestoreButton:) withObject:@"Wait..." waitUntilDone:NO];
}

-(void)updatePurchaseButton:(NSString *)text
{
    self.purchaseButton.titleLabel.text = text;
    self.restoreButton.enabled = NO;
}

-(void)updateRestoreButton:(NSString *)text
{
    self.restoreButton.titleLabel.text = text;
    self.purchaseButton.enabled = NO;
}

-(IBAction)onCancel:(id)sender
{
    [self onClose:sender];
}

-(IBAction)onClose:(id)sender
{
    if (self.navigParent != nil)
    {
        [self.navigParent popViewControllerAnimated:YES];
    }
    else
    {
        [self.view removeFromSuperview];
    }
}

-(IBAction)purchaseOK:(id)sender
{
    self.closeButton.frame = self.purchaseButton.frame;
    self.closeButton.hidden = NO;
    self.purchaseButton.enabled = NO;
    self.restoreButton.enabled = NO;
    [self.view bringSubviewToFront:self.labelMessage];
    self.labelMessage.text = @"OK";
    self.labelMessage.font = [UIFont systemFontOfSize:30];
    self.labelMessage.backgroundColor = [UIColor whiteColor];
    self.labelMessage.textColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1.0];
    self.labelMessage.hidden = NO;
    self.cancelButton.hidden = YES;
}

-(IBAction)purchaseFail:(NSString *)message
{
    self.retryButton.frame = self.purchaseButton.frame;
    self.purchaseButton.hidden = YES;
    self.retryButton.hidden = NO;
    self.restoreButton.enabled = NO;
    [self.view bringSubviewToFront:self.labelMessage];
    self.labelMessage.backgroundColor = [UIColor whiteColor];
    self.labelMessage.font = [UIFont systemFontOfSize:30];
    self.labelMessage.text = message;
    self.labelMessage.textColor = [UIColor redColor];
    self.labelMessage.hidden = NO;
}

@end
