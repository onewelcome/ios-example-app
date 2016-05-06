//
//  WelcomeViewController.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelcomeViewController;

@protocol WelcomeViewControllerDelegate <NSObject>

- (void)welcomeViewControllerDidTapLogin:(WelcomeViewController *)viewController;

@end

@interface WelcomeViewController : UIViewController

@property (nonatomic, weak) id<WelcomeViewControllerDelegate> delegate;

@end
