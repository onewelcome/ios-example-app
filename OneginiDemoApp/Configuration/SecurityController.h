//
//  SecurityController.h
//  OneginiSDKiOSTestApp
//
//  Created by Stanisław Brzeski on 26/07/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class responsible for toggling debug/jailbreak detection. This class is read by the Onegini SDK trough reflection.
 */
@interface SecurityController : NSObject

+(bool)rootDetection;
+(bool)debugDetection;

@end
