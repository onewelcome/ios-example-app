//
//  ProfileRouter.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 6/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ProfileRouter.h"

#import "ProfileViewController.h"

@implementation ProfileRouter

- (void)executeInNavigation:(UINavigationController *)navigationController {
    ProfileViewController *viewController = [ProfileViewController new];
    [navigationController setViewControllers:@[viewController] animated:YES];
}

@end
