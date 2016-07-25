//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 * Protocol to delegate control back to the SDK after the user entered the PIN.
 *
 * An object conforming to this protocol must be used when asking the user for his/her PIN.
 */
@protocol ONGPinConfirmation<NSObject>

/**
 * Method to provide the PIN to the SDK.
 *
 * @param pin the PIN provided by the user
 */
- (void)confirmPin:(NSString *)pin;

@end
