//
//  OGFingerprintDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 19/06/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGFingerprintDelegate <NSObject>

- (void) askCurrentPinForFingerprintAuthentication;

- (void) fingerprintAuthenticationEnrollmentSuccessful;
- (void) fingerprintAuthenticationEnrollmentFailure;

- (void) fingerprintAuthenticationEnrollmentErrorInvalidPin:(NSUInteger)attemptCount;
- (void) fingerprintAuthenticationEnrollmentErrorTooManyPinFailures;

@end
