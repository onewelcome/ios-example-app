//  Copyright © 2016 Onegini. All rights reserved.

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
    [[ONGUserClient sharedInstance] logoutUser:^(ONGUserProfile * _Nonnull userProfile, NSError * _Nullable error) {
        [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    }];
}

@end
