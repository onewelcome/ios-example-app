//
//  AuthenticationOperation.m
//  OneginiExampleApp
//
//  Created by Aleksey on 16.09.16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AuthenticationOperation.h"
#import "MobileAuthenticationController.h"
#import "OneginiSDK.h"

@interface AuthenticationOperation ()

@property (nonatomic) MobileAuthenticationController *mobileAuthenticationController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, getter = isCompleted) BOOL completed;

@end

@implementation AuthenticationOperation: NSOperation

- (void)setCompleted:(BOOL)completed
{
    [self willChangeValueForKey:@"finished"];
    _completed = completed;
    [self didChangeValueForKey:@"finished"];
}

- (BOOL)isFinished
{
    return _completed;
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
                                notification:(NSDictionary *)userInfo
{
    if (self = [super init]) {
        _navigationController = navigationController;
        _userInfo = userInfo;
    }
    
    return self;
}

- (void)main
{
    self.mobileAuthenticationController = [MobileAuthenticationController mobileAuthenticationControllerWithNaviationController:self.navigationController
                                           completion:^{
                                               [self setCompleted:YES];
                                               self.mobileAuthenticationController = nil;
                                           }];
    
    __weak typeof(self) weakSelf = self;
    
    self.mobileAuthenticationController.didDismiss = ^{
        [weakSelf setCompleted:YES];
    };
    
    // todo: anyway code above will be rewritten. Do not delete comment below :)
    
    // Developer needs to be aware that push notifications sometime can be delivered nearly simultaneously.
    // Therefore it is not recommended to share single delegate for all of the incoming mobile authentication requests,
    // since previous request may be in the middle of authentication process (i.e. not finished).
    [[ONGUserClient sharedInstance] handleMobileAuthenticationRequest:self.userInfo delegate:self.mobileAuthenticationController];
    
}

@end
