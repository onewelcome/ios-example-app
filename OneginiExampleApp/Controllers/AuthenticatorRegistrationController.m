//
// Copyright (c) 2016 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AuthenticatorRegistrationController.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import "PinViewController.h"
#import "PinErrorMapper.h"
#import "NavigationControllerAppearance.h"
#import "ProfileModel.h"

@interface AuthenticatorRegistrationController ()

@property (nonatomic) UINavigationController *presentingViewController;

@property (nonatomic) UINavigationController *container;
@property (nonatomic) PinViewController *pinViewController;

@property (nonatomic) void (^completion)();

@end

@implementation AuthenticatorRegistrationController

#pragma mark - Init

- (instancetype)initWithPresentingViewController:(UINavigationController *)presentingViewController completion:(void (^)(void))completion
{
    self = [super init];
    if (self) {
        self.presentingViewController = presentingViewController;
        self.completion = completion;

        self.pinViewController = [[PinViewController alloc] init];
        self.pinViewController.pinLength = 5;
        self.pinViewController.mode = PINCheckMode;

        self.container = [[UINavigationController alloc] initWithRootViewController:self.pinViewController];
    }

    return self;
}

+ (instancetype)controllerWithNavigationController:(UINavigationController *)navigationController
                                        completion:(void (^)())completion
{
    return [[self alloc] initWithPresentingViewController:navigationController completion:completion];
}

#pragma mark - ONGAuthenticatorRegistrationDelegate

- (void)userClient:(ONGUserClient *)userClient didRegisterAuthenticator:(nonnull ONGAuthenticator *)authenticator forUser:(nonnull ONGUserProfile *)userProfile
{
    [MBProgressHUD hideHUDForView:self.container.view animated:YES];

    [ONGUserClient sharedInstance].preferredAuthenticator = authenticator;

    [self finish:nil deregistered:NO];
}

/**
 * Possible error domains are ONGAuthenticatorRegistrationErrorDomain and ONGGenericErrorDomain.
 */
- (void)userClient:(ONGUserClient *)userClient didFailToRegisterAuthenticator:(nonnull ONGAuthenticator *)authenticator forUser:(nonnull ONGUserProfile *)userProfile error:(nonnull NSError *)error
{
    [MBProgressHUD hideHUDForView:self.container.view animated:YES];

    switch (error.code) {
        // In case the user is deregistered on the server side the SDK will return the ONGGenericErrorUserDeregistered error. There are a few reasons why this can
        // happen (e.g. the user has entered too many failed PIN attempts). The app needs to handle this situation by deleting any locally stored data for the
        // deregistered user.
        case ONGGenericErrorUserDeregistered:
            [[ProfileModel new] deleteProfileNameForUserProfile:userProfile];;
            [self finish:error deregistered:YES];
            break;
        // In case the entire device registration has been removed from the Token Server the SDK will return the ONGGenericErrorDeviceDeregistered error. In this
        // case the application needs to remove any locally stored data that is associated with any user. It is probably best to reset the app in the state as if
        // the user is starting up the app for the first time.
        case ONGGenericErrorDeviceDeregistered:
            [[ProfileModel new] deleteProfileNames];
            [self finish:error deregistered:YES];
            break;

        // The user has tried to register an authenticator for the user that is no longer authenticated.
        case ONGAuthenticatorRegistrationErrorUserNotAuthenticated:
        // The provided authenticator is not valid. For example attempt to register Fingerprint authenticator while TouchID is neither available nor configured.
        case ONGAuthenticationErrorAuthenticatorInvalid:
        // Attempt to register an already registered authenticator
        case ONGAuthenticatorRegistrationErrorAuthenticatorAlreadyRegistered:
        // Currently not used, you may skip it.
        case ONGAuthenticationErrorFidoAuthenticationDisabled:
        // The given authenticator is not supported.
        case ONGAuthenticatorRegistrationErrorAuthenticatorNotSupported:

        // If the challenge has been cancelled then the ONGGenericErrorActionCancelled error is returned. This error can be ignored.
        case ONGGenericErrorActionCancelled:

        // The SDK doesn't allow you to perform registration of authenticators simultaneously.
        case ONGGenericErrorActionAlreadyInProgress:

        // Typical network connectivity failure errors
        case ONGGenericErrorNetworkConnectivityFailure:
        case ONGGenericErrorServerNotReachable:

        default:
            [self finish:error deregistered:NO];
    }
}

/**
 * The SDK sends a challenge in order to authenticate a user. In case the user has entered an invalid pin or the SDK wasn't able to
 * connect to the server this method will be invoked again. Developer may want to inspect the `challenge.error` property to understand reason of the error.
 * In addition to the error property the `challenge` also maintains `previousFailureCount`, `maxFailureCount` and `remainingFailureCount` that
 * reflects number of PIN attemps left. The user gets deregistered once number of attempts exceeds the maximum amount.
 *
 * Note: during errors that are not related to PIN validation such as network errors the attempts counter remains untouched.
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    __weak typeof(self) weakSelf = self;
    self.pinViewController.pinEntered = ^(NSString *pin, BOOL cancelled) {

        if (pin) {
            [MBProgressHUD showHUDAddedTo:weakSelf.container.view animated:YES];
            [challenge.sender respondWithPin:pin challenge:challenge];
        } else if (cancelled) {
            [challenge.sender cancelChallenge:challenge];
        }
    };

    if (challenge.error) {
        [MBProgressHUD hideHUDForView:self.container.view animated:YES];

        // Pin is already presented on the screen
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
        [self.pinViewController showError:description];
        [self.pinViewController reset];
    } else {
        // First time we're going to show Pin
        [NavigationControllerAppearance apply:self.container];
        self.pinViewController.profile = challenge.userProfile;
        [self.presentingViewController presentViewController:self.container animated:YES completion:nil];
    }
}

#pragma mark - Misc

- (void)showError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authenticator registration error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
}

- (void)finish:(NSError *)error deregistered:(BOOL)deregistered
{
    void (^dismissalCompletion)(void) = ^{
        if (deregistered) {
            [self.presentingViewController popToRootViewControllerAnimated:YES];
        }

        if (error) {
            [self showError:error.localizedDescription];
        }

        if (self.completion) {
            self.completion();
        }
    };

    if (self.container.beingPresented || self.presentingViewController.presentedViewController == self.container) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:dismissalCompletion];
    } else {
        dismissalCompletion();
    }
}

@end
