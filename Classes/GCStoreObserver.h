//
//  GCStoreObserver.h
//  GCAL
//
//  Created by Peter Kollath on 13/03/15.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class GCDisplaySettings;
@class GVExtensionPurchaseViewController;

@interface GCStoreObserver : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property SKProduct * selectedProduct;
@property NSArray * products;
@property IBOutlet GCDisplaySettings * theDispSettings;
@property (weak) GVExtensionPurchaseViewController * theViewController;

-(void)registerAsObserver;
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers;
-(void)purchaseSelectedProduct;
-(void)restoreProducts;

@end
