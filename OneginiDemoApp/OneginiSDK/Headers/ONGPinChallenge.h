// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to authentication with PIN challenge.
 */
@protocol ONGPinChallengeSender<NSObject>

/**
 * Method to provide the PIN to the SDK.
 *
 * @param pin the PIN provided by the user
 */
- (void)continueChallengeWithPin:(NSString *)pin;

@end

/**
 * Represents authentication with PIN challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
@interface ONGPinChallenge : NSObject

/**
 * User profile for which authenticate with PIN challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Maximum allowed pin attempts for the user.
 */
@property (nonatomic, readonly) NSUInteger maxPinAttempts;

/**
 * Pin attempts used by the user on this device.
 */
@property (nonatomic, readonly) NSUInteger usedPinAttempts;

/**
 * Error describing cause of failure of previous challenge response.
 * Possible error domains: ONGPinAuthenticationErrorDomain, ONGGenericErrorDomain
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the authenticate with PIN challenge.
 */
@property (nonatomic, readonly) id<ONGPinChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END