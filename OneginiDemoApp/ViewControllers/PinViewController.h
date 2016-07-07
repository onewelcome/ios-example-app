//  Copyright © 2016 Onegini. All rights reserved.

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
@property (nonatomic) OGUserProfile *profile;
@property (nonatomic, copy) void (^pinEntered)(NSString *pin);
@property (nonatomic) NSInteger pinLength;

- (void)invalidPinWithReason:(NSString *)message;
- (void)showError:(NSString *)error;
- (void)reset;

@end
