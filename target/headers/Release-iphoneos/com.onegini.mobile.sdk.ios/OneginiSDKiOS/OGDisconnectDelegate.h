//
//  OGDisconnectDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 20/05/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Disconnection delegate.
 */
@protocol OGDisconnectDelegate <NSObject>

/**
 *  Credentials has been removed sucessfully both from device and token server.
 */
-(void)disconnectSuccessful;

/**
 *  Credentials has been removed from device but error was encountered during communication with token server.
 *
 *  @param error error encountered during communication with token server
 */
-(void)disconnectFailureWithError:(NSError*)error;

@end
