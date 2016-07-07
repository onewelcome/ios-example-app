//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface MobileAuthenticationController : NSObject<OGEnrollmentHandlerDelegate, OGMobileAuthenticationDelegate>

+ (instancetype)sharedInstance;

- (void)enrollForMobileAuthentication;

@end
