// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
@class ONGUserClient;
@class ONGUserProfile;
@class ONGCreatePinChallenge;

@protocol ONGRegistrationDelegate<NSObject>

- (void)userClient:(ONGUserClient *)userClient didReceivePinRegistrationChallenge:(ONGCreatePinChallenge *)challenge;
- (void)userClient:(ONGUserClient *)userClient didReceiveAuthenticationCodeRequestWithUrl:(NSURL *)url;

@optional

- (void)userClientDidStartRegistration:(ONGUserClient *)userClient;
- (void)userClient:(ONGUserClient *)userClient didRegisterUser:(ONGUserProfile *)userProfile;
- (void)userClient:(ONGUserClient *)userClient didFailToRegisterWithError:(NSError *)error;

@end