// Copyright (c) 2016 Onegini. All rights reserved.

#import "MobileAuthenticationController.h"
#import "ONGUserClient.h"
#import "MobileAuthenticationOperation.h"

@implementation MobileAuthenticationController {
}
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }

    return self;
}

- (BOOL)handleMobileAuthenticationRequest:(NSDictionary *)userInfo
{




//    AuthenticationOperation *operation = [[AuthenticationOperation alloc] initWithNavigationController:(UINavigationController *)self.window.rootViewController
//                                                                                          notification:userInfo];
//
//    [[NSOperationQueue mainQueue] addOperation:operation];



    MobileAuthenticationOperation *delegate = [MobileAuthenticationOperation mobileAuthenticationControllerWithNaviationController:self.navigationController completion:^{
        // throwing away delegate from the storage
    }];

    BOOL handled =  [[ONGUserClient sharedInstance] handleMobileAuthenticationRequest:userInfo delegate:delegate];

    if (handled) {
        // store delegate
    }

    return handled;
}

@end