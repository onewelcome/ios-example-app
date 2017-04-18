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

#import "ProfileViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import "ChangePinController.h"
#import "TextViewController.h"
#import "SettingsViewController.h"

#import "ONGResourceResponse+JSONResponse.h"
#import "UIBarButtonItem+Extension.h"
#import "ProfileModel.h"
#import "MobileAuthModel.h"

@interface ProfileViewController ()

@property (nonatomic) ChangePinController *changePinController;

@property (weak, nonatomic) IBOutlet UIButton *enrollForMobileAuthButton;
@property (weak, nonatomic) IBOutlet UISwitch *enrolledForMobileAuthSwitch;
@property (weak, nonatomic) IBOutlet UIButton *enrollForPushMobileAuthButton;
@property (weak, nonatomic) IBOutlet UISwitch *enrolledForPushMobileAuthSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *getTokenSpinner;

@end

@implementation ProfileViewController

#pragma mark - Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem keyImageBarButtonItem];
    self.getTokenSpinner.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.enrolledForMobileAuthSwitch.on = [ONGUserClient sharedInstance].isEnrolledForMobileAuth;
    self.enrolledForPushMobileAuthSwitch.on = [ONGUserClient sharedInstance].isEnrolledForPushMobileAuth;
}

#pragma mark - IBAction

- (IBAction)logout:(id)sender
{
    [[ONGUserClient sharedInstance] logoutUser:^(ONGUserProfile *_Nonnull userProfile, NSError *_Nullable error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        if (error) {
            [self showError:error.description];
        }
    }];
}

- (IBAction)disconnect:(id)sender
{
    ONGUserClient *client = [ONGUserClient sharedInstance];
    ONGUserProfile *user = [client authenticatedUserProfile];
    if (user != nil) {
        [client deregisterUser:user completion:^(BOOL deregistered, NSError *_Nullable error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)getDevicesList:(id)sender
{
    self.getTokenSpinner.hidden = NO;

    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"resources/devices" method:@"GET"];
    [[ONGUserClient sharedInstance] fetchResource:request completion:^(ONGResourceResponse *_Nullable response, NSError *_Nullable error) {
        self.getTokenSpinner.hidden = YES;

        if (response && response.statusCode < 300) {
            [self displayJSONResponse:[response JSONResponse]];
        } else {
            [self showError:error.localizedDescription];
        }
    }];
}

- (IBAction)enrollForMobileAuthentication:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    [[ONGUserClient sharedInstance] enrollForMobileAuth:^(BOOL enrolled, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        self.enrolledForMobileAuthSwitch.on = enrolled;
        if (enrolled) {
            [self showMessage:@"Enrolled successfully"];
        } else {
            [self handleMobileAuthError:error];
        }
    }];
}

- (IBAction)enrollForPushMobileAuthentication:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[ONGUserClient sharedInstance] enrollForPushMobileAuthWithDeviceToken:[MobileAuthModel sharedInstance].deviceToken
                                                                completion:^(BOOL enrolled, NSError * _Nullable error) {
                                                                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                                    self.enrolledForPushMobileAuthSwitch.on = enrolled;
                                                                    if (enrolled) {
                                                                        [self showMessage:@"Enrolled successfully"];
                                                                    } else {
                                                                        [self handleMobileAuthError:error];
                                                                    }
                                                                }];
}

- (void)handleMobileAuthError:(NSError *)error
{
    ONGUserProfile *userProfile = [ONGUserClient sharedInstance].authenticatedUserProfile;
    NSString *alertMessage = nil;
    if (error) {
        switch (error.code) {
            case ONGGenericErrorUserDeregistered:
                [[ProfileModel new] deleteProfileNameForUserProfile:userProfile];
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            case ONGGenericErrorDeviceDeregistered:
                [[ProfileModel new] deleteProfileNames];
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            case ONGMobileAuthEnrollmentErrorUserNotAuthenticated:
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
        }
        alertMessage = error.localizedDescription;
    } else {
        alertMessage = @"Enrollment failed";
    }
    [self showError:alertMessage];
}

- (IBAction)changePin:(id)sender
{
    if (self.changePinController)
        return;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.changePinController = [ChangePinController
        changePinControllerWithNavigationController:self.navigationController
                                         completion:^{
                                             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                             self.changePinController = nil;
                                         }];

    __weak typeof(self) weakSelf = self;
    self.changePinController.progressStateDidChange = ^(BOOL isInProgress) {
        if (isInProgress) {
            [MBProgressHUD showHUDAddedTo:weakSelf.navigationController.view animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        }
    };
    [[ONGUserClient sharedInstance] changePin:self.changePinController];
}

- (IBAction)presentSettings:(id)sender
{
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - Logic

- (void)showError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showMessage:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                   message:error
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Misc

- (void)displayJSONResponse:(id)JSONResponse
{
    TextViewController *controller = [TextViewController new];
    controller.text = [JSONResponse description];

    [self presentViewController:controller animated:YES completion:NULL];
}

@end
