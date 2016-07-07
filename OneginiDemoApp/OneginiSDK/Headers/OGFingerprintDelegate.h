//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OGPinConfirmation.h"
#import "OGUserProfile.h"

/**
 *  Delegate used for fingerprint authentication.
 */
@protocol OGFingerprintDelegate<NSObject>

/**
 *  Asks user for current pin for fingerprint authentication enrollment for a specific profile.
 *  Call the OGPinConfirmation - (void)confirmPin:(NSString *)pin method; with the user provided PIN.
 */
- (void)askCurrentPinForFingerprintEnrollmentForUser:(OGUserProfile *)userProfile pinConfirmation:(id<OGPinConfirmation>)pinConfirmation;

/**
 *  Fingerprint enrollment success callback.
 */
- (void)fingerprintAuthenticationEnrollmentSuccessful;

/**
 *  Fingerprint enrollment failure callback.
 */
- (void)fingerprintAuthenticationEnrollmentFailure;

/**
 *  Fingerprint enrollment failure due to invalid client credentials, which means client is disconnected.
 */
- (void)fingerprintAuthenticationEnrollmentFailureNotAuthenticated;

/**
 *  Fingerprint enrollment failure due to invalid pin.
 *
 *  @param attemptCount number of available attempts
 */
- (void)fingerprintAuthenticationEnrollmentErrorInvalidPin:(NSUInteger)attemptCount;

/**
 *  Error occurred during the fingerprint enrollment request, all data for the current profile was removed. This user needs to register again.
 *  This can happen when the profile is removed server-side or the user tried to enter the PIN too many times.
 */
- (void)fingerprintAuthenticationEnrollmentErrorUserDeregistered;

/**
 *  Fingerprint enrollment failed. All device data including all profiles were removed. The user needs to register again.
 *  This can happen when the device registration is removed server-side.
 */
- (void)fingerprintAuthenticationEnrollmentErrorDeviceDeregistered;

@optional

/**
 *  Asks user for current pin for fingerprint authentication enrollment.
 *  Obtained should be passed as an argument of OGOneginiClient method - (void)confirmCurrentPinForFingerprintAuthorization:(NSString *)pin;
 *
 *  <strong>Warning</strong>: Deprecated, use askCurrentPinForFingerprintEnrollmentForUser:pinConfirmation:
 */
- (void)askCurrentPinForFingerprintAuthentication DEPRECATED_MSG_ATTRIBUTE("Use askCurrentPinForFingerprintEnrollmentForUser:pinConfirmation:");

/**
 *  Fingerprint enrollment failed due to too many pin failures.
 *
 *  <strong>Warning</strong>: Deprecated, use fingerprintAuthenticationEnrollmentErrorUserDeregistered
 */
- (void)fingerprintAuthenticationEnrollmentErrorTooManyPinFailures DEPRECATED_MSG_ATTRIBUTE("Use fingerprintAuthenticationEnrollmentErrorUserDeregistered");

@end
