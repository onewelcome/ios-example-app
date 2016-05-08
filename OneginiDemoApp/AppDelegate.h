//
//  AppDelegate.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (UINavigationController *)sharedNavigationController;
@property (strong, nonatomic) UIWindow *window;

@end
