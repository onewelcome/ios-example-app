//
//  EnrollmentController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 19/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface MobileAuthenticationController : NSObject <OGEnrollmentHandlerDelegate, OGPushMessageDelegate>

+(MobileAuthenticationController*)sharedInstance;

-(void)enrollForMobileAuthentication;

@end
