//
//  OGFingerprintDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 19/06/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Delegate used for fingerprint authentication.
 */
@protocol OGFingerprintDelegate <NSObject>

/**
 *  Asks user for current pin for fingerprint authentication entrollment.
 *  Obtained should be passed as an argument of OGOneginiClient method - (void)confirmCurrentPinForFingerprintAuthorization:(NSString *)pin;
 */
- (void) askCurrentPinForFingerprintAuthentication;

/**
 *  Fingerprint enrollment success callback.
 */
- (void) fingerprintAuthenticationEnrollmentSuccessful;

/**
 *  Fingerprint enrollment failure callback.
 */
- (void) fingerprintAuthenticationEnrollmentFailure;

/**
 *  Fingerprint enrollment failure due to invalid pin.
 *
 *  @param attemptCount number of available attempts
 */
- (void) fingerprintAuthenticationEnrollmentErrorInvalidPin:(NSUInteger)attemptCount;

/**
 *  Fingerprint enrollment failed due to too many pin failures.
 */
- (void) fingerprintAuthenticationEnrollmentErrorTooManyPinFailures;

@end
