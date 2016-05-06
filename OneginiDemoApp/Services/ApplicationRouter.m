//
//  ApplicationRouter.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 6/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ApplicationRouter.h"

#import "AuthFlowCoordinator.h"
#import "OneginiClientBuilder.h"
#import "ProfileViewController.h"

@interface ApplicationRouter () <AuthFlowCoordinatorDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) AuthFlowCoordinator *authFlowCoordinator;

@end

@implementation ApplicationRouter

- (instancetype)initWithAuthFlowCoordinator:(AuthFlowCoordinator *)authFlowCoordinator {
    self = [super init];
    if (self) {
        self.authFlowCoordinator = authFlowCoordinator;
        self.authFlowCoordinator.delegate = self;
    }
    return self;
}

- (void)executeInWindow:(UIWindow *)window {
    self.navigationController = [[UINavigationController alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    window.rootViewController = self.navigationController;
    
    [self.authFlowCoordinator executeInNavigation:self.navigationController];
}

- (void)showProfile {
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController setViewControllers:@[viewController] animated:YES];
}

#pragma mark - AuthFlowCoordinatorDelegate

- (void)authFlowCoordinatorDidFinish:(AuthFlowCoordinator *)coordinator {
    [self showProfile];
}

@end
