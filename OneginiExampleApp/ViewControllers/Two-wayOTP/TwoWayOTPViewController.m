//  Copyright © 2018 Onegini. All rights reserved.

#import "TwoWayOTPViewController.h"

@interface TwoWayOTPViewController ()
@property (weak, nonatomic) IBOutlet UILabel *challengeCode;
@property (weak, nonatomic) IBOutlet UITextField *responseCode;

@end

@implementation TwoWayOTPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.responseCode resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 6;
}

- (void)setChallenge:(ONGCustomRegistrationChallenge *)challenge
{
    self.challengeCode.text = challenge.data;
}

- (IBAction)ok:(id)sender
{
    self.completionBlock(self.responseCode.text, NO);
}

- (IBAction)cancel:(id)sender
{
    self.completionBlock(nil, YES);
}

@end
