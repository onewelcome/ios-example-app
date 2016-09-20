// Copyright (c) 2016 Onegini. All rights reserved.

#import <UIKit/UIKit.h>

@interface MobileAuthenticationController : NSObject

@property (nonatomic, readonly) UINavigationController *navigationController;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (BOOL)handleMobileAuthenticationRequest:(NSDictionary *)userInfo;

@end