//
//  OGMobileAuthenticationDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 04/04/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGUserProfile.h"

@protocol OGMobileAuthenticationDelegate <NSObject>

/**
 *  Asks the user for confirmation on a push authentication request.
 *  The implementor should present a confirmation dialog with the specified message.
 *
 *  @param message to present to the user.
 *  @param notificationType notification type
 *  @param confirm callback invoke with true if the user confirmed the request.
 */
- (void)askForPushAuthenticationConfirmation:(NSString *)message profile:(OGUserProfile*)profile notificationType:(NSString *)notificationType confirm:(void (^)(bool confirm))confirm;

/**
 *  Asks the user for confirmation on a push authentication request.
 *  The implementor should present a confirmation dialog with the specified message.
 *
 *  @param message to present to the user.
 *  @param notificationType notification type
 *  @param pinSize Number of digits in pincode
 *  @param maxAttempts Maximum number of attepmts before of user authentication failure.
 *  @param retryAttempt Number of previous attempts
 *  @param confirm callback invoke with true if the user confirmed the request.
 */
- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message profile:(OGUserProfile*)profile notificationType:(NSString *)notificationType
                                            pinSize:(NSUInteger)pinSize	maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt
                                            confirm:(void (^)(NSString *pin, BOOL confirm, BOOL retry))confirm;

/**
 *  Asks the user for fingerprint confirmation on a push authentication request.
 *  The implementor should present a confirmation dialog with the specified message.
 *
 *  @param message to present to the user.
 *  @param notificationType notification type
 *  @param confirm callback invoke with true if the user confirmed the request.
 */
- (void)askForPushAuthenticationWithFingerprint:(NSString*)message profile:(OGUserProfile*)profile notificationType:(NSString *)notificationType confirm:(void (^)(bool confirm))confirm;

@end
