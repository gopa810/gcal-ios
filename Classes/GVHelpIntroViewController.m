//
//  GVHelpIntroViewController.m
//  GCAL
//
//  Created by Peter Kollath on 16/03/15.
//
//

#import "GVHelpIntroViewController.h"

@interface GVHelpIntroViewController ()

@end

@implementation GVHelpIntroViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.currentPage = @"initial";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setPage:self.currentPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setPage:(NSString *)pageName
{
    self.currentPage = pageName;
    
    NSDictionary * page = [self.pages valueForKey:self.currentPage];

    self.backButton.hidden = [[page objectForKey:@"backHidden"] boolValue];
    self.nextButton.hidden = [[page objectForKey:@"nextHidden"] boolValue];
    self.closeButton.hidden = [[page objectForKey:@"closeHidden"] boolValue];
    self.titleLabel.text = [page objectForKey:@"title"];
    self.textLabel.text = [page objectForKey:@"text"];
}

-(IBAction)onBack:(id)sender
{
    NSDictionary * page = [self.pages valueForKey:self.currentPage];
    
    NSString * prevPage = [page valueForKey:@"prevPage"];
    
    [self setPage:prevPage];
}


-(IBAction)onNext:(id)sender
{
    NSDictionary * page = [self.pages valueForKey:self.currentPage];
    
    NSString * nextPage = [page valueForKey:@"nextPage"];
    
    [self setPage:nextPage];
}

-(IBAction)onClose:(id)sender
{
    [self.view removeFromSuperview];
}

@end
