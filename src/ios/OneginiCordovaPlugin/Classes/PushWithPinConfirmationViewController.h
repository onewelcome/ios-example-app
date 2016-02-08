//
//  PushWithPinConfirmationViewController.h
//  OneginiCordovaPlugin
//
//  Created by Stanisław Brzeski on 27/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGAuthorizationDelegate.h"

@interface PushWithPinConfirmationViewController : UIViewController

-(instancetype)initWithMessage:(NSString*)message retryAttempts:(NSUInteger)retryAttempts maxAttempts:(NSUInteger)maxAttempts confirmationBlock:(PushAuthenticationWithPinConfirmation)confirmationBlock NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
