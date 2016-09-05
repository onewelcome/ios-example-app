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
@property (nonatomic) ONGUserProfile *profile;
@property (nonatomic, copy) void (^pinEntered)(NSString *pin, BOOL cancelled);
@property (nonatomic) NSInteger pinLength;

- (void)showError:(NSString *)error;
- (void)reset;

@end
