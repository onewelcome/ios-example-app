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

#import "ChangePinController.h"
#import "PinViewController.h"
#import "PinErrorMapper.h"

@interface ChangePinController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) void (^completion)();

@end

@implementation ChangePinController

+ (instancetype)changePinControllerWithNavigationController:(UINavigationController *)navigationController
                                                 completion:(void (^)())completion
{
    ChangePinController *changePinController = [ChangePinController new];
    changePinController.navigationController = navigationController;
    changePinController.pinViewController = [PinViewController new];
    changePinController.completion = completion;
    return changePinController;
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
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = challenge.userProfile;
    self.pinViewController.pinLength = 5;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithPin:pin challenge:challenge];
    };

    // It is up to the developer to decide when and how to show PIN entry view controller.
    // For simplicity of the example app we're checking the top-most view controller.
    // Also good place to do this is the -userClient:didStartPinChangeForUser: but you need to be aware that there is a
    // delay between pin change start and receiving of the pin challenge.
    if (![self.navigationController.topViewController isEqual:self.pinViewController]) {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }

    if (challenge.error) {
        // Please read comments for the PinErrorMapper to understand the intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
        [self.pinViewController showError:description];
    }

    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

/**
 * Similar to the -userClient:didReceivePinChallenge: `challenge` contains an error.
 * However domains are slightly different: ONGPinValidationErrorDomain and ONGGenericError.
 *
 * In contrast with -userClient:didReceivePinChallenge: failure in -userClient:didReceiveCreatePinChallenge:
 * do not lead to any attempts counter incrementing. Therefore User is able to enter a pin as many times as needed.
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCreatePinChallenge:(ONGCreatePinChallenge *)challenge
{
    [self.pinViewController reset];

    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };

    if (challenge.error) {
        // Please read the comments written in the PinErrorMapper class to understand the intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofCreatePinChallenge:challenge];
        [self.pinViewController showError:description];
    }
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)userClient:(ONGUserClient *)userClient didChangePinForUser:(ONGUserProfile *)userProfile
{
    [self.navigationController popViewControllerAnimated:YES];
    self.completion();
    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)userClient:(ONGUserClient *)userClient didFailToChangePinForUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    // In case the user is deregistered on the server side the SDK will return the ONGGenericErrorUserDeregistered error. There are a few reasons why this can
    // happen (e.g. the user has entered too many failed PIN attempts). The app needs to handle this situation by deleting any locally stored data for the
    // deregistered user.
    // In case the entire device registration has been removed from the Token Server the SDK will return the ONGGenericErrorDeviceDeregistered error. In this
    // case the application needs to remove any locally stored data that is associated with any user. It is probably best to reset the app in the state as if
    // the user is starting up the app for the first time.
    if (error.code == ONGGenericErrorDeviceDeregistered || error.code == ONGGenericErrorUserDeregistered) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

    [self showError:error];

    self.completion();

    if (self.progressStateDidChange != nil) {
        self.progressStateDidChange(NO);
    }
}

- (void)showError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change pin error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
