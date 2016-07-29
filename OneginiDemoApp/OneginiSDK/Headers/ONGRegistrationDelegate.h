// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGUserProfile;
@class ONGCreatePinChallenge;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol describing interface for objects implementing methods required to complete registration.
 *  All invocations are performed on the main queue.
 */
@protocol ONGRegistrationDelegate<NSObject>

/**
 *  Method called when registration action requires creation of PIN code to continue.
 *
 *  @param userClient user client performing registration
 *  @param challenge create pin challenge used to complete registration
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinRegistrationChallenge:(ONGCreatePinChallenge *)challenge;

/**
 *  Method called when registration action requires authentication code request to be completed.
 *  After authentication code request is performed successfully, redirection call will be performed using url specified
 *  in ONGRedirectURL. If request is performed by embedded web browser SDK will handle redirection on its own. Otherwise
 *  redirection must be handled using handleAuthenticationCallback: method of ONGUserClient instance.
 *
 *  @discussion Example: if authentication code request is performed by external web browser, it will call
 *  application:openURL:options: method on the AppDelegate. In the implementation of this method redirect can be handled
 *  by calling [[ONGUserClient sharedInstance] handleAuthenticationCallback:url].
 *
 *  @param userClient user client performing registration
 *  @param url used to perform a authentication code request
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveAuthenticationCodeRequestWithUrl:(NSURL *)url;

@optional

/**
 *  Method called when registration action is started.
 *
 *  @param userClient user client performing authentication
 */
- (void)userClientDidStartRegistration:(ONGUserClient *)userClient;

/**
 *  Method called when registration action is completed with success.
 *
 *  @param userClient user client performing registration
 *  @param userProfile successfully registered user profile
 */
- (void)userClient:(ONGUserClient *)userClient didRegisterUser:(ONGUserProfile *)userProfile;

/**
 *  Method called when registration action failed with error.
 *
 *  @param userClient user client performing registration
 *  @param error error describing cause of an error
 */
- (void)userClient:(ONGUserClient *)userClient didFailToRegisterWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END