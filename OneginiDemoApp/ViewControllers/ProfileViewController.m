//
//  ProfileViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ProfileViewController.h"
#import "ResourceController.h"
#import "LogoutController.h"
#import "DisconnectController.h"
#import "Profile.h"

@interface ProfileViewController()

@property (weak, nonatomic) IBOutlet UIView *profileDataView;
@property (weak, nonatomic) IBOutlet UILabel *profileMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *getProfileSpinner;
@property (weak, nonatomic) IBOutlet UIButton *getProfileButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getProfileButton.hidden = YES;
    self.profileDataView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getProfile];
}

- (IBAction)logout:(id)sender {
    [[LogoutController sharedInstance]logout];
}

- (IBAction)disconnect:(id)sender {
    [[DisconnectController sharedInstance]disconnect];
}

- (IBAction)getProfile:(id)sender {
    [self getProfile];
}

- (void)getProfile{
    self.getProfileSpinner.hidden = NO;
    [[ResourceController sharedInstance] getProfile:^(Profile *profile, NSError *error) {
        self.getProfileSpinner.hidden = YES;
        if(profile){
            self.profileDataView.hidden = NO;
            self.profileMailLabel.text = profile.email;
            self.profileNameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName, profile.lastName];
        } else {
            self.getProfileButton.hidden = NO;
            [self showError:@"Downloading profile failed."];
        }
    }];
}

- (void)showError:(NSString*)error{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Resource error"
                                                                    message:error
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
