//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface LogoutController : NSObject<ONGLogoutDelegate>

+ (instancetype)sharedInstance;
- (void)logout;

@end
