// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to authentication with fingerprint challenge.
 */
@protocol ONGFingerprintChallengeSender<NSObject>

/**
 * Method providing confirmation response to the SDK.
 */
- (void)continueChallenge;

/**
 * Method providing confirmation response with prompt to the SDK.
 *
 * @prompt Message to be displayed in the TouchID popup
 */
- (void)continueChallengeWithPrompt:(NSString *)prompt;

/**
 * Method providing pin fallback response to the SDK.
 *
 * @prompt Message to be displayed in the TouchID popup
 */
- (void)fallbackToPinChallenge;

@end

/**
 * Represents authentication with fingerprint challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
@interface ONGFingerprintChallenge : NSObject

/**
 * User profile for which authenticate with fingerprint challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Error describing cause of failure of previous challenge response.
 * Domain of an error: ONGGenericErrorDomain
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the authentication with fingerprint challenge.
 */
@property (nonatomic, readonly) id<ONGFingerprintChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END