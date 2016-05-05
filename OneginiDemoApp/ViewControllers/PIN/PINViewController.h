//
//  PINViewController.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINViewController;

@protocol PINViewControllerDelegate <NSObject>

- (void)pinViewController:(PINViewController *)viewController didEnterPIN:(NSString *)pin;

@end

@interface PINViewController : UIViewController

@property (nonatomic, weak) id<PINViewControllerDelegate> delegate;

@property (nonatomic) NSUInteger maxCountOfNumbers;

- (void)showError:(NSError *)error;
- (void)wrongPINRemainigAttempts:(NSUInteger)remaining;

@end
