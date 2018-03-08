//  Copyright © 2018 Onegini. All rights reserved.

#import "TwoWayOTPViewController.h"

@interface TwoWayOTPViewController ()
@property (weak, nonatomic) IBOutlet UILabel *challengeCode;
@property (weak, nonatomic) IBOutlet UITextField *responseCode;

@end

@implementation TwoWayOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.challengeCode.text = [self getCodeFromJSONString:self.challenge.data];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.responseCode resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 6;
}

- (IBAction)ok:(id)sender {
    self.completionBlock(self.responseCode.text, NO);
}

- (IBAction)cancel:(id)sender {
    self.completionBlock(nil, YES);
}

- (NSString *)getCodeFromJSONString:(NSString *)data
{
    NSError *jsonError;
    NSData *objectData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    return json[@"client_code"];
}

@end
