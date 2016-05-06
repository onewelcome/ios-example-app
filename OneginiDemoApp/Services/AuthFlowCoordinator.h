//
//  AuthFlowCoordinator.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@class AuthFlowCoordinator;

@protocol AuthFlowCoordinatorDelegate <NSObject>

- (void)authFlowCoordinatorDidFinish:(AuthFlowCoordinator *)coordinator;

@end

@interface AuthFlowCoordinator : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAuthCoordinator:(AuthCoordinator *)authCoordinator;

@property (nonatomic, weak) id<AuthFlowCoordinatorDelegate> delegate;

- (void)executeInNavigation:(UINavigationController *)navigationController;

@end
