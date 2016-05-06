//
//  AuthRouter.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@class AuthRouter;

@protocol AuthRouterDelegate <NSObject>

- (void)authRouterDidFinish:(AuthRouter *)router;

@end

@interface AuthRouter : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAuthCoordinator:(AuthCoordinator *)authCoordinator;

@property (nonatomic, weak) id<AuthRouterDelegate> delegate;

- (void)executeInNavigation:(UINavigationController *)navigationController;

@end
