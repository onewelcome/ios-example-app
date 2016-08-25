//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface MobileAuthenticationController : NSObject <ONGMobileAuthenticationRequestDelegate>

+ (instancetype)sharedInstance;

- (void)enrollForMobileAuthentication;

@end
