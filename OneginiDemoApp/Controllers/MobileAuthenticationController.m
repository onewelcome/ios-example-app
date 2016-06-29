//
//  EnrollmentController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 19/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "MobileAuthenticationController.h"
#import "OneginiSDK.h"
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

- (void)askForPushAuthenticationConfirmation:(NSString *)message profile:(OGUserProfile *)profile notificationType:(NSString *)notificationType confirm:(void (^)(bool))confirm
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = message;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push - %@", profile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        confirm(confirmed);
    };
    [[AppDelegate sharedNavigationController] pushViewController:pushVC animated:YES];
}

- (void)askForPushAuthenticationWithFingerprint:(NSString *)message profile:(OGUserProfile *)profile notificationType:(NSString *)notificationType confirm:(void (^)(bool))confirm
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = message;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push with fingerprint - %@", profile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        confirm(confirmed);
    };
    [[AppDelegate sharedNavigationController] pushViewController:pushVC animated:YES];
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message profile:(OGUserProfile *)profile notificationType:(NSString *)notificationType pinSize:(NSUInteger)pinSize maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt confirm:(void (^)(NSString *, BOOL, BOOL))confirm
{
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = pinSize;
    viewController.mode = PINCheckMode;
    viewController.customTitle = [NSString stringWithFormat:@"Push with pin - %@", profile.profileId];
    viewController.pinEntered = ^(NSString *pin) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        confirm(pin, YES, YES);
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)enrollForMobileAuthentication
{
    [[OGOneginiClient sharedInstance] enrollForMobileAuthenticationWithDelegate:self];
}

- (void)enrollmentSuccess
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enrollment successfull" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

- (void)enrollmentDeviceAlreadyEnrolled
{
}

- (void)enrollmentNotAuthenticated
{
}

- (void)enrollmentNotAvailable
{
}

- (void)enrollmentInvalidRequest
{
}

- (void)enrollmentInvalidClientCredentials
{
}

- (void)enrollmentError
{
}

- (void)enrollmentError:(NSError *)error
{
}

- (void)enrollmentInvalidTransaction
{
}

- (void)enrollmentUserAlreadyEnrolled
{
}

@end
