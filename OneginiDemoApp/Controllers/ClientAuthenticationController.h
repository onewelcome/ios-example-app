//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface ClientAuthenticationController : NSObject

+ (instancetype)sharedInstance;

- (void)authenticateClient;

@end
