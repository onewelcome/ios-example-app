//
//  OGResourceHandlerDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 11-08-14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Delegate protocol for use by resource handler classes.
 */
@protocol OGResourceHandlerDelegate <NSObject>

@required

/**
 Method called when the resource call was successfully made.
 
 @param response the response on the resource call
 @param headers the headers returned on the resource call
 */
- (void)resourceSuccess:(id)response
                headers:(NSDictionary *)headers;

/**
 * Method called when the resource call failed because of an unknown error.
 */
- (void)resourceError;

/**
 Method called when the resource call failed because of a bad request.
 */
- (void)resourceBadRequest;

/**
 Method called when the resource call could not be completed because the client was not able to authenticate to the
 token server and obtain an access token.
 */
- (void)resourceErrorAuthenticationFailed;

/**
 Method called when the scope linked to the provided access token is not the needed scope.
 */
- (void)scopeError;

/**
 Method called when the requested grant type is not allowed for this client
 */
- (void)unauthorizedClient;

@optional

/**
 Method called when the grant type to get the client credentials is not enabled
 */
- (void)invalidGrantType;

@end