//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

typedef void(^Cancel)(void);
typedef void(^PushAuthenticationConfirmation)(BOOL confirm);
typedef void(^PushAuthenticationWithPinConfirmation)(NSString *pin, BOOL confirm, BOOL retry);

/**
 *  This delegate provides the interface from the OneginiClient to the App implementation.
 *  All invokations are performed asynchronous and on the main queue.
 */
DEPRECATED_MSG_ATTRIBUTE("Use OGAuthenticationDelegate")
@protocol OGAuthorizationDelegate<NSObject>

@required

/**
 *  The client is successfully authorized.
 */
- (void)authorizationSuccess;

/**
 *  Requests the authorization token.
 *  The SDK can't handle the redirect itself it is therefore the responsibility
 *  of the delegate implementation to open the URL by means of the default application
 *  [[UIApplication sharedApplication] openURL:url] or by using a custom component.
 *
 *  @see UIApplication
 *  @param url url
 */
- (void)requestAuthorization:(NSURL *)url;

/**
 *  Asks the user for a new PIN.
 *  The implementor should present a PIN entry dialog with a second verification entry.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the OGOneginiClient - (void)confirmNewPin:(NSString *)pin; with the new PIN.
 *  The new PIN must satisfy any PIN policy constraints.
 *
 *  @param pinSize the size of the PIN value
 */
- (void)askForNewPin:(NSUInteger)pinSize;

/**
 *  Asks the user to provide the PIN for confirmation of the authorization request.
 *
 *  The implementor should present a PIN entry dialog and must forward the PIN directly to the client and not store the PIN by any means.
 *  Call the OGOneginiClient - (void)confirmCurrentPin:(NSString *)pin; with the user provided PIN.
 */
- (void)askForCurrentPin;

/**
 *  Asks the user for the current PIN in the change PIN request flow.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the OGOneginiClient - (void)confirmCurrentPinForChangeRequest:(NSString *)pin; with the user provided PIN.
 */
- (void)askCurrentPinForChangeRequest;

/**
 *  Asks the user for a new PIN.
 *  The implementor should present a PIN entry dialog with a second verification entry.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the OGOneginiClient - (void)confirmNewPinForChangeRequest:(NSString *)pin validation:(id<OGPinValidationDelegate>)delegate;
 *  The new PIN must satisfy any PIN policy constraints.
 *
 *  @param pinSize the size of the PIN value
 */
- (void)askNewPinForChangeRequest:(NSUInteger)pinSize;

/**
 *  Asks the user for confirmation on a push authentication request.
 *  The implementor should present a confirmation dialog with the specified message.
 *
 *  @param message to present to the user.
 *  @param notificationType notification type
 *  @param confirm callback invoke with true if the user confirmed the request.
 */
- (void)askForPushAuthenticationConfirmation:(NSString *)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm;

/**
 *  Asks the user for confirmation on a push authentication request.
 *  The implementor should present a confirmation dialog with the specified message.
 *
 *  @param message to present to the user.
 *  @param notificationType notification type
 *  @param pinSize Number of digits in pincode
 *  @param maxAttempts Maximum number of attepmts before of user authentication failure.
 *  @param retryAttempt Number of previous attempts
 *  @param confirm callback invoke with true if the user confirmed the request.
 */
- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message notificationType:(NSString *)notificationType
                                            pinSize:(NSUInteger)pinSize maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt
                                            confirm:(PushAuthenticationWithPinConfirmation)confirm;

/**
 *  Asks the user for fingerprint confirmation on a push authentication request.
 *  The implementor should present a confirmation dialog with the specified message.
 *
 *  @param message to present to the user.
 *  @param notificationType notification type
 *  @param confirm callback invoke with true if the user confirmed the request.
 */
- (void)askForPushAuthenticationWithFingerprint:(NSString *)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm;

/**
 *  A general error occurred during the authorization request.
 */
- (void)authorizationError;

/**
 *  Authorization failed due to maximum number of attempts is exceeded.
 */
- (void)authorizationErrorTooManyPinFailures;

/**
 *  The access grant or refresh token provided by the client is invalid.
 *
 *  @param remaining the number of remaining attempts for the token becomes invalid
 */
- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining;

/**
 *  No access token received in response to the authorization request
 */
- (void)authorizationErrorNoAccessToken;

/**
 *  One or more required parameters were missing in the authorization request.
 */
- (void)authorizationErrorInvalidRequest;

/**
 *  The client was not able to perform a successful dynamic client registration during the authorization flow.
 *
 *  @param error error
 */
- (void)authorizationErrorClientRegistrationFailed:(NSError *)error;

/**
 *  The state parameter in the authorization request and the value in the callback have different values.
 *  This might indicate a possible man in the middle attack.
 */
- (void)authorizationErrorInvalidState;

/**
 *  At least one of the requested scopes is not valid.
 */
- (void)authorizationErrorInvalidScope;

/**
 *  The grant type used during authorization is not supported by the token server.
 */
- (void)authorizationErrorInvalidGrantType;

/**
 *  Application has invalid app platform or version.
 */
- (void)authorizationErrorInvalidAppPlatformOrVersion;

/**
 *  Application runs on unsupported OS.
 */
- (void)authorizationErrorUnsupportedOS;

/**
 *  Authorization failed because client is not authorized to perform the requested action.
 */
- (void)authorizationErrorNotAuthorized;


@optional

/**
 *  An exception was thrown during the authorization request.
 *
 *  @param error in one of the steps of the authorization process
 */
- (void)authorizationError:(NSError *)error;

@end