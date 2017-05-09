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
#import "ProfileModel.h"
#import "AppDelegate.h"
#import "MobileAuthenticationController.h"

@interface ProfileViewController ()

@property (nonatomic) ChangePinController *changePinController;

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

- (IBAction)mobileAuthWithOTP:(id)sender
{
    NSString *profileName = [[ProfileModel new] profileNameForUserProfile:[ONGUserClient sharedInstance].authenticatedUserProfile];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Mobile Authentication with OTP"
                                                                   message:[NSString stringWithFormat:@"Authenticated user: %@",profileName]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {}];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Authenticate"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                         NSString *otpRequest = alert.textFields[0].text;
                                                         [appDelegate.mobileAuthenticationController handleMobileAuthenticationRequest:otpRequest userProfile:[ONGUserClient sharedInstance].authenticatedUserProfile];
                                                     }];
    [alert addAction:okButton];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){}];
    [alert addAction:cancelButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
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
