//
//  LogoutController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 09/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "LogoutController.h"
#import "AppDelegate.h"

@implementation LogoutController

+ (instancetype)sharedInstance
{
    static LogoutController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });

    return singleton;
}

- (void)logout
{
    [[OGOneginiClient sharedInstance] logoutWithDelegate:self];
}

- (void)logoutSuccessful
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
}

- (void)logoutFailureWithError:(NSError *)error
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
}

@end
