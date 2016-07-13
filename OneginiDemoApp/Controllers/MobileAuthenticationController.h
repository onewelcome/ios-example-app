//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface MobileAuthenticationController : NSObject<ONGEnrollmentHandlerDelegate, ONGMobileAuthenticationDelegate>

+ (instancetype)sharedInstance;

- (void)enrollForMobileAuthentication;

@end
