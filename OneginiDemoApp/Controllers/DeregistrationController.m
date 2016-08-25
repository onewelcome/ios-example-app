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
    ONGUserClient *client = [ONGUserClient sharedInstance];
    ONGUserProfile *user = [client authenticatedUserProfile];
    if (user != nil) {
        [client deregisterUser:user completion:^(BOOL deregistered, NSError * _Nullable error) {
            [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
        }];
    }
}

@end
