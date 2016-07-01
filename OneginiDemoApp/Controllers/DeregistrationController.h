//
//  DeregistrationController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 09/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface DeregistrationController : NSObject <OGDeregistrationDelegate>

+ (instancetype)sharedInstance;
- (void)deregister;

@end
