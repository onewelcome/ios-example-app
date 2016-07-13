//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPinConfirmation.h"
#import "ONGNewPinConfirmation.h"
#import "ONGUserProfile.h"

/**
 *  This delegate provides the interface from the ONGOneginiClient to the App implementation.
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
 *  A general error occurred during the authentication request.
 */
- (void)authenticationError;

/**
 *  The access grant or refresh token provided by the client is invalid.
 *
 *  @param remaining the number of remaining attempts for the token becomes invalid
 */
- (void)authenticationErrorInvalidGrant:(NSUInteger)remaining;

/**
 *  One or more required parameters were missing in the authentication request.
 */
- (void)authenticationErrorInvalidRequest;

/**
 *  The client was not able to perform a successful dynamic client registration during the authentication flow.
 *
 *  @param error error
 */
- (void)authenticationErrorClientRegistrationFailed:(NSError *)error;

/**
 *  The state parameter in the authentication request and the value in the callback have different values.
 *  This might indicate a possible man in the middle attack.
 */
- (void)authenticationErrorInvalidState;

/**
 *  At least one of the requested scopes is not valid.
 */
- (void)authenticationErrorInvalidScope;

/**
 *  The grant type used during authentication is not supported by the token server.
 */
- (void)authenticationErrorInvalidGrantType;

/**
 *  Application has invalid app platform or version.
 */
- (void)authenticationErrorInvalidAppPlatformOrVersion;

/**
 *  Application runs on unsupported OS.
 */
- (void)authenticationErrorUnsupportedOS;

/**
 *  Authentication failed because client is not authorized to perform the requested action.
 */
- (void)authenticationErrorNotAuthorized;

/**
 *  Authenticated user is not valid.
 */
- (void)authenticationErrorInvalidUser;

/**
 *  Error occurred during the authentication request, all device data including all profiles were removed. The user needs to register again.
 *  This can happen when the device registration is removed server-side.
 */
- (void)authenticationErrorDeviceDeregistered;

/**
 *  Error occurred during the authentication request, all data for the current user was removed. This user needs to register again.
 *  This can happen when the user is removed server-side or the user tried to enter the PIN too many times.
 */
- (void)authenticationErrorUserDeregistered;

@optional

/**
 *  An exception was thrown during the authentication request.
 *
 *  @param error in one of the steps of the authentication process
 */
- (void)authenticationError:(NSError *)error;

@end