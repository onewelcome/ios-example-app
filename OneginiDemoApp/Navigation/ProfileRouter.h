//
//  ProfileRouter.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 6/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileRouter, Auth;

@protocol ProfileRouterDelegate <NSObject>

- (void)profileRouterDidLogout:(ProfileRouter *)router;
- (void)profileRouterDidDisconnect:(ProfileRouter *)router;

@end

@interface ProfileRouter : NSObject

//- (instancetype)initWithAuthCoordinator:(AuthCoordinator *)authCoordinator;

@property (nonatomic, weak) id<ProfileRouterDelegate> delegate;

- (void)executeInNavigation:(UINavigationController *)navigationController;

@end
