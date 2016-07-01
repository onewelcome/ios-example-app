//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 A PIN policy contains all constraints a PIN must satisfy.
 This protocol informs the client of validation failures.
 */
@protocol OGPinValidationDelegate<NSObject>

@required

/**
 *  Method called when provided pin is blacklisted on by the server.
 */
- (void)pinBlackListed;

/**
 *  Method called when provided pin contains a not allowed sequence.
 */
- (void)pinShouldNotBeASequence;

/**
 *  Validated pin should not use similiar digits
 *
 *  @param count maximum allowed number of same digits
 */
- (void)pinShouldNotUseSimilarDigits:(NSUInteger)count;

/**
 *  Provided pin number was too short.
 */
- (void)pinTooShort;

@optional

/**
 *  Generic error handler.
 *  Method called whwnever unexpected error occurs.
 *
 *  @param error error
 */
- (void)pinEntryError:(NSError *)error;

@end