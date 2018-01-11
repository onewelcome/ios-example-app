//  Copyright © 2018 Onegini. All rights reserved.

#import "ExperimentalCustomAuthenticatiorViewController.h"
#import "OneginiSDK.h"

@interface ExperimentalCustomAuthenticatiorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ExperimentalCustomAuthenticatiorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.viewTitle;
}

- (IBAction)confirm:(id)sender
{
    self.customAuthAction(@"data", NO);
}

- (IBAction)cancel:(id)sender
{
    self.customAuthAction(nil, YES);
}

@end
