//
// Copyright (c) 2016 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "UIAlertController+Shortcut.h"

#import "OneginiSDK.h"

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

+ (instancetype)authenticatorSelectionController:(NSArray<ONGAuthenticator *> *)authenticators completion:(void (^)(NSInteger selectedIndex, BOOL cancelled))completion
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Select Preferred Authenticator"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [authenticators enumerateObjectsUsingBlock:^(ONGAuthenticator * _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        [controller addAction:[UIAlertAction actionWithTitle:object.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion != nil) {
                completion(idx, NO);
            }
        }]];
    }];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion != nil) {
            completion(NSNotFound, YES);
        }
    }]];
    
    return controller;
}

@end
