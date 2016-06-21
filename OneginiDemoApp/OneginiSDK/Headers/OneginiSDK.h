//
//  OneginiSDK.h
//  OneginiSDK
//
//  Created by Eduard on 21-07-14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGResourceHandlerDelegate.h"
#import "OGAuthorizationDelegate.h"
#import "OGEnrollmentHandlerDelegate.h"
#import "OGChangePinDelegate.h"
#import "OGPinValidationDelegate.h"
#import "OGLogoutDelegate.h"
#import "OGDisconnectDelegate.h"
#import "OGFingerprintDelegate.h"
#import "OGCustomizationDelegate.h"
#import "OGConfigModel.h"
#import "OGOneginiClient.h"
#import "OGPublicCommons.h"
#import "OGNewPinConfirmationDelegate.h"
#import "OGPinConfirmationDelegate.h"
#import "OGPushMessageDelegate.h"
#import "OGClientAuthenticationDelegate.h"
#import "OGUserProfile.h"

/**
 *  Public interface of the Onegini iOS SDK, should be imported by the SDK user.
 */
@interface OneginiSDK : NSObject
@end