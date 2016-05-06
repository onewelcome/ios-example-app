//
//  ApplicationRouter.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 6/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ApplicationRouter.h"

#import "AuthRouter.h"
#import "ProfileRouter.h"
#import "OneginiSDK.h"

@interface ApplicationRouter ()
<
    AuthRouterDelegate,
    ProfileRouterDelegate
>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) AuthRouter *authRouter;
@property (nonatomic, strong) ProfileRouter *profileRouter;

@end

@implementation ApplicationRouter

- (instancetype)initWithAuthRouter:(AuthRouter *)authRouter profileRouter:(ProfileRouter *)profileRouter {
    self = [super init];
    if (self) {
        self.authRouter = authRouter;
        self.authRouter.delegate = self;
        
        self.profileRouter = profileRouter;
        self.profileRouter.delegate = self;
        
        self.navigationController = [[UINavigationController alloc] init];
        [self.navigationController setNavigationBarHidden:YES];
    }
    return self;
}

- (void)executeInWindow:(UIWindow *)window {
    window.rootViewController = self.navigationController;
    [self showAuthorization];
}

- (void)showAuthorization {
    [self.authRouter executeInNavigation:self.navigationController];
}

- (void)showProfile {
    [self.profileRouter executeInNavigation:self.navigationController];
}

#pragma mark - AuthRouterDelegate

- (void)authRouterDidFinish:(AuthRouter *)router {
    [self showProfile];
}

#pragma mark - ProfileRouterDelegate

- (void)profileRouterDidLogout:(ProfileRouter *)router {
    [[OGOneginiClient sharedInstance] logoutWithDelegate:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self showAuthorization];
}

- (void)profileRouterDidDisconnect:(ProfileRouter *)router {
    [[OGOneginiClient sharedInstance] disconnectWithDelegate:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self showAuthorization];
}

@end
