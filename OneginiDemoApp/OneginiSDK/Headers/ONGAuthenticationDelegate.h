//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGUserProfile;
@class ONGPinChallenge;
@class ONGFingerprintChallenge;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol describing interface for objects implementing methods required to complete authentication.
 *  All invocations are performed on the main queue.
 */
@protocol ONGAuthenticationDelegate<NSObject>

/**
 *  Method called when authentication action requires PIN code to continue.
 *
 *  @param userClient user client performing authentication
 *  @param challenge pin challenge used to complete authentication
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge;

@optional

/**
 *  Method called when authentication action requires TouchID to continue. Its called before asking user for fingerprint.
 *  If its not implemented SDK will continue automatically.
 *
 *  @param userClient user client performing authentication
 *  @param challenge fingerprint challenge used to complete authentication
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveFingerprintChallenge:(ONGFingerprintChallenge *)challenge;

/**
 *  Method called when authentication action is started.
 *
 *  @param userClient user client performing authentication
 *  @param userProfile currently authenticated user profile
 */
- (void)userClient:(ONGUserClient *)userClient didStartAuthenticationForUser:(ONGUserProfile *)userProfile;

/**
 *  Method called when authentication action is completed with success.
 *
 *  @param userClient user client performing authentication
 *  @param userProfile successfully authenticated user profile
 */
- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile;

/**
 *  Method called when authentication action failed with error.
 *
 *  @param userClient user client performing authentication
 *  @param userProfile user profile for which authentication failed
 *  @param error error describing cause of an error
 */
- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END