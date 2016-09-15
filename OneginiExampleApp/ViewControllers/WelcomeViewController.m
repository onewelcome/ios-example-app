//  Copyright © 2016 Onegini. All rights reserved.

#import "WelcomeViewController.h"
#import "AuthenticationController.h"
#import "RegistrationController.h"
#import "MBProgressHUD.h"

@interface WelcomeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSArray<ONGUserProfile *> *profiles;

@property (nonatomic) AuthenticationController *authenticationController;
@property (nonatomic) RegistrationController *registrationController;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIPickerView *profilePicker;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.profiles = [[ONGUserClient sharedInstance] userProfiles].allObjects;
    [self.profilePicker reloadAllComponents];
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

- (IBAction)authenticateClient:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[ONGDeviceClient sharedInstance] authenticateDevice:@[@"read"] completion:^(BOOL success, NSError *_Nullable error) {
        NSString *message;
        if (success) {
            message = @"Device authentication succeeded";
        } else {
            message = @"Device authentication failed";
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:message
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okButton];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
