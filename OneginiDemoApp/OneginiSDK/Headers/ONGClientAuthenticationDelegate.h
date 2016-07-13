//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@protocol ONGClientAuthenticationDelegate<NSObject>

/**
 *  The client is successfully authenticated.
 */
- (void)authenticationSuccess;

/**
 *  A general error occurred during the authentication request.
 */
- (void)authenticationError;

/**
 *  One or more required parameters were missing in the authentication request.
 */
- (void)authenticationErrorInvalidRequest;

/**
 *  The client was not able to perform dynamic client registration during the authentication flow.
 *
 *  @param error error
 */
- (void)authenticationErrorClientRegistrationFailed:(NSError *)error;

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
 *  The application runs on an unsupported OS.
 */
- (void)authenticationErrorUnsupportedOS;

/**
 *  Authentication failed because client is not authorized to perform the requested action.
 */
- (void)authenticationErrorNotAuthorized;

/**
 *  Error occurred during the authentication request, all client data including all profiles were removed. The user needs to register again.
 *  This can happen when the client registration is removed server-side.
 */
- (void)authenticationErrorDeviceDeregistered;

@optional

/**
 *  An exception was thrown during the authentication request.
 *
 *  @param error in one of the steps of the authentication process
 */
- (void)authenticationError:(NSError *)error;

@end
