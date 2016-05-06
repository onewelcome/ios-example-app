//
//  ApplicationRouter.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 6/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

@import UIKit;

@class AuthRouter;

@interface ApplicationRouter : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAuthRouter:(AuthRouter *)authRouter;

- (void)executeInWindow:(UIWindow *)window;

@end
