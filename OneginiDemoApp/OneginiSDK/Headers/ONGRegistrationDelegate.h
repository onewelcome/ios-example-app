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
 *  Method called when registration action requires creation of a PIN to continue.
 *
 *  @param userClient user client performing registration
 *  @param challenge create pin challenge used to complete registration
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinRegistrationChallenge:(ONGCreatePinChallenge *)challenge;

/**
 *  Method called when the registration action requires you to open a browser with the given URL. When the browser is finished processing it will use a
 *  custom URL scheme to hand over control to your application. You now need to call the handleRegistrationCallback: method of ONGUserClient instance in
 *  order to hand over control to the SDK and continue the registration action. If the HTTP request is performed by the embedded web browser the SDK will
 *  pick up the redirect back to the app on its own and you don't need to do anything.
 *
 *  @discussion Example: if the HTTP request is performed by an external web browser, it will call
 *  application:openURL:options: method on the AppDelegate. In the implementation of this method the redirect can be handled
 *  by calling [[ONGUserClient sharedInstance] handleRegistrationCallback:url].
 *
 *  @param userClient user client performing registration
 *  @param url used to perform a registration code request
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveRegistrationRequestWithUrl:(NSURL *)url;

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