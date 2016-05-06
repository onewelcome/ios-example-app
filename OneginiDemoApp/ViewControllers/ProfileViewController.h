//
//  ProfileViewController.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileViewController;

@protocol ProfileViewControllerDelegate <NSObject>

@optional

- (void)profileViewControllerDidTapOnLogout:(ProfileViewController *)viewController;
- (void)profileViewControllerDidTapOnDisconnect:(ProfileViewController *)viewController;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;

@end
