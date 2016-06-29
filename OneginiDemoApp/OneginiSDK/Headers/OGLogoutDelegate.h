//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class OGUserProfile;

/**
 *  Logout delegate
 */
@protocol OGLogoutDelegate<NSObject>

/**
 *  Logout successful callback
 *  Access token removed from device and revoked from token server
 */
- (void)logoutSuccessful;

/**
 *  Logout failure callback
 *  Access token removed from device but not revoked from token server
 *
 *  @param error error encountered during communication with token server
 */
- (void)logoutFailureWithError:(NSError *)error;

@end
