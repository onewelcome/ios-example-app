// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to create PIN challenge.
 */
@protocol ONGCreatePinChallengeSender<NSObject>

/**
 * Method providing the PIN to the SDK.
 *
 * @param pin PIN provided by the user
 */
- (void)continueChallengeWithPin:(NSString *)pin;

@end

/**
 * Represents create PIN challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
@interface ONGCreatePinChallenge : NSObject

/**
 * User profile for which create PIN challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Required length for a new PIN.
 */
@property (nonatomic, readonly) NSUInteger pinLength;

/**
 * Error describing cause of failure of previous challenge response.
 * Possible error domains: ONGPinValidationErrorDomain, ONGGenericErrorDomain
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the create PIN challenge.
 */
@property (nonatomic, readonly) id<ONGCreatePinChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END