//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

/**
 *  Disconnection delegate.
 */
@protocol ONGDisconnectDelegate<NSObject>

/**
 *  Credentials has been removed successfully both from the device and token server.
 */
- (void)disconnectSuccessful;

/**
 *  Credentials has been removed from device but error was encountered during communication with the token server.
 *
 *  @param error error encountered during communication with the token server
 */
- (void)disconnectFailureWithError:(NSError *)error;

@end