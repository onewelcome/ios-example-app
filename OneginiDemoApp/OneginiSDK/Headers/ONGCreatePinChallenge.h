// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@protocol ONGPinValidationDelegate;

/**
 * Protocol to delegate control back to the SDK after the user entered the PIN.
 *
 * An object conforming to this protocol must be used when letting the user choose a PIN.
 */
@protocol ONGCreatePinChallengeSender<NSObject>

/**
 * Method to provide the PIN to the SDK.
 *
 * @param pin PIN provided by the user
 * @param delegate object responsible for handling error on pin validation against pin policy
 */
- (void)continueChallengeWithPin:(NSString *)pin;

@end

@interface ONGCreatePinChallenge : NSObject

@property (nonatomic, readonly) ONGUserProfile *userProfile;
@property (nonatomic, readonly) NSUInteger pinLength;
@property (nonatomic, strong, readonly, nullable) NSError *error;
@property (nonatomic, strong, readonly) id<ONGCreatePinChallengeSender> sender;

+(instancetype)createPinChallengeWithUser:(ONGUserProfile *)userProfile
                                pinLength:(NSUInteger)pinLength
                                    error:(NSError *)error
                                     sender:(id<ONGCreatePinChallengeSender>)sender;

@end