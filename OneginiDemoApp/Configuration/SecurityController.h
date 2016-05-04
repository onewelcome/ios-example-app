//
//  SecurityController.h
//  OneginiSDKiOSTestApp
//
//  Created by Stanisław Brzeski on 26/07/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

// do not remove. even it is not in use directly, OG finds it in the runtime
@interface SecurityController : NSObject
+(bool)rootDetection;
+(bool)debugDetection;
@end
