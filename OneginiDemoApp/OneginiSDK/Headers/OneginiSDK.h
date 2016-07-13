//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGResourceHandlerDelegate.h"
#import "ONGEnrollmentHandlerDelegate.h"
#import "ONGChangePinDelegate.h"
#import "ONGPinValidationDelegate.h"
#import "ONGLogoutDelegate.h"
#import "ONGDisconnectDelegate.h"
#import "ONGDeregistrationDelegate.h"
#import "ONGFingerprintDelegate.h"
#import "ONGCustomizationDelegate.h"
#import "ONGConfigModel.h"
#import "ONGOneginiClient.h"
#import "ONGPublicCommons.h"
#import "ONGNewPinConfirmation.h"
#import "ONGPinConfirmation.h"
#import "ONGMobileAuthenticationDelegate.h"
#import "ONGClientAuthenticationDelegate.h"
#import "ONGUserProfile.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"
/**
 *  Public interface of the Onegini iOS SDK, should be imported by the SDK user.
 */
@interface OneginiSDK : NSObject
@end
#pragma clang diagnostic pop