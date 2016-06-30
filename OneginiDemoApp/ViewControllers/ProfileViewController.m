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
#import "DisconnectController.h"
#import "Profile.h"
#import "OneginiSDK.h"
#import "PinViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController() <OGFingerprintDelegate, OGEnrollmentHandlerDelegate>

@property (weak, nonatomic) IBOutlet UIView *profileDataView;
@property (weak, nonatomic) IBOutlet UILabel *profileMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *getProfileSpinner;
@property (weak, nonatomic) IBOutlet UIButton *getProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *mobileEnrollmentButton;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintEnrollmentButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileDataView.hidden = YES;
    self.getProfileSpinner.hidden = YES;
    
    [self updateEnrollmentVisibleState];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)logout:(id)sender {
    [[LogoutController sharedInstance]logout];
}

- (IBAction)disconnect:(id)sender {
    [[DisconnectController sharedInstance]disconnect];
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
- (IBAction)enableMobileEnrollment:(id)sender {
    [[OGOneginiClient sharedInstance] enrollForMobileAuthentication:@[@"default"] delegate:self];
}

- (void)updateEnrollmentVisibleState {
    OGOneginiClient *client = [OGOneginiClient sharedInstance];
        
    self.fingerprintEnrollmentButton.enabled = [client isFingerprintAuthenticationAvailable];
    NSString *fingerprintTitle = [client isFingerprintAuthenticationAvailable] ? [client isEnrolledForFingerprintAuthentication] ? @"Enrolled" : @"Enroll" : @"TouchID N/A";
    [self.fingerprintEnrollmentButton setTitle:fingerprintTitle forState:UIControlStateNormal];
}

- (IBAction)switchFingerprintEnrollment:(id)sender {
    OGOneginiClient *client = [OGOneginiClient sharedInstance];
    if (!client.isFingerprintAuthenticationAvailable) {
        return;
    }
    
    if ([client isEnrolledForFingerprintAuthentication]) {
        [client disableFingerprintAuthentication];
        [self updateEnrollmentVisibleState];
    } else {
        [client enrollForFingerprintAuthentication:@[@"default"] delegate:self];
    }
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

- (void) askCurrentPinForFingerprintAuthentication {
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = 5;
    viewController.mode = PINCheckMode;
    viewController.pinEntered = ^(NSString *pin) {
        [[OGOneginiClient sharedInstance] confirmCurrentPinForFingerprintAuthorization:pin];
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void) fingerprintAuthenticationEnrollmentSuccessful {
    [self updateEnrollmentVisibleState];
}

- (void) fingerprintAuthenticationEnrollmentFailure {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void) fingerprintAuthenticationEnrollmentFailureNotAuthenticated {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void) fingerprintAuthenticationEnrollmentErrorInvalidPin:(NSUInteger)attemptCount {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void) fingerprintAuthenticationEnrollmentErrorTooManyPinFailures {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentSuccess {
    [self updateEnrollmentVisibleState];
}

- (void)enrollmentError {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentAuthenticationError {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentError:(NSError *)error {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentNotAvailable {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentInvalidRequest {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentInvalidClientCredentials {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentDeviceAlreadyEnrolled {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentUserAlreadyEnrolled {
    [self showError:NSStringFromSelector(_cmd)];
}

- (void)enrollmentInvalidTransaction {
    [self showError:NSStringFromSelector(_cmd)];
}

@end
