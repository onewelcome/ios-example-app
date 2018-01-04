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
#import "AlertPresenter.h"
#import "ExperimentalCustomAuthenticatiorViewController.h"

@interface AuthenticatorRegistrationController ()

@property (nonatomic) UINavigationController *presentingViewController;
@property (nonatomic) UITabBarController *tabBarController;

@property (nonatomic) UINavigationController *container;

@property (nonatomic) void (^completion)(void);

@end

@implementation AuthenticatorRegistrationController

#pragma mark - Init

+ (instancetype)controllerWithNavigationController:(UINavigationController *)navigationController
                                  tabBarController:(UITabBarController *)tabBarController
                                        completion:(void (^)(void))completion
{
    AuthenticatorRegistrationController *authenticatorRegistrationController = [AuthenticatorRegistrationController new];
    authenticatorRegistrationController.presentingViewController = navigationController;
    authenticatorRegistrationController.completion = completion;
    authenticatorRegistrationController.pinViewController = [PinViewController new];
    authenticatorRegistrationController.tabBarController = tabBarController;
    return authenticatorRegistrationController;
}

#pragma mark - ONGAuthenticatorRegistrationDelegate

- (void)userClient:(ONGUserClient *)userClient didRegisterAuthenticator:(nonnull ONGAuthenticator *)authenticator forUser:(nonnull ONGUserProfile *)userProfile info:(ONGCustomAuthInfo * _Nullable)customAuthInfo
{

    [ONGUserClient sharedInstance].preferredAuthenticator = authenticator;

    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    self.completion();
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

/**
 * Possible error domains are ONGAuthenticatorRegistrationErrorDomain and ONGGenericErrorDomain.
 */
- (void)userClient:(ONGUserClient *)userClient didFailToRegisterAuthenticator:(nonnull ONGAuthenticator *)authenticator forUser:(nonnull ONGUserProfile *)userProfile error:(nonnull NSError *)error
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];

    switch (error.code) {
        // In case the user is deregistered on the server side the SDK will return the ONGGenericErrorUserDeregistered error. There are a few reasons why this can
        // happen (e.g. the user has entered too many failed PIN attempts). The app needs to handle this situation by deleting any locally stored data for the
        // deregistered user.
        case ONGGenericErrorUserDeregistered:
            [[ProfileModel new] deleteProfileNameForUserProfile:userProfile];;
            [self.presentingViewController popToRootViewControllerAnimated:YES];
            break;
        // In case the entire device registration has been removed from the Token Server the SDK will return the ONGGenericErrorDeviceDeregistered error. In this
        // case the application needs to remove any locally stored data that is associated with any user. It is probably best to reset the app in the state as if
        // the user is starting up the app for the first time.
        case ONGGenericErrorDeviceDeregistered:
            [[ProfileModel new] deleteProfileNames];
            [self.presentingViewController popToRootViewControllerAnimated:YES];
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
            break;
    }
    
    [self showError:error];
    
    self.completion();
    
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
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
    [self.pinViewController reset];
    self.pinViewController.pinLength = 5;
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = challenge.userProfile;
    
    __weak typeof(self) weakSelf = self;
    self.pinViewController.pinEntered = ^(NSString *pin, BOOL cancelled) {
        if (self.progressStateDidChange != nil) {
            weakSelf.progressStateDidChange(YES);
        }
        if (pin) {
            [challenge.sender respondWithPin:pin challenge:challenge];
        } else if (cancelled) {
            [challenge.sender cancelChallenge:challenge];
        }
    };
    
    if (![self.tabBarController.presentedViewController isEqual:self.pinViewController]) {
        [self.tabBarController presentViewController:self.pinViewController animated:YES completion:nil];
    }

    if (challenge.error) {
        // Pin is already presented on the screen
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
        [self.pinViewController showError:description];
    }
    
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)userClient:(ONGUserClient *)userClient didReceiveCustomAuthFinishRegistrationChallenge:(ONGCustomAuthFinishRegistrationChallenge *)challenge
{
    if ([challenge.authenticator.identifier isEqualToString:@"PASSWORD_CA_ID"]) {
        [self showPasswordCA:challenge];
    } else if ([challenge.authenticator.identifier isEqualToString:@"EXPERIMENTAL_CA_ID"]) {
        ExperimentalCustomAuthenticatiorViewController *experimentalCustomAuthenticatiorViewController = [[ExperimentalCustomAuthenticatiorViewController alloc] init];
        experimentalCustomAuthenticatiorViewController.customAuthFinishRegistrationChallenge = challenge;
        [self.tabBarController presentViewController:experimentalCustomAuthenticatiorViewController animated:YES completion:nil];
    }
}

#pragma mark - Misc

- (void)showError:(NSError *)error
{
    AlertPresenter *errorPresenter = [AlertPresenter createAlertPresenterWithTabBarController:self.tabBarController];
    [errorPresenter showErrorAlert:error title:@"Authenticator registration error"];
}

- (void)showPasswordCA:(ONGCustomAuthFinishRegistrationChallenge *)challenge
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password Custom Authenticator"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *alertTextField;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.accessibilityIdentifier = @"CustomAuthenticatorAlertTextField";
        alertTextField = textField;
    }];
    UIAlertAction *authenticateButton = [UIAlertAction actionWithTitle:@"Register"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   [challenge.sender respondWithData:alertTextField.text challenge:challenge];
                                                               }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [challenge.sender cancelChallenge:challenge underlyingError:nil];
                                                         }];
    
    [alert addAction:authenticateButton];
    [alert addAction:cancelButton];
    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
}

@end
