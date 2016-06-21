//
//  OGClientAuthenticationDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 18/06/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGClientAuthenticationDelegate <NSObject>

/**
 *  The client is successfully authenticated.
 */
- (void)authenticationSuccess;

/**
 *  A general error occurred during the authentication request.
 */
- (void)authenticationError;

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
