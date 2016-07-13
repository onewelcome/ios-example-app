//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface ChangePinController : NSObject<ONGChangePinDelegate>

+ (instancetype)sharedInstance;

- (void)changePin;

@end
