//
//  ProfileViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIClient.h"

@interface ProfileViewController ()

@property (nonatomic, strong) APIClient *apiClient;

@end

@implementation ProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiClient = [APIClient new];
    }
    return self;
}

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
    [self.apiClient getProfile:^(Profile *profile, NSError *error) {
    
    }];
}

@end
