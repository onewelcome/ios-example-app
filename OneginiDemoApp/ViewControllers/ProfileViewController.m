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

@interface ProfileViewController ()

@property (nonatomic, strong) ResourceController *apiClient;

@end

@implementation ProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiClient = [ResourceController new];
    }
    return self;
}

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
    [self.apiClient getProfile:^(Profile *profile, NSError *error) {
    
    }];
}

@end
