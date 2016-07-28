// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@protocol ONGFingerprintChallengeSender<NSObject>

- (void)continueChallenge;
- (void)continueChallengeWithPrompt:(NSString *)prompt;
- (void)fallbackToPinChallenge;

@end

@interface ONGFingerprintChallenge : NSObject

@property (nonatomic, readonly, nullable) NSError *error;
@property (nonatomic, readonly) id<ONGFingerprintChallengeSender> sender;

+(instancetype)fingerprintChallengeWithSender:(id<ONGFingerprintChallengeSender>)sender error:(NSError *)error;

@end