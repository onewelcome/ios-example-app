// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGFingerprintChallenge;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to authentication with fingerprint challenge.
 */
@protocol ONGFingerprintChallengeSender<NSObject>

/**
 * Method providing confirmation response with default prompt to the SDK.
 *
 * @param challenge fingerprint challenge for which the response is made
 */
- (void)respondWithDefaultPromptForChallenge:(ONGFingerprintChallenge *)challenge;

/**
 * Method providing confirmation response with prompt to the SDK.
 *
 * @param prompt Message to be displayed in the TouchID popup
 * @param challenge fingerprint challenge for which the response is made
 */
- (void)respondWithPrompt:(NSString *)prompt challenge:(ONGFingerprintChallenge *)challenge;

/**
 * Method providing pin fallback response to the SDK.
 *
 * @param prompt Message to be displayed in the TouchID popup
 * @param challenge fingerprint challenge for which the response is made
 */
- (void)respondWithPinFallbackForChallenge:(ONGFingerprintChallenge *)challenge;

/**
 * Method to cancel challenge
 *
 * @param challenge pin challenge that needs to be cancelled
 */
- (void)cancelChallenge:(ONGFingerprintChallenge *)challenge;

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

#pragma clang diagnostic pop