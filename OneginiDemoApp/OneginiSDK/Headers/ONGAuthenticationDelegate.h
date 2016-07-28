//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
@class ONGPinChallenge;
@class ONGFingerprintChallenge;
@class ONGUserProfile;
@class ONGUserClient;

/**
 *  This delegate provides the interface from the ONGUserClient to the App implementation.
 *  All invocations are performed asynchronous and on the main queue.
 */
@protocol ONGAuthenticationDelegate<NSObject>

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge;

@optional

// if not implemented - SDK continues automatically
- (void)userClient:(ONGUserClient *)userClient didReceiveFingerprintChallenge:(ONGFingerprintChallenge *)challenge;

- (void)userClient:(ONGUserClient *)userClient didStartAuthenticationForUser:(ONGUserProfile *)userProfile;
- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile;
- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error;

@end