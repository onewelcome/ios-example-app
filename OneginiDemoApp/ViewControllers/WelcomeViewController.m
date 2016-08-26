//  Copyright © 2016 Onegini. All rights reserved.

#import "WelcomeViewController.h"
#import "AuthenticationController.h"
#import "RegistrationController.h"

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

    self.registrationController = [RegistrationController
        registrationControllerWithNavigationController:self.navigationController
                                            completion:^{
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

    ONGUserProfile *selectedUserProfile = [self selectedProfile];
    self.authenticationController = [AuthenticationController
        authenticationControllerWithNavigationController:self.navigationController
                                              completion:^{
                                                  self.authenticationController = nil;
                                              }];
    [[ONGUserClient sharedInstance] authenticateUser:selectedUserProfile delegate:self.authenticationController];
}

- (IBAction)authenticateClient:(id)sender
{
    [[ONGDeviceClient sharedInstance] authenticateDevice:@[@"read"] completion:^(BOOL success, NSError *_Nullable error) {
        NSString *message;
        if (success) {
            message = @"Device authentication successful";
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
