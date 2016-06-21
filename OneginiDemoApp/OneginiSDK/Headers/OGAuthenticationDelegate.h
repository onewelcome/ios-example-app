//
//  OGAuthenticationDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 09/03/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGPinConfirmationDelegate.h"
#import "OGNewPinConfirmationDelegate.h"
#import "OGUserProfile.h"

/**
 *  This delegate provides the interface from the OneginiClient to the App implementation.
 *  All invokations are performed asynchronous and on the main queue.
 */
@protocol OGAuthenticationDelegate <NSObject>

@required

/**
 *  The user is successfully authenticated.
 */
- (void)authenticationSuccessForProfile:(OGUserProfile*)profile;

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
 *  Call the OGOneginiClient - (void)confirmNewPin:(NSString *)pin; with the new PIN.
 *  The new PIN must satisfy any PIN policy constraints.
 *
 *  @param pinSize the size of the PIN value
 */
- (void)askForNewPin:(NSUInteger)pinSize profile:(OGUserProfile*)profile confirmationDelegate:(id<OGNewPinConfirmationDelegate>)delegate;

/**
 *  Asks the user to provide the PIN for confirmation of the authentication request.
 *
 *  The implementor should present a PIN entry dialog and must forward the PIN directly to the client and not store the PIN by any means.
 *  Call the OGOneginiClient - (void)confirmCurrentPin:(NSString *)pin; with the user provided PIN.
 */
- (void)askForCurrentPinForProfile:(OGUserProfile*)profile pinConfirmationDelegate:(id<OGPinConfirmationDelegate>)delegate;

/**
 *  A general error occurred during the authentication request.
 */
- (void)authenticationError;

/**
 *  authentication failed due to maximum number of attempts is exceeded.
 */
- (void)authenticationErrorTooManyPinFailures;

/**
 *  The access grant or refresh token provided by the client is invalid.
 *
 *  @param remaining the number of remaining attempts for the token becomes invalid
 */
- (void)authenticationErrorInvalidGrant:(NSUInteger)remaining;

/**
 *  No authentication grant token received.
 */
- (void)authenticationErrorNoAuthenticationGrant;

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
 *  Invalid client credentials are used to perform an authentication request.
 */
- (void)authenticationErrorNotAuthenticated;

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
 *  Authenticated profile is not valid.
 */
- (void)authenticationErrorInvalidProfile;

/**
 *  Another authentication process is in progress.
 */
- (void)authenticationErrorAuthenticationInProgress;

@optional

/**
 *  An exception was thrown during the authentication request.
 *
 *  @param error in one of the steps of the authentication process
 */
- (void)authenticationError:(NSError *)error;

@end