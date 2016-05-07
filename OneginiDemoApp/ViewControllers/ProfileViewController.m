//
//  ProfileViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIClient.h"

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)logout:(id)sender {
    if ([self.delegate respondsToSelector:@selector(profileViewControllerDidTapOnLogout:)]) {
        [self.delegate profileViewControllerDidTapOnLogout:self];
    }
}

- (IBAction)disconnect:(id)sender {
    if ([self.delegate respondsToSelector:@selector(profileViewControllerDidTapOnDisconnect:)]) {
        [self.delegate profileViewControllerDidTapOnDisconnect:self];
    }
}

- (IBAction)getProfile:(id)sender {
    [[APIClient sharedClient] getProfile:^(Profile *profile, NSError *error) {
    
    }];
}

@end
