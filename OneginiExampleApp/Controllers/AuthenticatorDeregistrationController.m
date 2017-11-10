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

#import "AuthenticatorDeregistrationController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ProfileModel.h"
#import "AlertPresenter.h"

@interface AuthenticatorDeregistrationController ()

@property (nonatomic) UINavigationController *presentingViewController;

@property (nonatomic) void (^completion)(void);

@end

@implementation AuthenticatorDeregistrationController

- (instancetype)initWithPresentingViewController:(UINavigationController *)presentingViewController completion:(void (^)(void))completion
{
    self = [super init];
    if (self) {
        self.presentingViewController = presentingViewController;
        self.completion = completion;
    }
    return self;
}

+ (instancetype)controllerWithNavigationController:(UINavigationController *)navigationController
                                        completion:(void (^)(void))completion
{
    return [[self alloc] initWithPresentingViewController:navigationController completion:completion];
}

#pragma mark - ONGAuthenticatorDeregistrationDelegate

- (void)userClient:(ONGUserClient *)userClient didDeregisterAuthenticator:(ONGAuthenticator *)authenticator forUser:(ONGUserProfile *)userProfile
{
    [MBProgressHUD hideHUDForView:self.presentingViewController.view animated:YES];
    [self finish:nil];
}

-(void)userClient:(ONGUserClient *)userClient didFailToDeregisterAuthenticator:(ONGAuthenticator *)authenticator forUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    if (error.code == ONGGenericErrorUserDeregistered) {
        [[ProfileModel new] deleteProfileNameForUserProfile:userProfile];
        [self.presentingViewController popToRootViewControllerAnimated:YES];
    } else if (error.code == ONGGenericErrorDeviceDeregistered) {
        [[ProfileModel new] deleteProfileNames];
        [self.presentingViewController popToRootViewControllerAnimated:YES];
    }
    [MBProgressHUD hideHUDForView:self.presentingViewController.view animated:YES];
    [self finish:error];
}

- (void)userClient:(ONGUserClient *)userClient didReceiveCustomAuthDeregistrationChallenge:(ONGCustomAuthDeregistrationChallenge *)challenge
{
    [challenge.sender continueWithChallenge:challenge];
}

- (void)showError:(NSError *)error
{
    AlertPresenter *errorPresenter = [AlertPresenter createAlertPresenterWithNavigationController:self.presentingViewController];
    [errorPresenter showErrorAlert:error title:@"Authenticator deregistration error"];
}

- (void)finish:(NSError *)error
{
    if (error) {
        [self showError:error];
    }
    if (self.completion) {
        self.completion();
    }
}

@end
