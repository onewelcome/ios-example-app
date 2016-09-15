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

#import "MobileAuthenticationController.h"
#import "PinViewController.h"
#import "PushConfirmationViewController.h"

@interface MobileAuthenticationController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) void (^completion)();

@end

@implementation MobileAuthenticationController

+ (instancetype)mobileAuthentiactionControllerWithNaviationController:(UINavigationController *)navigationController
                                                           completion:(void (^)())completion
{
    MobileAuthenticationController *mobileAuthenticationController = [MobileAuthenticationController new];
    mobileAuthenticationController.navigationController = navigationController;
    mobileAuthenticationController.completion = completion;
    mobileAuthenticationController.pinViewController = [PinViewController new];
    return mobileAuthenticationController;
}

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

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.pinLength = 5;
    self.pinViewController.customTitle = [NSString stringWithFormat:@"Push with pin - %@", challenge.userProfile.profileId];
    __weak MobileAuthenticationController *weakSelf = self;

    self.pinViewController.pinEntered = ^(NSString *pin) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [challenge.sender respondWithPin:pin challenge:challenge];
    };

    if (challenge.previousFailureCount) {
        NSString *errorMessage = [NSString stringWithFormat:@"Invalid pin. You have still %@ attempts left.", @(challenge.remainingFailureCount)];
        [self.pinViewController showError:errorMessage];
    } else {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }
}

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
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didFailToHandleMobileAuthenticationRequest:(ONGMobileAuthenticationRequest *)request error:(NSError *)error
{
    self.completion();
}

@end
