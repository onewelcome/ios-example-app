//  Copyright © 2016 Onegini. All rights reserved.

#import "MobileAuthenticationController.h"
#import "AppDelegate.h"
#import "PinViewController.h"
#import "PushConfirmationViewController.h"

@implementation MobileAuthenticationController

+ (instancetype)sharedInstance
{
    static MobileAuthenticationController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });

    return singleton;
}

// MARK: - OGMobileAuthenticationDelegate

- (void)userClient:(ONGUserClient *)userClient didReceiveConfirmationChallenge:(void (^)(BOOL confirmRequest))confirmation forRequest:(ONGMobileAuthenticationRequest *)request
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = request.title;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push - %@", request.userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        confirmation(confirmed);
    };
    [[AppDelegate sharedNavigationController] pushViewController:pushVC animated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request
{
    PinViewController *viewController = [PinViewController new];
    viewController.mode = PINCheckMode;
    viewController.customTitle = [NSString stringWithFormat:@"Push with pin - %@", challenge.userProfile.profileId];
    viewController.pinEntered = ^(NSString *pin) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        [challenge.sender respondWithPin:pin challenge:challenge];
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didReceiveFingerprintChallenge:(ONGFingerprintChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = request.title;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push with fingerprint - %@", request.userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        [challenge.sender respondWithDefaultPromptForChallenge:challenge];
    };
    [[AppDelegate sharedNavigationController] pushViewController:pushVC animated:YES];
}

// MARK: - OGEnrollmentHandlerDelegate

- (void)enrollForMobileAuthentication
{
    [[ONGUserClient sharedInstance] enrollForMobileAuthentication:^(BOOL enrolled, NSError * _Nullable error) {
        NSString *title = nil;

        if (enrolled) {
            title = @"Enrolled successfully";
        } else {
            title = @"Enrollment failure";
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okButton];
        [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
    }];
}

@end
