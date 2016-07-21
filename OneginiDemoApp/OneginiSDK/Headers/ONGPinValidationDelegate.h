//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 A PIN policy contains all constraints a PIN must satisfy.
 This protocol informs the client of validation failures.
 */
@protocol ONGPinValidationDelegate<NSObject>

/**
 *  Generic error handler.
 *  Method called whwnever unexpected error occurs.
 *
 *  This error will be within the ONGPinValidationErrorDomain.
 *
 *  @param error error
 */
- (void)pinEntryError:(NSError *)error;

@end