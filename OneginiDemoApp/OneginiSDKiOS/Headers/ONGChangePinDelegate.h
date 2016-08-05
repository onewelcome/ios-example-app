//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPinChallenge.h"
#import "ONGUserProfile.h"
#import "ONGCreatePinChallenge.h"

/**
 *  This protocol informs the client about the result of the PIN change request.
 *  Clients must also implement the ONGPinValidationDelegate protocol.
 */
@protocol ONGChangePinDelegate<NSObject>

/**
 *  Asks the user for the current PIN in the change PIN request flow.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the ONGPinChallengeSender - (void)respondWithPin:challenge:(NSString *)pin method; with the user provided PIN.
 */
- (void)askCurrentPinForChangeRequestForUser:(ONGUserProfile *)userProfile pinConfirmation:(id<ONGPinChallengeSender>)delegate;

/**
 *  Asks the user for a new PIN.
 *  The implementor should present a PIN entry dialog with a second verification entry.
 *  The PIN must be forwarded directly to the client and not be stored by any means.
 *  Call the ONGCreatePinChallengeSender - (void)respondWithPin:challenge:(NSString *)pin method; with the user provided PIN.
 *  The new PIN must satisfy any PIN policy constraints.
 *
 *  @param pinSize the size of the PIN value
 */
- (void)askNewPinForChangeRequest:(NSUInteger)pinSize pinConfirmation:(id<ONGCreatePinChallengeSender>)delegate;

/**
 *  The access grant or refresh token provided by the client is invalid.
 *
 *  @param remaining the number of remaining attempts before the token becomes invalid
 */
- (void)invalidCurrentPin:(NSUInteger)remaining;

/**
 *  PIN change failed
 *
 *  This error will be either within the ONGGenericErrorDomain, ONGChangePinErrorDomain or the ONGPinValidationErrorDomain.
 *
 *  @param error error encountered during PIN change
 */
- (void)pinChangeError:(NSError *)error;

/**
 *  Pin changed successfully callback
 */
- (void)pinChanged;

@end