//
//  OGChangePinDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 20-02-15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGPinConfirmationDelegate.h"
#import "OGUserProfile.h"
#import "OGNewPinConfirmationDelegate.h"

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

/**
 *  Asks the user for the current PIN in the change PIN request flow.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the OGOneginiClient - (void)confirmCurrentPinForChangeRequest:(NSString *)pin; with the user provided PIN.
 */
- (void)askCurrentPinForChangeRequestForProfile:(OGUserProfile*)profile confirmationDelegate:(id<OGPinConfirmationDelegate>)delegate;

/**
 *  Asks the user for a new PIN.
 *  The implementor should present a PIN entry dialog with a second verification entry.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the OGOneginiClient - (void)confirmNewPinForChangeRequest:(NSString *)pin validation:(id<OGPinValidationDelegate>)delegate;
 *  The new PIN must satisfy any PIN policy constraints.
 *
 *  @param pinSize the size of the PIN value
 */
- (void)askNewPinForChangeRequest:(NSUInteger)pinSize confirmationDelegate:(id<OGNewPinConfirmationDelegate>)delegate;

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