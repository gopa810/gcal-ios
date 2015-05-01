//
//  GVHelpIntroViewController.h
//  GCAL
//
//  Created by Peter Kollath on 16/03/15.
//
//

#import <UIKit/UIKit.h>

@interface GVHelpIntroViewController : UIViewController


@property IBOutlet UIButton * backButton;
@property IBOutlet UIButton * nextButton;
@property IBOutlet UIButton * closeButton;
@property IBOutlet UILabel * titleLabel;
@property IBOutlet UILabel * textLabel;


@property NSDictionary * pages;
@property NSString * currentPage;

-(void)setPage:(NSString *)pageName;

@end
