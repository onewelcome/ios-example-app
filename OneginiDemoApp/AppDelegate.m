//
//  AppDelegate.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AppDelegate.h"
#import "OneginiSDK.h"

#import "OneginiClientBuilder.h"
#import "AuthFlowCoordinator.h"

@interface AppDelegate ()

@property (nonatomic, strong) AuthFlowCoordinator *flowCoordinator;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    OGOneginiClient *client = [OneginiClientBuilder buildClient];
    AuthCoordinator *coordinator = [[AuthCoordinator alloc] initWithOneginiClient:client];
    self.flowCoordinator = [[AuthFlowCoordinator alloc] initWithAuthCoordinator:coordinator];
    [self.flowCoordinator executeInWindow:self.window];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[OGOneginiClient sharedInstance] handleAuthorizationCallback:url];
    return YES;
}

@end
