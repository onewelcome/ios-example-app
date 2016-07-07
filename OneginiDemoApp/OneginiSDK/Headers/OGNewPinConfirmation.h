//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OGPinValidationDelegate.h"

/**
 * Protocol to delegate control back to the SDK after the user entered the PIN.
 *
 * An object conforming to this protocol must be used when letting the user choose a PIN.
 */
@protocol OGNewPinConfirmation<NSObject>

/**
 * Method to provide the PIN to the SDK.
 *
 * @param pin PIN provided by the user
 * @param delegate object responsible for handling error on pin validation against pin policy
 *
 * @return bool value indicating if the PIN is complying to the pin policy
 */
- (bool)confirmNewPin:(NSString *)pin validation:(id<OGPinValidationDelegate>)delegate;

@end
