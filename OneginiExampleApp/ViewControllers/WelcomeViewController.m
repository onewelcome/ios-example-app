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

#import "WelcomeViewController.h"

#import "AuthenticationController.h"
#import "RegistrationController.h"
#import "UIAlertController+Shortcut.h"
#import "ONGResourceResponse+JSONResponse.h"
#import "MBProgressHUD.h"

@interface WelcomeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSArray<ONGUserProfile *> *profiles;

@property (nonatomic) AuthenticationController *authenticationController;
@property (nonatomic) RegistrationController *registrationController;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIPickerView *profilePicker;
@property (weak, nonatomic) IBOutlet UILabel *appInfoLabel;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.profiles = [[ONGUserClient sharedInstance] userProfiles].allObjects;
    [self.profilePicker reloadAllComponents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appInfoLabel.hidden = YES;

    [self authenticateDeviceAndFetchResource];
}

- (IBAction)registerNewProfile:(id)sender
{
    if (self.authenticationController || self.registrationController)
        return;

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.registrationController = [RegistrationController
        registrationControllerWithNavigationController:self.navigationController
                                            completion:^{
                                                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                self.registrationController = nil;
                                            }];
    [[ONGUserClient sharedInstance] registerUser:@[@"read"] delegate:self.registrationController];
}

- (IBAction)login:(id)sender
{
    if ([self.profiles count] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"No registered profiles"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction
            actionWithTitle:@"Ok"
                      style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction *action) {
                    }];
        [alert addAction:okButton];
        [self.navigationController presentViewController:alert animated:YES completion:nil];

        return;
    }
    if (self.authenticationController || self.registrationController)
        return;

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    ONGUserProfile *selectedUserProfile = [self selectedProfile];
    self.authenticationController = [AuthenticationController
        authenticationControllerWithNavigationController:self.navigationController
                                              completion:^{
                                                  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                  self.authenticationController = nil;
                                              }];
    __weak typeof(self) weakSelf = self;
    self.authenticationController.progressStateDidChange = ^(BOOL isInProgress) {
        if (isInProgress) {
            [MBProgressHUD showHUDAddedTo:weakSelf.navigationController.view animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        }
    };

    [[ONGUserClient sharedInstance] authenticateUser:selectedUserProfile delegate:self.authenticationController];
}

- (void)authenticateDeviceAndFetchResource
{
    [[ONGDeviceClient sharedInstance] authenticateDevice:@[@"application-details"] completion:^(BOOL success, NSError *_Nullable error) {
        if (success) {
            [self fetchApplicationDetails];
        } else {
            // unwind stack in case we've opened registration
            [self.navigationController popToRootViewControllerAnimated:YES];

            NSString *title = @"Device authentication failed";
            UIAlertController *alert = [UIAlertController controllerWithTitle:title message:error.localizedDescription completion:nil];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)fetchApplicationDetails
{
    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"resources/application-details" method:@"GET"];
    [[ONGDeviceClient sharedInstance] fetchResource:request completion:^(ONGResourceResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            UIAlertController *controller = [UIAlertController controllerWithTitle:@"Error" message:error.localizedDescription completion:nil];
            [self presentViewController:controller animated:YES completion:nil];
        } else {
            id jsonResponse = [response JSONResponse];
            if (jsonResponse != nil) {
                self.appInfoLabel.text = [NSString stringWithFormat:
                    @"%@\n%@\n%@",
                    [jsonResponse objectForKey:@"application_identifier"],
                    [jsonResponse objectForKey:@"application_platform"],
                    [jsonResponse objectForKey:@"application_version"]
                ];

                self.appInfoLabel.hidden = NO;
            }
        }
    }];
}

- (ONGUserProfile *)selectedProfile
{
    NSUInteger profileIndex = (NSUInteger)[self.profilePicker selectedRowInComponent:0];
    return self.profiles[profileIndex];
}

#pragma mark - UIPickerView

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.profiles.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return (self.profiles[(NSUInteger)row]).profileId;
}

@end
