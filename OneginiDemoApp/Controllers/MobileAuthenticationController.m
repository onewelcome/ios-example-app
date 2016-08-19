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

- (void)askForPushAuthenticationConfirmation:(NSString *)message user:(OGUserProfile *)userProfile notificationType:(NSString *)notificationType confirm:(void (^)(bool))confirm
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = message;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push - %@", userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        confirm(confirmed);
    };
    [[AppDelegate sharedNavigationController] pushViewController:pushVC animated:YES];
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message user:(OGUserProfile *)userProfile notificationType:(NSString *)notificationType pinSize:(NSUInteger)pinSize maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt confirm:(void (^)(NSString *, BOOL, BOOL))confirm
{
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = pinSize;
    viewController.mode = PINCheckMode;
    viewController.customTitle = [NSString stringWithFormat:@"Push with pin - %@", userProfile.profileId];
    viewController.pinEntered = ^(NSString *pin) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        confirm(pin, YES, YES);
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)askForPushAuthenticationWithFingerprint:(NSString *)message user:(OGUserProfile *)userProfile notificationType:(NSString *)notificationType confirm:(void (^)(bool))confirm
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = message;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push with fingerprint - %@", userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
        confirm(confirmed);
    };
    [[AppDelegate sharedNavigationController] pushViewController:pushVC animated:YES];
}


// MARK: - OGEnrollmentHandlerDelegate

- (void)enrollForMobileAuthentication
{
    [[OGOneginiClient sharedInstance] enrollUserForMobileAuthenticationWithDelegate:self];
}

- (void)enrollmentSuccess
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enrollment successfull" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

- (void)enrollmentDeviceAlreadyEnrolled
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

- (void)enrollmentAuthenticationError
{
}

- (void)enrollmentErrorDeviceDeregistered
{
}

@end
