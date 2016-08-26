//  Copyright © 2016 Onegini. All rights reserved.

#import "WelcomeViewController.h"
#import "AuthorizationController.h"
#import "RegistrationController.h"
#import "OneginiSDK.h"
#import "ClientAuthenticationController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIPickerView *profilePicker;
@property (nonatomic) NSArray<ONGUserProfile *> *profiles;

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
    [[RegistrationController sharedInstance] registerNewUser];
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
        [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    ONGUserProfile *userProfile = self.profiles[[self.profilePicker selectedRowInComponent:0]];
    [[AuthorizationController sharedInstance] authenticateUser:userProfile];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.profiles.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ((ONGUserProfile*)self.profiles[row]).profileId;
}

- (IBAction)authenticateClient:(id)sender
{
    [[ClientAuthenticationController sharedInstance] authenticateClient];
}

@end
