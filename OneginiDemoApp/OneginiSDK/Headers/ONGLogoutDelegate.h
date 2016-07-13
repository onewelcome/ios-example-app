//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

/**
 *  Logout delegate
 */
@protocol ONGLogoutDelegate<NSObject>

/**
 *  Logout successful callback
 *  Access token removed from device and revoked from the token server
 */
- (void)logoutSuccessful;

/**
 *  Logout failure callback
 *  Access token removed from device but not revoked from the token server
 *
 *  @param error error encountered during communication with the token server
 */
- (void)logoutFailureWithError:(NSError *)error;

@end
