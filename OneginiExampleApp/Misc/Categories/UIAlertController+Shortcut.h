// Copyright (c) 2016 Onegini. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIAlertController (Shortcut)

+ (instancetype)controllerWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion;

@end