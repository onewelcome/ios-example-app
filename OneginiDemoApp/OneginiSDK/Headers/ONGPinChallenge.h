// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPinChallenge.h"
#import "ONGUserProfile.h"

/**
 * Protocol to delegate control back to the SDK after the user entered the PIN.
 *
 * An object conforming to this protocol must be used when asking the user for his/her PIN.
 */
@protocol ONGPinChallengeSender<NSObject>

/**
 * Method to provide the PIN to the SDK.
 *
 * @param pin the PIN provided by the user
 */
- (void)continueChallengeWithPin:(NSString *)pin;

@end


@interface ONGPinChallenge : NSObject

@property (nonatomic, readonly) ONGUserProfile *userProfile;
@property (nonatomic, readonly) NSUInteger maxPinAttempts;
@property (nonatomic, readonly) NSUInteger usedPinAttempts;
@property (nonatomic, strong, readonly, nullable) NSError *error;
@property (nonatomic, strong, readonly) id<ONGPinChallengeSender> sender;

+(instancetype)pinChallengeWithUser:(ONGUserProfile *)userProfile
                     maxPinAttempts:(NSUInteger)maxPinAttempts
                    usedPinAttempts:(NSUInteger)usedPinAttempts
                              error:(NSError *)error
                             sender:(id<ONGPinChallengeSender>)sender;

@end