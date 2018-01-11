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

#import "AuthenticationController.h"
#import "PinViewController.h"
#import "ProfileViewController.h"
#import "PinErrorMapper.h"
#import "ProfileModel.h"
#import "AlertPresenter.h"
#import "ExperimentalCustomAuthenticatiorViewController.h"

@interface AuthenticationController ()

@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) UITabBarController *tabBarController;
@property (nonatomic) void (^completion)(void);

@end

@implementation AuthenticationController

+ (instancetype)authenticationControllerWithNavigationController:(UINavigationController *)navigationController
                                                tabBarController:(UITabBarController *)tabBarController
                                                      completion:(void (^)(void))completion
{
    AuthenticationController *authorizationController = [AuthenticationController new];
    authorizationController.navigationController = navigationController;
    authorizationController.tabBarController = tabBarController
    ;
    authorizationController.completion = completion;
    authorizationController.pinViewController = [PinViewController new];
    return authorizationController;
}

- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile info:(nullable ONGCustomAuthInfo *)info
{
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    self.completion();

    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    
    // In case the user is deregistered on the server side the SDK will return the ONGGenericErrorUserDeregistered error. There are a few reasons why this can
    // happen (e.g. the user has entered too many failed PIN attempts). The app needs to handle this situation by deleting any locally stored data for the
    // deregistered user.
    if (error.code == ONGGenericErrorUserDeregistered) {
        [[ProfileModel new] deleteProfileNameForUserProfile:userProfile];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    // In case the entire device registration has been removed from the Token Server the SDK will return the ONGGenericErrorDeviceDeregistered error. In this
    // case the application needs to remove any locally stored data that is associated with any user. It is probably best to reset the app in the state as if
    // the user is starting up the app for the first time.
    else if (error.code == ONGGenericErrorDeviceDeregistered) {
        [[ProfileModel new] deleteProfileNames];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    // If the challenge has been cancelled than the ONGGenericErrorActionCancelled error is returned.
    else if (error.code == ONGGenericErrorActionCancelled) {
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

    // It is up to you to decide when and how to show the PIN entry view controller.
    // For simplicity of the example app we're checking the top-most view controller.
    if (![self.tabBarController.presentedViewController isEqual:self.pinViewController]) {
        [self.tabBarController presentViewController:self.pinViewController animated:YES completion:nil];
    }

    if (challenge.error) {
        // Please read the comments written in the PinErrorMapper class to understand the intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
        [self.pinViewController showError:description];
    }

    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)userClient:(ONGUserClient *)userClient didReceiveFingerprintChallenge:(ONGFingerprintChallenge *)challenge
{
    self.progressStateDidChange(YES);
    [challenge.sender respondWithPrompt:@"Please provide your fingerprint." challenge:challenge];
}

- (void)userClient:(ONGUserClient *)userClient didReceiveCustomAuthFinishAuthenticationChallenge:(ONGCustomAuthFinishAuthenticationChallenge *)challenge
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Custom Authenticator"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *alertTextField;
    if ([challenge.authenticator.identifier isEqualToString:@"PASSWORD_CA_ID"]) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.accessibilityIdentifier = @"CustomAuthenticatorAlertTextField";
            alertTextField = textField;
        }];
    }
    
    UIAlertAction *authenticateButton = [UIAlertAction actionWithTitle:@"Authenticate"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   if ([challenge.authenticator.identifier isEqualToString:@"PASSWORD_CA_ID"]) {
                                                                       [challenge.sender respondWithData:alertTextField.text challenge:challenge];
                                                                   } else if ([challenge.authenticator.identifier isEqualToString:@"EXPERIMENTAL_CA_ID"]) {
                                                                       ExperimentalCustomAuthenticatiorViewController *experimentalCustomAuthenticatiorViewController = [[ExperimentalCustomAuthenticatiorViewController alloc] init];
                                                                       experimentalCustomAuthenticatiorViewController.viewTitle = @"Authentication";
                                                                       __weak typeof(self) weakSelf = self;
                                                                       experimentalCustomAuthenticatiorViewController.customAuthAction = ^(NSString *data, BOOL cancelled) {
                                                                           [weakSelf.tabBarController dismissViewControllerAnimated:YES completion:nil];
                                                                           if (data) {
                                                                               [challenge.sender respondWithData:data challenge:challenge];
                                                                           } else if (cancelled) {
                                                                               [challenge.sender cancelChallenge:challenge underlyingError:nil];
                                                                           }
                                                                       };
                                                                       [self.tabBarController presentViewController:experimentalCustomAuthenticatiorViewController animated:YES completion:nil];
                                                                   }
                                                               }];
    
    UIAlertAction *fallbackToPinButton = [UIAlertAction actionWithTitle:@"Fallback to PIN"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [challenge.sender respondWithPinFallbackForChallenge:challenge];
                                                                }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [challenge.sender cancelChallenge:challenge underlyingError:nil];
                                                         }];
    
    [alert addAction:authenticateButton];
    [alert addAction:fallbackToPinButton];
    [alert addAction:cancelButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)showError:(NSError *)error
{
    AlertPresenter *errorPresenter = [AlertPresenter createAlertPresenterWithTabBarController:self.tabBarController];
    [errorPresenter showErrorAlert:error title:@"Authentication Error"];
}

@end
