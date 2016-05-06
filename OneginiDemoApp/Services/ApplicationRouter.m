//
//  ApplicationRouter.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 6/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ApplicationRouter.h"

#import "AuthRouter.h"
#import "OneginiClientBuilder.h"
#import "ProfileViewController.h"

@interface ApplicationRouter () <AuthRouterDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) AuthRouter *authRouter;

@end

@implementation ApplicationRouter

- (instancetype)initWithAuthRouter:(AuthRouter *)authRouter {
    self = [super init];
    if (self) {
        self.authRouter = authRouter;
        self.authRouter.delegate = self;
    }
    return self;
}

- (void)executeInWindow:(UIWindow *)window {
    self.navigationController = [[UINavigationController alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    window.rootViewController = self.navigationController;
    
    [self.authRouter executeInNavigation:self.navigationController];
}

- (void)showProfile {
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController setViewControllers:@[viewController] animated:YES];
}

#pragma mark - AuthRouterDelegate

- (void)authRouterDidFinish:(AuthRouter *)router {
    [self showProfile];
}

@end
