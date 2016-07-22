//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPinConfirmation.h"
#import "ONGNewPinConfirmation.h"
#import "ONGUserProfile.h"

/**
 *  This delegate provides the interface from the ONGUserClient to the App implementation.
 *  All invocations are performed asynchronous and on the main queue.
 */
@protocol ONGAuthenticationDelegate<NSObject>

/**
 *  The user is successfully authenticated.
 */
- (void)authenticationSuccessForUser:(ONGUserProfile *)userProfile;

/**
 *  Requests the authentication token.
 *  The SDK can't handle the redirect itself it is therefore the responsibility
 *  of the delegate implementation to open the URL by means of the default application
 *  [[UIApplication sharedApplication] openURL:url] or by using a custom component.
 *
 *  @see UIApplication
 *  @param url url
 */
- (void)requestAuthenticationCode:(NSURL *)url;

/**
 *  Asks the user for a new PIN.
 *  The implementor should present a PIN entry dialog with a second verification entry.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the ONGNewPinConfirmation - (void)confirmPin:(NSString *)pin method; with the user provided PIN.
 *  The new PIN must satisfy any PIN policy constraints.
 *
 *  @param pinSize the size of the PIN value
 */
- (void)askForNewPin:(NSUInteger)pinSize user:(ONGUserProfile *)userProfile pinConfirmation:(id<ONGNewPinConfirmation>)delegate;

/**
 *  Asks the user to provide the PIN for confirmation of the authentication request.
 *
 *  The implementor should present a PIN entry dialog and must forward the PIN directly to the client and not store the PIN by any means.
 *  Call the ONGPinConfirmation - (void)confirmPin:(NSString *)pin method; with the user provided PIN.
 */
- (void)askForCurrentPinForUser:(ONGUserProfile *)userProfile pinConfirmation:(id<ONGPinConfirmation>)delegate;

/**
 *  The access grant or refresh token provided by the client is invalid.
 *
 *  @param remaining the number of remaining attempts for the token becomes invalid
 */
- (void)authenticationErrorInvalidGrant:(NSUInteger)remaining;

/**
 *  An error occured during the authentication request.
 *
 *  This error will be either within the ONGGenericErrorDomain or the ONGRegistrationErrorDomain
 *
 *  @param error in one of the steps of the authentication process
 */
- (void)authenticationError:(NSError *)error;

@end