//
//  PINViewController.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINViewController;

@interface PINViewController : UIViewController

@property (nonatomic, copy) void (^pinEntered)(NSString* pin);

@property (nonatomic) NSUInteger maxCountOfNumbers;

- (void)showError:(NSError *)error;
- (void)wrongPINRemainigAttempts:(NSUInteger)remaining;

@end
