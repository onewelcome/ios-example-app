//
//  FingerprintController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 15/06/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface FingerprintController : NSObject<OGFingerprintDelegate>

+ (instancetype)sharedInstance;
- (BOOL)isFingerprintEnrolled;
- (void)enrollForFingerprintAuthentication;
- (void)disableFingerprintAuthentication;

@end
