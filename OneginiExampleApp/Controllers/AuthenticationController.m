//  Copyright © 2016 Onegini. All rights reserved.

#import "AuthenticationController.h"
#import "PinViewController.h"
#import "ProfileViewController.h"
#import "PinErrorMapper.h"

@interface AuthenticationController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) void (^completion)();

@end

@implementation AuthenticationController

+ (instancetype)authenticationControllerWithNavigationController:(UINavigationController *)navigationController
                                                      completion:(void (^)())completion
{
    AuthenticationController *authorizationController = [AuthenticationController new];
    authorizationController.navigationController = navigationController;
    authorizationController.completion = completion;
    authorizationController.pinViewController = [PinViewController new];
    return authorizationController;
}

- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile
{
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.completion();
    
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    // In case the user is deregistered on the server side the SDK will return the ONGGenericErrorUserDeregistered error. There are a few reasons why this can
    // happen (e.g. the user has entered too many failed PIN attempts). The app needs to handle this situation by deleting any locally stored data for the
    // deregistered user.
    // In case the entire device registration has been removed from the Token Server the SDK will return the ONGGenericErrorDeviceDeregistered error. In this
    // case the application needs to remove any locally stored data that is associated with any user. It is probably best to reset the app in the state as if
    // the user is starting up the app for the first time.
    if (error.code == ONGGenericErrorUserDeregistered || error.code == ONGGenericErrorDeviceDeregistered) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (error.code == ONGGenericErrorActionCancelled) {
        // If the challenge has been cancelled than the ONGGenericErrorActionCancelled error is returned.
        // In the example app login is done in the root of the application navigation stack, that's why we're simply popping the pin view controller
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    [self showError:error];

    self.completion();
    
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    [self.pinViewController reset];
    self.pinViewController.pinLength = 5;
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = challenge.userProfile;

    __weak typeof(self) weakSelf = self;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        if (self.progressStateDidChange != nil) {
            weakSelf.progressStateDidChange(YES);
        }
        [challenge.sender respondWithPin:pin challenge:challenge];
    };

    // It is up to you to decide when and how to show the PIN entry view controller.
    // For simplicity of the example app we're checking the top-most view controller.
    if (![self.navigationController.topViewController isEqual:self.pinViewController]) {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }
<<<<<<< HEAD
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
=======

    if (challenge.error) {
        // Please read the comments written in the PinErrorMapper class to understand the intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
        [self.pinViewController showError:description];
>>>>>>> new-api
    }
}

- (void)showError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authentication Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
