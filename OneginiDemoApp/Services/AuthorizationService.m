//
//  AuthorizationService.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AuthorizationService.h"

@interface AuthorizationService () <OGAuthorizationDelegate>

@end

@implementation AuthorizationService

- (instancetype)initWithClient:(OGOneginiClient *)client {
    self = [super initWithClient:client];
    if (self) {
        client.authorizationDelegate = self;
    }
    return self;
}

- (void)login {
    [self.client authorize:@[@"read"]];
}

#pragma mark - OGAuthorizationDelegate

- (void)authorizationSuccess {
    
}

- (void)requestAuthorization:(NSURL *)url {
    
}

- (void)askForNewPin:(NSUInteger)pinSize {
    
}

- (void)askForCurrentPin {
    
}

- (void)askCurrentPinForChangeRequest {
    
}

- (void)askNewPinForChangeRequest:(NSUInteger)pinSize {
    
}

- (void)askForPushAuthenticationConfirmation:(NSString *)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm {
    
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message notificationType:(NSString *)notificationType
                                            pinSize:(NSUInteger)pinSize	maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt
                                            confirm:(PushAuthenticationWithPinConfirmation)confirm {
    
}

- (void)askForPushAuthenticationWithFingerprint:(NSString*)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm {
    
}

- (void)authorizationError {
    
}

- (void)authorizationErrorTooManyPinFailures {
    
}

- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining {
    
}

- (void)authorizationErrorNoAuthorizationGrant {
    
}

- (void)authorizationErrorNoAccessToken {
    
}

- (void)authorizationErrorInvalidRequest {
    
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
    
}

- (void)authorizationErrorInvalidState {
    
}

- (void)authorizationErrorInvalidScope {
    
}

- (void)authorizationErrorNotAuthenticated {
    
}

- (void)authorizationErrorInvalidGrantType {
    
}

- (void)authorizationErrorInvalidAppPlatformOrVersion {
    
}

- (void)authorizationErrorUnsupportedOS {
    
}

- (void)authorizationErrorNotAuthorized {
    
}

- (void)authorizationError:(NSError *)error {
    
}

@end
