// Copyright (c) 2016 Onegini. All rights reserved.

#import "UIAlertController+Shortcut.h"

@implementation UIAlertController (Shortcut)

+ (instancetype)controllerWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_) {
        if (completion) {
            completion();
        }
    }]];

    return controller;
}

@end