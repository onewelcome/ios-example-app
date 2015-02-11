//
//  OGAuthorizationDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 01-08-14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PinEntryWithVerification)(NSString *pin, NSString *verification, BOOL retry);
typedef void(^PinEntryConfirmation)(NSString *pin, BOOL retry);
typedef void(^ChangePinEntryWithVerification)(NSString *pin, NSString *newPin, NSString *newPinVerification, BOOL retry);
typedef void(^Cancel)(void);
typedef void(^PushAuthenticationConfirmation)(BOOL confirm);
typedef void(^PushAuthenticationWithPinConfirmation)(NSString *pin, BOOL confirm, BOOL retry);

/**
 This delegate provides the interface from the OneginiClient to the App implementation. 
 All invokations are performed asynchronous and on the main queue.
 */
@protocol OGAuthorizationDelegate <NSObject>

@required

/**
 The client is successfully authorized.
 */
- (void)authorizationSuccess;

/**
 Request the authorization token. 
 The SDK can't handle the redirect itself it is therefore the responsibility
 of the delegate implementation to open the URL by means of the default application 
 [[UIApplication sharedApplication] openURL:url] or by using a custom component.
 
 @see UIApplication
 
 @param url
 */
- (void)requestAuthorization:(NSURL *)url;

/**
 Ask the user for a new PIN and verification. 
 The implementor should present a PIN entry dialog with a second verification entry.
 
 The PIN must be forwarded directly to the client and not be stored by any means.
 
 The order of the PIN values in the callback handler is not relevant.
 If both PIN do not match (or length is less then pinSize) and retry is true then 
 this method is re-invoked. This retry due to incorrect pinSize does not count as a PIN attempt failure.
 
 @param pinSize, the size of the PIN value
 @param complete, user entry confirmation callback handler.
 */
- (void)askForPinWithVerification:(NSUInteger)pinSize confirmation:(PinEntryWithVerification)confirm;

/**
Ask the user for a new PIN replacing the existing one.
The implementor should ask the user for the current PIN and the new PIN with verification.

The PINs must be forwarded directly to the client and not be stored by any means.

The new PINs must satisfy any PIN policy constraints. If the policy is not met retry is true then
this method is re-invoked. This retry due to incorrect pinSize does not count as a PIN attempt failure.

@param pinSize, the size of the PIN value
@param complete, user entry confirmation callback handler.
*/
- (void)askForPinChangeWithVerification:(NSUInteger)pinSize confirmation:(ChangePinEntryWithVerification)confirm cancel:(Cancel)cancel;

/**
 Ask the user to provide the PIN for confirmation of the authorization request.
 
 The implementor should present a PIN entry dialog and must forward the PIN directly to the client and not store the PIN by any means.
 
 If the PIN size is less then the pinSize parameter and retry is true then this method is re-invoked.
 This retry due to incorrect pinSize does not count as a PIN attempt failure.
 
 @param pinSize, the size of the PIN value
 @param complete, user entry confirmation callback handler.
 */
- (void)askForPin:(NSUInteger)pinSize confirmation:(PinEntryConfirmation)confirm;

/**
 Ask the user for confirmation on a push authentication request.
 The implementor should present a confirmation dialog with the specified message.
 
 @param message to present to the user.
 @param notificationType
 @param confirm callback invoke with true if the user confirmed the request.
 */
- (void)askForPushAuthenticationConfirmation:(NSString *)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm;
- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message notificationType:(NSString *)notificationType
											pinSize:(NSUInteger)pinSize	maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt
											confirm:(PushAuthenticationWithPinConfirmation)confirm;

/**
 A general error occurred during the authorization request.
 */
- (void)authorizationError;

/**
 Authorization failed due to maximum number of attempts is exceeded.
 */
- (void)authorizationErrorTooManyPinFailures;

/**
 The access grant or refresh token provided by the client is invalid.
 
 @param remaining the number of remaining attempts for the token becomes invalid
 */
- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining;

/**
 No authorization grant token received
 */
- (void)authorizationErrorNoAuthorizationGrant;

/**
 No access token received in response to the authorization request
 */
- (void)authorizationErrorNoAccessToken;

/**
 One or more required parameters were missing in the authorization request.
 */
- (void)authorizationErrorInvalidRequest;

/**
 The client was not able to perform a successful dynamic client registration during the authorization flow.
 
 @param error
 */
- (void)authorizationErrorClientRegistrationFailed:(NSError *)error;

/**
 The state parameter in the authorization request and the value in the callback have different values. 
 This might indicate a possible man in the middle attack.
 */
- (void)authorizationErrorInvalidState;

/**
 At least one of the requested scopes is not valid.
 */
- (void)authorizationErrorInvalidScope;

/**
 Invalid client credentials are used to perform an authorization request.
 */
- (void)authorizationErrorNotAuthenticated;

/**
 The grant type used during authorization is not supported by the token server.
 */
- (void)authorizationErrorInvalidGrantType;

/**
 Authorization failed because client is not authorized to perform the requested action.
 */
- (void)authorizationErrorNotAuthorized;

@optional

/**
 If the PIN entry verification fails an error is generated. 
 
 @param error
 */
- (void)pinEntryError:(NSError *)error;

/**
 An exception was thrown during the authorization request.
 
 @param error in one of the steps of the authorization process
 */
- (void)authorizationError:(NSError *)error;

@end