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

@synthesize delegate = _delegate;

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

- (void)handleError:(NSError *)error {
    [self.delegate authorizationService:self didFailLoginWithError:error];
}

#pragma mark - OGAuthorizationDelegate

- (void)authorizationSuccess {
    
}

- (void)requestAuthorization:(NSURL *)url {
    [self.delegate authorizationService:self didStartLoginWithURL:url];
}

- (void)askForNewPin:(NSUInteger)pinSize {
    [self.delegate authorizationService:self didRequestPINEnrollemntWithCountNumbers:pinSize];
}

- (void)askForCurrentPin {
    [self handleError:nil];
}

- (void)askCurrentPinForChangeRequest {
    [self handleError:nil];
}

- (void)askNewPinForChangeRequest:(NSUInteger)pinSize {
    [self handleError:nil];
}

- (void)askForPushAuthenticationConfirmation:(NSString *)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm {
    [self handleError:nil];
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message
                                   notificationType:(NSString *)notificationType
                                            pinSize:(NSUInteger)pinSize
                                        maxAttempts:(NSUInteger)maxAttempts
                                       retryAttempt:(NSUInteger)retryAttempt
                                            confirm:(PushAuthenticationWithPinConfirmation)confirm {
    
}

- (void)askForPushAuthenticationWithFingerprint:(NSString*)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm {
    
}

- (void)authorizationError {
    [self handleError:nil];
}

- (void)authorizationErrorTooManyPinFailures {
    [self handleError:nil];
}

- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining {
    [self handleError:nil];
}

- (void)authorizationErrorNoAuthorizationGrant {
    [self handleError:nil];
}

- (void)authorizationErrorNoAccessToken {
    [self handleError:nil];
}

- (void)authorizationErrorInvalidRequest {
    [self handleError:nil];
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
    [self handleError:nil];
}

- (void)authorizationErrorInvalidState {
    [self handleError:nil];
}

- (void)authorizationErrorInvalidScope {
    [self handleError:nil];
}

- (void)authorizationErrorNotAuthenticated {
    [self handleError:nil];
}

- (void)authorizationErrorInvalidGrantType {
    [self handleError:nil];
}

- (void)authorizationErrorInvalidAppPlatformOrVersion {
    [self handleError:nil];
}

- (void)authorizationErrorUnsupportedOS {
    [self handleError:nil];
}

- (void)authorizationErrorNotAuthorized {
    [self handleError:nil];
}

- (void)authorizationError:(NSError *)error {
    [self handleError:nil];
}

@end
