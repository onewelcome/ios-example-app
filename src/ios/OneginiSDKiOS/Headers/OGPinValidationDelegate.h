//
//  OGPinValidationDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 02-24-15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A PIN policy contains all constraints a PIN must satisfy.
 This protocol informs the client of validation failures.
 */
@protocol OGPinValidationDelegate <NSObject>

@required

- (void)pinBlackListed;
- (void)pinShouldNotBeASequence;
- (void)pinShouldNotUseSimilarDigits:(NSUInteger)count;
- (void)pinTooShort;

@optional

/**
 Catch all error handler.
 
 @param error
 */
- (void)pinEntryError:(NSError *)error;

@end