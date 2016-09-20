// Copyright (c) 2016 Onegini. All rights reserved.

#import <UIKit/UIKit.h>

@class ONGUserClient;

@interface MobileAuthenticationController : NSObject

@property (nonatomic, readonly) ONGUserClient *userClient;
@property (nonatomic, readonly) UINavigationController *navigationController;

- (instancetype)initWithUserClient:(ONGUserClient *)userClient navigationController:(UINavigationController *)navigationController;

- (BOOL)handleMobileAuthenticationRequest:(NSDictionary *)userInfo;

@end