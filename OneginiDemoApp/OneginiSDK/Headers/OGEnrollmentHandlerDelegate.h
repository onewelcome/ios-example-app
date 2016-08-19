//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 *  Enrollment delegate used for mobile authentication.
 */
@protocol OGEnrollmentHandlerDelegate<NSObject>

/**
 *  Enrollment success.
 */
- (void)enrollmentSuccess;

/**
 *  Generic enrollment error handler.
 */
- (void)enrollmentError;

/**
 *  Failed to authenticate the user for enrollment.
 */
- (void)enrollmentAuthenticationError;

/**
 *  Enrollment failed with error
 *
 *  @param error error
 */
- (void)enrollmentError:(NSError *)error;

/**
 *  Enrollment for mobile authentication is currently disabled.
 */
- (void)enrollmentNotAvailable;

/**
 *  One or more request parameters missing.
 */
- (void)enrollmentInvalidRequest;

/**
 *  The provided client credentials are invalid.
 *
 *  <strong>Warning</strong>: Deprecated, use enrollmentErrorDeviceDeregistered
 */
- (void)enrollmentInvalidClientCredentials DEPRECATED_MSG_ATTRIBUTE("Use enrollmentErrorDeviceDeregistered");

/**
 *  The device is already enrolled.
 */
- (void)enrollmentDeviceAlreadyEnrolled;

/**
 *  The user already has a device enrolled for mobile authentication.
 */
- (void)enrollmentUserAlreadyEnrolled;

/**
 *  The transaction id used during enrollment is invalid, probably because the transaction validity period is expired.
 */
- (void)enrollmentInvalidTransaction;

/**
 *  Mobile authentication enrollment failed. All device data including all profiles were removed. The user needs to register again.
 *  This can happen when the device registration is removed server-side.
 */
- (void)enrollmentErrorDeviceDeregistered;

@optional

/**
 *  The provided client credentials are invalid.
 *
 *  <strong>Warning</strong>: Deprecated, use enrollmentErrorDeviceDeregistered
 */
- (void)enrollmentInvalidClientCredentials DEPRECATED_MSG_ATTRIBUTE("Use enrollmentErrorDeviceDeregistered");

@end