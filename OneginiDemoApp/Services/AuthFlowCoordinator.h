//
//  AuthFlowCoordinator.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@interface AuthFlowCoordinator : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAuthCoordinator:(AuthCoordinator *)authCoordinator;

- (void)executeInWindow:(UIWindow *)window;

@end
