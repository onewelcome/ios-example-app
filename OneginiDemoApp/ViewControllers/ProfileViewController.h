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

- (void)profileViewControllerDidTapOnLogout:(ProfileViewController *)viewController;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;

@end
