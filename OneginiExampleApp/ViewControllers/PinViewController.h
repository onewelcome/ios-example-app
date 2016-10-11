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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

typedef enum : NSUInteger {
    PINCheckMode,
    PINRegistrationMode,
    PINRegistrationVerifyMode,
} PINEntryMode;

@interface PinViewController : UIViewController

@property (nonatomic) NSString *customTitle;
@property (nonatomic) PINEntryMode mode;
@property (nonatomic) ONGUserProfile *profile;
@property (nonatomic, copy) void (^pinEntered)(NSString *pin, BOOL cancelled);
@property (nonatomic) NSInteger pinLength;

- (void)showError:(NSString *)error;
- (void)reset;

@end
