//
//  GCStoreObserver.m
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import "GCStoreObserver.h"
#import "GVExtensionPurchaseViewController.h"
#import "GCDisplaySettings.h"

@implementation GCStoreObserver


-(void)registerAsObserver
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}


- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    NSLog(@"payment updated transactions");
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
        NSLog(@"Invalid identifier is %@", invalidIdentifier);
    }
    
    for (SKProduct * product in self.products)
    {
        if ([product.productIdentifier isEqualToString:@"com.gpsl.gcal.extra"])
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:product.priceLocale];
            NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];

            if (self.theViewController != nil)
            {
//                self.theViewController.labelDescription.text = product.localizedDescription;
                self.theViewController.labelDescription.text = @"Extension for GCAL brings compact view of calendar days to your application.";
                [self.theViewController.view bringSubviewToFront:self.theViewController.labelDescription];
                self.theViewController.labelPrice.text = formattedPrice;
                self.theViewController.purchaseButton.enabled = YES;
                self.theViewController.restoreButton.enabled = YES;
            }
            
            self.selectedProduct = product;
            break;
        }
    }
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
    NSLog(@"received restored transactions: %lu", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        if ([productID isEqualToString:@"com.gpsl.gcal.extra"])
        {
            [self enableExtendedFunc];
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
}

-(void)showTransactionAsInProgress:(SKPaymentTransaction *)transaction deferred:(BOOL)deferred
{
}

-(void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (self.theViewController != nil)
    {
        [self.theViewController purchaseFail:@"Purchasing not successful"];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self completeTransaction:transaction.originalTransaction];
}

- (void)enableExtendedFunc
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    [ud setBool:YES forKey:@"extendedFunctionality"];
    [ud synchronize];
    
    self.theDispSettings.extendedFunctionality = YES;
    
    [self showPurchased];
}

-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.payment != nil && transaction.payment.productIdentifier != nil)
    {
        if ([transaction.payment.productIdentifier isEqualToString:@"com.gpsl.gcal.extra"])
        {
            [self enableExtendedFunc];
        }
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)showPurchased
{
    if (self.theViewController != nil)
    {
        [self.theViewController purchaseOK:self];
    }
}

-(void)purchaseSelectedProduct
{
    SKProduct *product = self.selectedProduct;
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

-(void)restoreProducts
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
