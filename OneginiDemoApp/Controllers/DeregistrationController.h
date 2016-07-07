//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface DeregistrationController : NSObject<OGDeregistrationDelegate>

+ (instancetype)sharedInstance;
- (void)deregister;

@end
