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

#import "FingerprintController.h"
#import "ChangePinController.h"
#import "TextViewController.h"

#import "ONGResourceResponse+JSONResponse.h"

@interface ProfileViewController ()

@property (nonatomic) ChangePinController *changePinController;
@property (nonatomic) FingerprintController *fingerprintController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *getTokenSpinner;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.getTokenSpinner.hidden = YES;

    [self updateViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateViews];
}

- (void)updateViews
{
    if ([self isFingerprintEnrolled]) {
        [self.fingerprintButton setTitle:@"Disable fingerprint authentication" forState:UIControlStateNormal];
    } else {
        [self.fingerprintButton setTitle:@"Enroll for fingerprint authentication" forState:UIControlStateNormal];
    }
}

- (IBAction)logout:(id)sender
{
    [[ONGUserClient sharedInstance] logoutUser:^(ONGUserProfile * _Nonnull userProfile, NSError * _Nullable error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)disconnect:(id)sender
{
    ONGUserClient *client = [ONGUserClient sharedInstance];
    ONGUserProfile *user = [client authenticatedUserProfile];
    if (user != nil) {
        [client deregisterUser:user completion:^(BOOL deregistered, NSError * _Nullable error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)getDevicesList:(id)sender
{
    self.getTokenSpinner.hidden = NO;

    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"resources/devices" method:@"GET"];
    [[ONGUserClient sharedInstance] fetchResource:request completion:^(ONGResourceResponse * _Nullable response, NSError * _Nullable error) {
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
    [[ONGUserClient sharedInstance] enrollForMobileAuthentication:^(BOOL enrolled, NSError * _Nullable error) {
        NSString *alertTitle = nil;
        if (enrolled) {
            alertTitle = @"Enrolled successfully";
        } else {
            alertTitle = @"Enrollment failure";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okButton];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)changePin:(id)sender
{
    if (self.changePinController)
        return;

    self.changePinController = [ChangePinController
        changePinControllerWithNavigationController:self.navigationController
                                         completion:^{
                                             self.changePinController = nil;
                                         }];
    [[ONGUserClient sharedInstance] changePin:self.changePinController];
}

- (IBAction)enrollForFingerprintAuthentication:(id)sender
{
    if ([self isFingerprintEnrolled]) {
        [self deregisterFingerprint];
    } else {
        [self registerFingerprint];
    }
    [self updateViews];
}

- (void)registerFingerprint
{
    if (self.fingerprintController)
        return;

    ONGUserProfile *userProfile = [ONGUserClient sharedInstance].authenticatedUserProfile;
    NSSet<ONGAuthenticator *> *authenticators = [[ONGUserClient sharedInstance] nonRegisteredAuthenticatorsForUser:userProfile];
    ONGAuthenticator *fingerprintAuthenticator = [self fingerprintAuthenticatorFromSet:authenticators];
    self.fingerprintController = [FingerprintController
        fingerprintControllerWithNavigationController:self.navigationController
                                           completion:^{
                                               self.fingerprintController = nil;
                                           }];
    [[ONGUserClient sharedInstance] registerAuthenticator:fingerprintAuthenticator delegate:self.fingerprintController];

}

-(void)deregisterFingerprint
{
    ONGUserProfile *userProfile = [ONGUserClient sharedInstance].authenticatedUserProfile;
    NSSet *registeredAuthenticators = [[ONGUserClient sharedInstance] registeredAuthenticatorsForUser:userProfile];
    ONGAuthenticator *fingerprintAuthenticator = [self fingerprintAuthenticatorFromSet:registeredAuthenticators];
    [[ONGUserClient sharedInstance] deregisterAuthenticator:fingerprintAuthenticator completion:nil];
}

- (BOOL)isFingerprintEnrolled
{
    ONGUserProfile *userProfile = [ONGUserClient sharedInstance].authenticatedUserProfile;
    NSSet *registeredAuthenticators = [[ONGUserClient sharedInstance] registeredAuthenticatorsForUser:userProfile];
    ONGAuthenticator *fingerprintAuthenticator = [self fingerprintAuthenticatorFromSet:registeredAuthenticators];
    return fingerprintAuthenticator != nil;
}

- (ONGAuthenticator *)fingerprintAuthenticatorFromSet:(NSSet<ONGAuthenticator *> *)authenticators{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d", ONGAuthenticatorTouchID];
    return [authenticators filteredSetUsingPredicate:predicate].anyObject;
}

- (void)showError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Resource error"
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
