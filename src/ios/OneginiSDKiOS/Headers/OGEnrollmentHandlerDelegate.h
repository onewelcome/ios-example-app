//
//  OGEnrollmentHandlerDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 20-08-14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGEnrollmentHandlerDelegate <NSObject>

@required

/**
 Enrollment success.
 */
- (void)enrollmentSuccess;

/**
 Generic enrollment error handler
 */
- (void)enrollmentError;

/**
 Failed to authenticate the user for enrollment.
 */
- (void)enrollmentAuthenticationError;

/**
 Enrollment failed with error
 
 @param error
 */
- (void)enrollmentError:(NSError *)error;

/**
 Enrollment for mobile authentication is currently disabled.
 */
- (void)enrollmentNotAvailable;

/**
 One or more request parameters missing.
 */
- (void)enrollmentInvalidRequest;

/**
 The provided client credentials are invalid.
 */
- (void)enrollmentInvalidClientCredentials;

/**
 The device is already enrolled.
 */
- (void)enrollmentDeviceAlreadyEnrolled;

/**
 Device is already enrolled for mobile authentication.
 */
- (void)enrollmentUserAlreadyEnrolled;

/**
 The transaction id used during enrollment is invalid, probably because the transaction validity period is expired.
 */
- (void)enrollmentInvalidTransaction;

@optional

@end