//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

/**
 *  Deregistration delegate.
 */
@protocol ONGDeregistrationDelegate<NSObject>

/**
 *  Credentials has been removed successfully both from the device and token server.
 *
 *  @param user user that has been deregistered
 */
- (void)deregistrationSuccessful:(ONGUserProfile *)userProfile;

/**
 *  Credentials has been removed from device but error was encountered during communication with the token server.
 *
 *  @param error error encountered during communication with the token server
 */
- (void)deregistrationFailureWithError:(NSError *)error;

@end
