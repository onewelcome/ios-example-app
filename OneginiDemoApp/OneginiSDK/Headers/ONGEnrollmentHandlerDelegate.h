//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 *  Enrollment delegate used for mobile authentication.
 */
@protocol ONGEnrollmentHandlerDelegate<NSObject>

/**
 *  Enrollment success.
 */
- (void)enrollmentSuccess;

/**
 *  Enrollment failed with error
 *
 *  This error will be either within the ONGGenericErrorDomain or the ONGMobileAuthenticationEnrollmentErrorDomain
 *
 *  @param error error
 */
- (void)enrollmentError:(NSError *)error;

@end