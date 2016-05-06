//
//  ProfileRouter.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 6/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ProfileRouter.h"

#import "ProfileViewController.h"

@interface ProfileRouter() <ProfileViewControllerDelegate>

@end

@implementation ProfileRouter
//
//- (instancetype)initWithAuthCoordinator:(AuthCoordinator *)authCoordinator
//{
//    return retu;
//}

- (void)executeInNavigation:(UINavigationController *)navigationController {
    ProfileViewController *viewController = [ProfileViewController new];
    viewController.delegate = self;
    
    [navigationController setViewControllers:@[viewController] animated:YES];
}

#pragma mark - ProfileViewControllerDelegate

- (void)profileViewControllerDidTapOnLogout:(ProfileViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(profileRouterDidLogout:)]) {
        [self.delegate profileRouterDidLogout:self];
    }
}

- (void)profileViewControllerDidTapOnDisconnect:(ProfileViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(profileRouterDidDisconnect:)]) {
        [self.delegate profileRouterDidDisconnect:self];
    }
}

@end
