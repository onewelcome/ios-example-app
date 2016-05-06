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

- (void)executeInNavigation:(UINavigationController *)navigationController {
    ProfileViewController *viewController = [ProfileViewController new];
    viewController.delegate = self;
    
    [navigationController setViewControllers:@[viewController] animated:YES];
}

#pragma mark - ProfileViewControllerDelegate

- (void)profileViewControllerDidTapOnLogout:(ProfileViewController *)viewController {
    [self.delegate profileRouterDidLogout:self];
}

@end
