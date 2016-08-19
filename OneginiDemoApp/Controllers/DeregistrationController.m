//  Copyright © 2016 Onegini. All rights reserved.

#import "DeregistrationController.h"
#import "AppDelegate.h"

@implementation DeregistrationController

+ (DeregistrationController *)sharedInstance
{
    static DeregistrationController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });

    return singleton;
}

- (void)deregister
{
    OGOneginiClient *client = [OGOneginiClient sharedInstance];
    OGUserProfile *user = [client authenticatedUserProfile];
    if (user != nil) {
        [client deregisterUser:user delegate:self];
    }
}

- (void)deregistrationSuccessful:(OGUserProfile *)userProfile
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
}

- (void)deregistrationFailureWithError:(NSError *)error
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
}

@end
