//
//  RegistrationController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 25/07/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface RegistrationController : NSObject <ONGRegistrationDelegate>

+ (RegistrationController *)sharedInstance;

- (void)registerNewUser;

@end
