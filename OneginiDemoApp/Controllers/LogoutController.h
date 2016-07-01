//
//  LogoutController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 09/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface LogoutController : NSObject<OGLogoutDelegate>

+ (instancetype)sharedInstance;
- (void)logout;

@end
