// Copyright (c) 2016 Onegini. All rights reserved.

#import "NavigationControllerAppearance.h"

@implementation NavigationControllerAppearance

+ (void)apply:(UINavigationController *)controller
{
    UIImage *background = [UIImage imageNamed:@"background"];
    [controller.navigationBar setBackgroundImage:background forBarMetrics:UIBarMetricsDefault];
    [controller.navigationBar setTintColor:[UIColor whiteColor]];
    [controller.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [controller.toolbar setBackgroundImage:background forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [controller.toolbar setTintColor:[UIColor whiteColor]];
}

@end