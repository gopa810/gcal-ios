//
//  GVChangeDateViewController.h
//  GCAL
//
//  Created by Peter Kollath on 08/03/15.
//
//

#import <UIKit/UIKit.h>


@class MainViewController;

@interface GVChangeDateViewController : UIViewController

@property IBOutlet UIDatePicker * datePicker;
@property MainViewController * mainController;

-(IBAction)onSelect:(id)sender;
-(IBAction)onCancel:(id)sender;

@end
