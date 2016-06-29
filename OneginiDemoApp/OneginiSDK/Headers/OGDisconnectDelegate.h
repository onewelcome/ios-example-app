//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class OGUserProfile;

/**
 *  Disconnection delegate.
 */
@protocol OGDisconnectDelegate<NSObject>

/**
 *  Credentials has been removed sucessfully both from device and token server.
 */
- (void)disconnectSuccessful;

/**
 *  Credentials has been removed from device but error was encountered during communication with token server.
 *
 *  @param error error encountered during communication with token server
 */
- (void)disconnectFailureWithError:(NSError *)error;

@end
