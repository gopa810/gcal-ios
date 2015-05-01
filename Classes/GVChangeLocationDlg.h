//
//  GVChangeLocationDlg.h
//  GCAL
//
//  Created by Peter Kollath on 08/03/15.
//
//

#import <UIKit/UIKit.h>
@class MainViewController;

@interface GVChangeLocationDlg : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property MainViewController * mainController;
@property IBOutlet UITextField * textField;
@property IBOutlet UITableView * tableView;
@property IBOutlet UILabel * searchLabel;
@property NSLock * fieldLock;
@property (copy) NSString * fieldValue;
@property BOOL fieldChanged;
@property NSDictionary * selectedLocation;

@property NSLock * resultLock;
@property NSArray * resultArray;

@end
