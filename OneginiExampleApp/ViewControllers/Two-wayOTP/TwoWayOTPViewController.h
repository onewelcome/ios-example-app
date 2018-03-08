//  Copyright © 2018 Onegini. All rights reserved.

#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface TwoWayOTPViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic) ONGCustomRegistrationChallenge *challenge;
@property (nonatomic) void (^completionBlock)(NSString *code, BOOL cancelled);

@end
