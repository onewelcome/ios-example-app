//
//  AuthCoordinator.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AuthCoordinator.h"

#import "OneginiSDK.h"
#import "OneginiClientBuilder.h"

@interface AuthCoordinator ()
<
    OGAuthorizationDelegate,
    OGPinValidationDelegate,
    OGLogoutDelegate,
    OGDisconnectDelegate
>

@property (nonatomic, strong) OGOneginiClient *client;

@end

@implementation AuthCoordinator

- (instancetype)initWithOneginiClient:(OGOneginiClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        self.client.authorizationDelegate = self;
    }
    return self;
}

// Create dependencies here for demo purpose only. It shoud be set from the outside
- (instancetype)init {
    self = [super init];
    if (self) {
        self.client = [OneginiClientBuilder buildClient];
        self.client.authorizationDelegate = self;
    }
    return self;
}

#pragma mark - Public API

- (void)registerUser {
    [self.client authorize:@[@"read"]];
}

- (void)login {
    [self.client authorize:@[@"read"]];
}

- (void)setNewPin:(NSString *)pin {
    [self.client confirmNewPin:pin validation:self];
}

- (void)enterCurrentPIN:(NSString *)pin {
    [self.client confirmCurrentPin:pin];
}

- (BOOL)isRegistered {
    return [self.client isClientRegistered];
}

- (void)logout {
    [self.client logoutWithDelegate:self];
}

- (void)disconnect {
    [self.client disconnectWithDelegate:self];
}

#pragma mark -

- (void)handleAuthError:(NSError *)error {
    [self.delegate authCoordinator:self didFailLoginWithError:error];
}

- (void)handlePINError:(NSError *)error {
    [self.delegate authCoordinator:self didFailPINEnrollmentWithError:error];
}

#pragma mark - OGAuthorizationDelegate

- (void)authorizationSuccess {
    [self.delegate authCoordinatorDidFinishLogin:self];
}

- (void)requestAuthorization:(NSURL *)url {
    [self.delegate authCoordinator:self didStartLoginWithURL:url];
}

- (void)askForNewPin:(NSUInteger)pinSize {
    [self.delegate authCoordinator:self presentCreatePINWithMaxCountOfNumbers:pinSize];
}

- (void)askForCurrentPin {
    [self.delegate authCoordinatorDidAskForCurrentPIN:self];
}

- (void)askCurrentPinForChangeRequest {
    
}

- (void)askNewPinForChangeRequest:(NSUInteger)pinSize {
    
}

- (void)askForPushAuthenticationConfirmation:(NSString *)message
                            notificationType:(NSString *)notificationType
                                     confirm:(PushAuthenticationConfirmation)confirm {
    
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message
                                   notificationType:(NSString *)notificationType
                                            pinSize:(NSUInteger)pinSize
                                        maxAttempts:(NSUInteger)maxAttempts
                                       retryAttempt:(NSUInteger)retryAttempt
                                            confirm:(PushAuthenticationWithPinConfirmation)confirm {
    
}

- (void)askForPushAuthenticationWithFingerprint:(NSString*)message
                               notificationType:(NSString *)notificationType
                                        confirm:(PushAuthenticationConfirmation)confirm {
    
}

- (void)authorizationError {
    [self handleAuthError:nil];
}

- (void)authorizationErrorTooManyPinFailures {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining {
    [self.delegate authCoordinatorDidEnterWrongPIN:self remainingAttempts:remaining];
}

- (void)authorizationErrorNoAuthorizationGrant {
    [self handleAuthError:nil];
}

- (void)authorizationErrorNoAccessToken {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidRequest {
    [self handleAuthError:nil];
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidState {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidScope {
    [self handleAuthError:nil];
}

- (void)authorizationErrorNotAuthenticated {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidGrantType {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidAppPlatformOrVersion {
    [self handleAuthError:nil];
}

- (void)authorizationErrorUnsupportedOS {
    [self handleAuthError:nil];
}

- (void)authorizationErrorNotAuthorized {
    [self handleAuthError:nil];
}

- (void)authorizationError:(NSError *)error {
    [self handleAuthError:nil];
}

#pragma mark - OGPinValidationDelegate

- (void)pinBlackListed {
    [self handlePINError:nil];
}

- (void)pinShouldNotBeASequence {
    [self handlePINError:nil];
}

- (void)pinShouldNotUseSimilarDigits:(NSUInteger)count {
    [self handlePINError:nil];
}

- (void)pinTooShort {
    [self handlePINError:nil];
}

- (void)pinEntryError:(NSError *)error {
    [self handlePINError:error];
}

#pragma mark - OGLogoutDelegate

- (void)logoutSuccessful {
    if ([self.logoutDelegate respondsToSelector:@selector(authCoordinatorDidFinishLogout:)]) {
        [self.logoutDelegate authCoordinatorDidFinishLogout:self];
    }
}

- (void)logoutFailureWithError:(NSError *)error {
    if ([self.logoutDelegate respondsToSelector:@selector(authCoordinator:didFailLogoutWithError:)]) {
        [self.logoutDelegate authCoordinator:self didFailLogoutWithError:error];
    }
}

#pragma mark - OGDisconnectDelegate 

- (void)disconnectSuccessful {
    if ([self.disconnectDelegate respondsToSelector:@selector(authCoordinatorDidFinishDisconnection:)]) {
        [self.disconnectDelegate authCoordinatorDidFinishDisconnection:self];
    }
}

- (void)disconnectFailureWithError:(NSError *)error {
    if ([self.disconnectDelegate respondsToSelector:@selector(authCoordinator:didFailDisconnectionWithError:)]) {
        [self.disconnectDelegate authCoordinator:self didFailDisconnectionWithError:error];
    }
}

@end
