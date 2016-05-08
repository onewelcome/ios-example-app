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
#import "WelcomeViewController.h"

@implementation AppDelegate

+ (UINavigationController *)sharedNavigationController {
    static UINavigationController *sharedNavigationController;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNavigationController = [[UINavigationController alloc]initWithRootViewController:[WelcomeViewController new]];
        sharedNavigationController.navigationBarHidden = YES;
    });
    return sharedNavigationController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [OneginiClientBuilder buildClient];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [AppDelegate sharedNavigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[OGOneginiClient sharedInstance] handleAuthorizationCallback:url];
    return YES;
}

@end
