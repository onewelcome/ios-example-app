// Copyright (c) 2016 Onegini. All rights reserved.

#import "MobileAuthenticationController.h"
#import "ONGUserClient.h"
#import "MobileAuthenticationOperation.h"

@interface MobileAuthenticationController ()

@property (nonatomic) NSOperationQueue *executionQueue;

@end

@implementation MobileAuthenticationController {
}
- (instancetype)initWithUserClient:(ONGUserClient *)userClient navigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _userClient = userClient;

        _executionQueue = [[NSOperationQueue alloc] init];
        // We want to execute our mobile authentication requests as soon as possible
        self.executionQueue.qualityOfService = NSQualityOfServiceUserInteractive;
        self.executionQueue.maxConcurrentOperationCount = 1;
    }

    return self;
}

- (BOOL)handleMobileAuthenticationRequest:(NSDictionary *)userInfo
{
    if (![self.userClient canHandleMobileAuthenticationRequest:userInfo]) {
        return NO;
    }

    MobileAuthenticationOperation *operation = [[MobileAuthenticationOperation alloc] initWithUserInfo:userInfo
                                                                                            userClient:self.userClient
                                                                                  navigationController:self.navigationController];
    [self.executionQueue addOperation:operation];

    return YES;
}

@end