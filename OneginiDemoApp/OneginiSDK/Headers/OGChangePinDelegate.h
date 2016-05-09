//
//  OGChangePinDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 20-02-15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This protocol informs the client about the result of the PIN change request.
 *  Clients must also implement the OGPinValidationDelegate protocol.
 */
@protocol OGChangePinDelegate <NSObject>

/**
 *  The access grant or refresh token provided by the client is invalid.
 *
 *  @param remaining the number of remaining attempts before the token becomes invalid
 */
- (void)invalidCurrentPin:(NSUInteger)remaining;

@required

/**
 *  PIN change failed due to maximum number of retry attempts exceeded allowed maximum.
 */
- (void)pinChangeErrorTooManyPinFailures;

/**
 *  Pin changed sucessfully callback
 */
- (void)pinChanged;

/**
 *  Pin change failed
 */
- (void)pinChangeError;

/**
 *  Pin change failed
 *
 *  @param error error encountered during pic change
 */
- (void)pinChangeError:(NSError *)error;

/**
 *  Client validation failed
 */
- (void)pinChangeErrorNotAuthenticated;

@end