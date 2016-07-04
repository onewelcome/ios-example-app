//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class OGUserProfile;

/**
 *  Deregistration delegate.
 */
@protocol OGDeregistrationDelegate<NSObject>

/**
 *  Credentials has been removed sucessfully both from device and token server.
 *  @param user user that has been deregistered
 */
- (void)deregistrationSuccessful:(OGUserProfile *)userProfile;

/**
 *  Credentials has been removed from device but error was encountered during communication with token server.
 *
 *  @param error error encountered during communication with token server
 */
- (void)deregistrationFailureWithError:(NSError *)error;

@end
