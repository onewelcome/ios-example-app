//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@protocol ONGClientAuthenticationDelegate<NSObject>

/**
 *  The client is successfully authenticated.
 */
- (void)authenticationSuccess;

/**
 *  An error occurred during the authentication request.
 *
 *  This error will be either within the ONGGenericErrorDomain or the ONGRegistrationErrorDomain
 *
 *  @param error in one of the steps of the authentication process
 */
- (void)authenticationError:(NSError *)error;

@end
