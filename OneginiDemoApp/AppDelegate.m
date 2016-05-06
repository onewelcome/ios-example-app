//
//  AppDelegate.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AppDelegate.h"
#import "OneginiSDK.h"

#import "ApplicationRouter.h"
#import "OneginiClientBuilder.h"
#import "AuthRouter.h"
#import "ProfileRouter.h"

@interface AppDelegate ()

@property (nonatomic, strong) ApplicationRouter *applicationRouter;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.applicationRouter = [self buildApplicationRouter];
    [self.applicationRouter executeInWindow:self.window];
    
    return YES;
}

- (ApplicationRouter *)buildApplicationRouter {
    OGOneginiClient *client = [OneginiClientBuilder buildClient];
    AuthCoordinator *coordinator = [[AuthCoordinator alloc] initWithOneginiClient:client];
    AuthRouter *authRouter = [[AuthRouter alloc] initWithAuthCoordinator:coordinator];
    ProfileRouter *profileRouter = [ProfileRouter new];

    ApplicationRouter *router = [[ApplicationRouter alloc] initWithAuthRouter:authRouter profileRouter:profileRouter];
    
    return router;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[OGOneginiClient sharedInstance] handleAuthorizationCallback:url];
    return YES;
}

@end
