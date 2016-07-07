//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 *  Class responsible for toggling debug/jailbreak detection. This class is read by the Onegini SDK trough reflection.
 */
@interface SecurityController : NSObject

+ (bool)rootDetection;
+ (bool)debugDetection;

@end
