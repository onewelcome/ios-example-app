//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

#import "ONGPublicDefines.h"
#import "OGPublicCommons.h"
#import "OGResourceHandlerDelegate.h"
#import "OGEnrollmentHandlerDelegate.h"
#import "OGChangePinDelegate.h"
#import "OGPinValidationDelegate.h"
#import "OGLogoutDelegate.h"
#import "OGDisconnectDelegate.h"
#import "OGDeregistrationDelegate.h"
#import "OGFingerprintDelegate.h"
#import "OGCustomizationDelegate.h"
#import "OGConfigModel.h"
#import "OGOneginiClient.h"
#import "OGNewPinConfirmation.h"
#import "OGPinConfirmation.h"
#import "OGMobileAuthenticationDelegate.h"
#import "OGClientAuthenticationDelegate.h"
#import "OGUserProfile.h"
#import "ONGClient.h"
#import "ONGClientBuilder.h"
#import "ONGClient.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"
/**
 *  Public interface of the Onegini iOS SDK, should be imported by the SDK user.
 */
@interface OneginiSDK : NSObject
@end
#pragma clang diagnostic pop