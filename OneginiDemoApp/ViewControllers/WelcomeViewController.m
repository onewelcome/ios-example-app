//  Copyright © 2016 Onegini. All rights reserved.

#import "WelcomeViewController.h"
#import "AuthorizationController.h"
#import "ClientAuthenticationController.h"

@interface WelcomeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIPickerView *profilePicker;
@property (nonatomic) NSArray<OGUserProfile *> *profiles;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.profiles = [[OGOneginiClient sharedInstance] userProfiles].allObjects;
    [self.profilePicker reloadAllComponents];
}

- (IBAction)registerNewProfile:(id)sender
{
    [[AuthorizationController sharedInstance] registerNewUser];
}

- (IBAction)login:(id)sender
{
    OGUserProfile *userProfile = self.profiles[[self.profilePicker selectedRowInComponent:0]];
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ((OGUserProfile *)self.profiles[row]).profileId;
}

- (IBAction)authenticateClient:(id)sender
{
    [[ClientAuthenticationController sharedInstance] authenticateClient];
}

@end
