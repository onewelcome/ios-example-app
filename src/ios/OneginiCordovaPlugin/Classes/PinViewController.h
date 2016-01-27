//
//  PinViewController.h
//  OneginiCordovaPlugin
//
//  Created by Stanisław Brzeski on 19/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Commons.h"

@protocol PinViewControllerDelegate <NSObject>

- (void)pinEntered:(NSString *)pin;
- (void)pinForgotten;

@end

@interface PinViewController : UIViewController

@property (nonatomic) PINEntryModes mode;
@property (weak, nonatomic) id <PinViewControllerDelegate> delegate;
@property (nonatomic) NSUInteger supportedOrientations;
@property (nonatomic) NSDictionary *messages;

- (void)invalidPinWithReason:(NSString *)message;

- (void)reset;

@end
