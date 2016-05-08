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

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)logout:(id)sender {
    [[LogoutController sharedInstance]logout];
}

- (IBAction)disconnect:(id)sender {
    [[DisconnectController sharedInstance]disconnect];
}

- (IBAction)getProfile:(id)sender {
    [[ResourceController sharedInstance] getProfile:^(Profile *profile, NSError *error) {
    
    }];
}

@end
