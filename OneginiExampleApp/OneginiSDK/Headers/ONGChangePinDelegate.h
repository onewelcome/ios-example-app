//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGUserClient;
@class ONGPinChallenge;
@class ONGCreatePinChallenge;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing interface for objects implementing methods required to complete change PIN action.
 * All invocations are performed on the main queue.
 */
@protocol ONGChangePinDelegate<NSObject>

/**
 * Method called when change PIN action requires authentication with PIN code to continue.
 *
 * @param userClient user client performing authentication for change PIN action
 * @param challenge pin challenge used to complete authentication for change PIN action
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge;

/**
 * Method called when change PIN action requires new PIN code to continue.
 * New PIN must be compliant with PIN policy defined by the token server.
 *
 * @param userClient user client performing change PIN action
 * @param challenge pin challenge used to complete change PIN action
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCreatePinChallenge:(ONGCreatePinChallenge *)challenge;

@optional

/**
 * Method called when change PIN action is started.
 *
 * @param userClient user client performing change PIN action
 * @param userProfile user profile for which change PIN action is performed
 */
- (void)userClient:(ONGUserClient *)userClient didStartPinChangeForUser:(ONGUserProfile *)userProfile;

/**
 * Method called when change PIN action is completed with success.
 *
 * @param userClient user client performing change PIN action
 * @param userProfile user profile for which change PIN action succeeded
 */
- (void)userClient:(ONGUserClient *)userClient didChangePinForUser:(ONGUserProfile *)userProfile;

/**
 * Method called when change PIN action failed with an error.
 *
 * The returned error will be either within the ONGGenericErrorDomain, ONGChangePinErrorDomain.
 *
 * @param userClient user client performing change PIN action
 * @param userProfile user profile for which change PIN action failed
 * @param error error describing cause of an error
 */
- (void)userClient:(ONGUserClient *)userClient didFailToChangePinForUser:(ONGUserProfile *)userProfile error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END