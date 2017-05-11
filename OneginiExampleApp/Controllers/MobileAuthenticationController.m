// Copyright (c) 2016 Onegini. All rights reserved.

#import "MobileAuthenticationController.h"
#import "ONGUserClient.h"
#import "MobileAuthenticationOperation.h"

@interface MobileAuthenticationController ()

@property (nonatomic) NSOperationQueue *executionQueue;

@end

@implementation MobileAuthenticationController

- (instancetype)initWithUserClient:(ONGUserClient *)userClient navigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _userClient = userClient;

        // SDK can not be called from any background queue, however it is generally a bad idea to reuse shared [NSOperationQueue mainQueue]
        // because we have no control over it and therefore can not guarantee that every mobile request will be handled.
        _executionQueue = [[NSOperationQueue alloc] init];
        self.executionQueue.name = [NSString stringWithFormat:@"%@.%@.executionQueue", [NSBundle mainBundle].bundleIdentifier, NSStringFromClass([self class])];

        // We want to execute our mobile authentication requests as soon as possible
        self.executionQueue.qualityOfService = NSQualityOfServiceUserInteractive;

        // There shouldn't be more than one mobile authentication request handled at a time.
        // Otherwise two requests may start modifying UI stack leading to a quite unexpected behaviour for the User.
        self.executionQueue.maxConcurrentOperationCount = 1;
    }

    return self;
}

- (BOOL)handleMobileAuthenticationRequest:(NSString *)request userProfile:(ONGUserProfile *)userProfile
{
    if (![self.userClient canHandleOTPMobileAuthRequest:request]) {
        return NO;
    }

    MobileAuthenticationOperation *operation = [[MobileAuthenticationOperation alloc] initWithOTPRequest:request
                                                                                              userClient:self.userClient
                                                                                    navigationController:self.navigationController];
    [self.executionQueue addOperation:operation];

    return YES;
}

- (BOOL)handlePushMobileAuthenticationRequest:(NSDictionary *)userInfo
{
    // It is easier to implement queue of delayed `-[ONGUserClient handlePushMobileAuthenticationRequest:delegate:]` invocations
    // rather than handling UI elements queuing. Because of this we're ensuring that the given `userInfo` is a valid Onegini's
    // mobile authentication request and delaying actual handling by wrapping it into a NSOperation-based class.
    if (![self.userClient canHandlePushMobileAuthRequest:userInfo]) {
        return NO;
    }

    MobileAuthenticationOperation *operation = [[MobileAuthenticationOperation alloc] initWithUserInfo:userInfo
                                                                                            userClient:self.userClient
                                                                                  navigationController:self.navigationController];
    [self.executionQueue addOperation:operation];

    return YES;
}

@end
