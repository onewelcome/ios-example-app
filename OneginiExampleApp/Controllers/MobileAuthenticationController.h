// Copyright (c) 2016 Onegini. All rights reserved.

#import <UIKit/UIKit.h>

@class ONGUserClient;
@class ONGUserProfile;

// Due to nature of mobile request authentication that requires user interaction it appears that more notifications than
// one notification can be received by the app.
// In order to prevent overlapping of the Pin UI develop may want to handle mobile auth requests as a queue. 
@interface MobileAuthenticationController : NSObject

@property (nonatomic, readonly) ONGUserClient *userClient;
@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, readonly) UITabBarController *tabBarController;

- (instancetype)initWithUserClient:(ONGUserClient *)userClient navigationController:(UINavigationController *)navigationController tabBarController:(UITabBarController *)tabBarController;

- (BOOL)handleMobileAuthenticationRequest:(NSString *)request userProfile:(ONGUserProfile *)userProfile;

- (BOOL)handlePushMobileAuthenticationRequest:(NSDictionary *)userInfo;

@end
