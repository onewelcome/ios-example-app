//
//  ProfileViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ProfileViewController.h"
#import "ResourceController.h"
#import "LogoutController.h"
#import "DeregistrationController.h"
#import "Profile.h"
#import "OneginiSDK.h"
#import "MobileAuthenticationController.h"
#import "FingerprintController.h"
#import "ChangePinController.h"

@interface ProfileViewController()

@property (weak, nonatomic) IBOutlet UIView *profileDataView;
@property (weak, nonatomic) IBOutlet UILabel *profileMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *getProfileSpinner;
@property (weak, nonatomic) IBOutlet UIButton *getProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileDataView.hidden = YES;
    self.getProfileSpinner.hidden = YES;
    [self update];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self update];
}

- (void)update{
    if ([[FingerprintController sharedInstance] isFingerprintEnrolled]){
        [self.fingerprintButton setTitle:@"Disable fingerprint authentication" forState:UIControlStateNormal];
    } else {
        [self.fingerprintButton setTitle:@"Enroll for fingerprint authentication" forState:UIControlStateNormal];
    }
}

- (IBAction)logout:(id)sender {
    [[LogoutController sharedInstance]logout];
}

- (IBAction)disconnect:(id)sender {
    [[DeregistrationController sharedInstance] deregister];
}

- (IBAction)getProfile:(id)sender {
    self.profileDataView.hidden = YES;
    self.getProfileSpinner.hidden = NO;
    [[ResourceController sharedInstance] getProfile:^(Profile *profile, NSError *error) {
        self.getProfileSpinner.hidden = YES;
        if(profile){
            self.profileDataView.hidden = NO;
            self.profileMailLabel.text = profile.email;
            self.profileNameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName, profile.lastName];
        } else {
            [self showError:@"Downloading profile failed."];
        }
    }];

}

- (void)showError:(NSString*)error{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Resource error"
                                                                    message:error
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)enrollForMobileAuthentication:(id)sender {
    [[MobileAuthenticationController sharedInstance] enrollForMobileAuthentication];
}

- (IBAction)enrollForFingerprintAuthentication:(id)sender {
    if ([[FingerprintController sharedInstance] isFingerprintEnrolled]){
        [[FingerprintController sharedInstance] disableFingerprintAuthentication];
        [self update];
    } else {
        [[FingerprintController sharedInstance] enrollForFingerprintAuthentication];
    }
}

- (IBAction)changePin:(id)sender {
    [[ChangePinController sharedInstance] changePin];
}

@end
