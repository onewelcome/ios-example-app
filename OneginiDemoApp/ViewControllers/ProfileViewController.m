//  Copyright © 2016 Onegini. All rights reserved.

#import "ProfileViewController.h"
#import "ResourceController.h"
#import "LogoutController.h"
#import "DeregistrationController.h"
#import "Profile.h"
#import "MobileAuthenticationController.h"
#import "FingerprintController.h"
#import "ChangePinController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tokenStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *getTokenSpinner;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tokenStatusLabel.hidden = YES;
    self.getTokenSpinner.hidden = YES;
    
    [self update];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)update
{
    if ([[FingerprintController sharedInstance] isFingerprintEnrolled]) {
        [self.fingerprintButton setTitle:@"Disable fingerprint authentication" forState:UIControlStateNormal];
    } else {
        [self.fingerprintButton setTitle:@"Enroll for fingerprint authentication" forState:UIControlStateNormal];
    }
}

- (IBAction)logout:(id)sender
{
    [[LogoutController sharedInstance] logout];
}

- (IBAction)disconnect:(id)sender
{
    [[DeregistrationController sharedInstance] deregister];
}

- (IBAction)getToken:(id)sender
{
    self.tokenStatusLabel.hidden = YES;
    self.getTokenSpinner.hidden = NO;

    [[ResourceController sharedInstance] getToken:^(BOOL received, NSError *error) {
        self.getTokenSpinner.hidden = YES;
        
        if (received) {
            self.tokenStatusLabel.hidden = NO;
        } else {
            [self showError:@"Token retrieval failed"];
        }
    }];
}

- (void)showError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Resource error"
                                                                   message:error
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)enrollForMobileAuthentication:(id)sender
{
    [[MobileAuthenticationController sharedInstance] enrollForMobileAuthentication];
}

- (IBAction)enrollForFingerprintAuthentication:(id)sender
{
    if ([[FingerprintController sharedInstance] isFingerprintEnrolled]) {
        [[FingerprintController sharedInstance] disableFingerprintAuthentication];
        [self update];
    } else {
        [[FingerprintController sharedInstance] enrollForFingerprintAuthentication];
    }
}

- (IBAction)changePin:(id)sender
{
    [[ChangePinController sharedInstance] changePin];
}

@end
