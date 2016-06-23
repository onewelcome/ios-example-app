//
//  OGFingerprintDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 19/06/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGPinConfirmationDelegate.h"
#import "OGUserProfile.h"

/**
 *  Delegate used for fingerprint authentication.
 */
@protocol OGFingerprintDelegate <NSObject>

/**
 *  Asks user for current pin for fingerprint authentication enrollment.
 *  Obtained should be passed as an argument of OGOneginiClient method - (void)confirmCurrentPinForFingerprintAuthorization:(NSString *)pin;
 */
- (void) askCurrentPinForFingerprintAuthentication DEPRECATED_MSG_ATTRIBUTE("Use askCurrentPinForFingerprintEnrollmentForProfile:confirmationDelegate:");

/**
 *  Asks user for current pin for fingerprint authentication enrollment for a specific profile.
 */
- (void) askCurrentPinForFingerprintEnrollmentForProfile:(OGUserProfile *)userProfile confirmationDelegate:(id<OGPinConfirmationDelegate>)pinConfirmation;

/**
 *  Fingerprint enrollment success callback.
 */
- (void) fingerprintAuthenticationEnrollmentSuccessful;

/**
 *  Fingerprint enrollment failure callback.
 */
- (void) fingerprintAuthenticationEnrollmentFailure;

/**
 *  Fingerprint enrollment failure due to invalid client credentials, which means client is disconnected.
 */
- (void) fingerprintAuthenticationEnrollmentFailureNotAuthenticated;

/**
 *  Fingerprint enrollment failure due to invalid pin.
 *
 *  @param attemptCount number of available attempts
 */
- (void) fingerprintAuthenticationEnrollmentErrorInvalidPin:(NSUInteger)attemptCount;

/**
 *  Fingerprint enrollment failed due to too many pin failures.
 */
- (void) fingerprintAuthenticationEnrollmentErrorTooManyPinFailures DEPRECATED_MSG_ATTRIBUTE("Use fingerprintAuthenticationEnrollmentErrorProfileDeregistered");

/**
 *  Error occurred during the fingerprint enrollment request, all data for the current profile was removed. This user needs to register again.
 *  This can happen when the profile is removed server-side or the user tried to enter the PIN too many times.
 */
- (void) fingerprintAuthenticationEnrollmentErrorProfileDeregistered;

/**
 *  Fingerprint enrollment failed. All device data including all profiles were removed. The user needs to register again.
 *  This can happen when the device registration is removed server-side.
 */
- (void) fingerprintAuthenticationEnrollmentErrorDeviceDeregistered;

@end
