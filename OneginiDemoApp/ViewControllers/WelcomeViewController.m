//
//  WelcomeViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AuthorizationController.h"
#import "OGOneginiClient.h"
#import "OneginiSDK.h"
#import "ClientAuthenticationController.h"

@interface WelcomeViewController() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIPickerView *profilePicker;
@property (nonatomic) NSArray<OGUserProfile*>* profiles;

@end

@implementation WelcomeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.profiles = [[[OGOneginiClient sharedInstance] enrolledProfiles] allObjects];
    [self.profilePicker reloadAllComponents];
}

- (IBAction)registerNewProfile:(id)sender {
    [[AuthorizationController sharedInstance] registerNewProfile];
}

- (IBAction)login:(id)sender {
    NSString *selectedProfileId = [self.profiles objectAtIndex:[self.profilePicker selectedRowInComponent:0]].profileId;
    [[AuthorizationController sharedInstance] loginWithProfile:selectedProfileId];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.profiles.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return ((OGUserProfile*)self.profiles[row]).profileId;
}
- (IBAction)authenticateClient:(id)sender {
    [[ClientAuthenticationController sharedInstance]authenticateClient];
}

@end
