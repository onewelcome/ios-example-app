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

#import "MobileAuthenticationOperation.h"
#import "PinViewController.h"
#import "PushConfirmationViewController.h"
#import "PinErrorMapper.h"

typedef NS_ENUM(NSInteger, MobileAuthenticationOperationState) {
    MobileAuthenticationOperationStateReady,
    MobileAuthenticationOperationStateExecuting,
    MobileAuthenticationOperationStateFinished
};

NSString * MobileAuthenticationOperationStateToKeyPath(MobileAuthenticationOperationState state)
{
    switch (state) {
        case MobileAuthenticationOperationStateReady: return @"ready";
        case MobileAuthenticationOperationStateExecuting: return @"executing";
        case MobileAuthenticationOperationStateFinished: return @"finished";

        default:
            return nil;
    }
};

BOOL MobileAuthenticationOperationStateTransitionValid(MobileAuthenticationOperationState from, MobileAuthenticationOperationState to)
{
    // we're ignoring ability to be cancelled in this example
    switch (from) {
        case MobileAuthenticationOperationStateReady:
            return to == MobileAuthenticationOperationStateExecuting;

        case MobileAuthenticationOperationStateExecuting:
            return to == MobileAuthenticationOperationStateFinished;

        default:
            return NO;
    }
}

@interface MobileAuthenticationOperation ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) MobileAuthenticationOperationState state;
@property (nonatomic) NSLock *stateLock;

@end

@implementation MobileAuthenticationOperation

#pragma mark - Init

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo userClient:(ONGUserClient *)userClient navigationController:(UINavigationController *)navigationController
{

    self = [super init];
    if (self) {
        _userInfo = userInfo;
        _userClient = userClient;
        _navigationController = navigationController;

        _state = MobileAuthenticationOperationStateReady;
        self.stateLock = [NSLock new];
    }

    return self;
}

#pragma mark - ONGMobileAuthenticationRequestDelegate

- (void)userClient:(ONGUserClient *)userClient didReceiveConfirmationChallenge:(void (^)(BOOL confirmRequest))confirmation forRequest:(ONGMobileAuthenticationRequest *)request
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = request.message;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push - %@", request.userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [self.navigationController popViewControllerAnimated:YES];
        confirmation(confirmed);
    };

    [self.navigationController pushViewController:pushVC animated:YES];
}

/**
 * SDK sends challenge in order to authenticated User. In case User has entered invalid pin or SDK wasn't able to
 * connect to the server this method will be invoked again. Developer may want to inspect `challenge.error` property to understand reason of error.
 * In addition to error property `challenge` also maintains `previousFailureCount`, `maxFailureCount` and `remainingFailureCount` that
 * reflects number of attemps left. User gets deregistered once number of attempts exceeded.
 *
 * Note: during errors that are not related to the PIN validation such as network errors attempts counter remains untouched.
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.pinLength = 5;
    self.pinViewController.customTitle = [NSString stringWithFormat:@"Push with pin - %@", challenge.userProfile.profileId];
    __weak MobileAuthenticationOperation *weakSelf = self;

    self.pinViewController.pinEntered = ^(NSString *pin) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [challenge.sender respondWithPin:pin challenge:challenge];
    };

    // It is up to the developer to decide when and how to show PIN entry view controller.
    // For simplicity of the example app we're checking the top-most view controller.
    if (![self.navigationController.topViewController isEqual:self.pinViewController]) {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }

    if (challenge.error) {
        // Please read comments for the PinErrorMapper to understand intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
        [self.pinViewController showError:description];
    }
}

/**
 * In contract with -userClient:didReceivePinChallenge:forRequest: is not going to be called again in case or error - SDK fallbacks to the PIN instead.
 * This also doesn't affect on the PIN attempts count. Thats why we can skip any error handling for the fingerpint challenge.
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveFingerprintChallenge:(ONGFingerprintChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = request.message;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push with fingerprint - %@", request.userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [self.navigationController popViewControllerAnimated:YES];
        if (confirmed){
            [challenge.sender respondWithDefaultPromptForChallenge:challenge];
        } else {
            [challenge.sender cancelChallenge:challenge];
        }
    };

    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didHandleMobileAuthenticationRequest:(ONGMobileAuthenticationRequest *)request
{
    [self finish];
}

- (void)userClient:(ONGUserClient *)userClient didFailToHandleMobileAuthenticationRequest:(ONGMobileAuthenticationRequest *)request error:(NSError *)error
{
    if (error.code == ONGGenericErrorUserDeregistered || error.code == ONGGenericErrorDeviceDeregistered) {
        // In case the user is deregistered on the server side the SDK will return the ONGGenericErrorUserDeregistered error. There are a few reasons why this can
        // happen (e.g. the user has entered too many failed PIN attempts). The app needs to handle this situation by deleting any locally stored data for the
        // deregistered user.
        // In case the entire device registration has been removed from the Token Server the SDK will return the ONGGenericErrorDeviceDeregistered error. In this
        // case the application needs to remove any locally stored data that is associated with any user. It is probably best to reset the app in the state as if
        // the user is starting up the app for the first time.
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (error.code == ONGMobileAuthenticationRequestErrorNotFound) {
        // For some reason the mobile authentication request cannot be found on the Token Server anymore. This can happen if a push notification
        // was delivered with a huge delay and a mobile authentication request was already removed from the Token Server because it expired.
    } else if (error.code == ONGGenericErrorActionCancelled) {
        // If a challenge has been cancelled then the ONGGenericErrorActionCancelled error is returned. You can use this error to determine whether a mobile
        // authentication request was cancelled. You can also ignore it if you are not interested in this.
    }

    [self finish];
}

#pragma mark - NSOperation Machinery

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isReady
{
    return self.state == MobileAuthenticationOperationStateReady && [super isReady];
}

- (BOOL)isExecuting
{
    return self.state == MobileAuthenticationOperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.state == MobileAuthenticationOperationStateFinished;
}

- (void)start
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MobileAuthenticationOperationStateExecuting;
        self.pinViewController = [[PinViewController alloc] init];

        [self.userClient handleMobileAuthenticationRequest:self.userInfo delegate:self];
    });
}

- (void)finish
{
    self.state = MobileAuthenticationOperationStateFinished;
}

#pragma mark - State Handling

- (void)setState:(MobileAuthenticationOperationState)state
{
    [self.stateLock lock];

    if (MobileAuthenticationOperationStateTransitionValid(_state, state)) {
        NSString *fromStateKeyPath = MobileAuthenticationOperationStateToKeyPath(_state);
        NSString *toStateKeyPath = MobileAuthenticationOperationStateToKeyPath(state);

        [self willChangeValueForKey:fromStateKeyPath];
        [self willChangeValueForKey:toStateKeyPath];

        _state = state;

        [self didChangeValueForKey:fromStateKeyPath];
        [self didChangeValueForKey:toStateKeyPath];
    }

    [self.stateLock unlock];
}

@end