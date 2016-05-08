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
#import "FlowController.h"

@interface AuthCoordinator () <OGAuthorizationDelegate, OGPinValidationDelegate, OGLogoutDelegate, OGDisconnectDelegate>

@property (nonatomic, strong) OGOneginiClient *client;

@end

@implementation AuthCoordinator

+ (AuthCoordinator *)sharedInstance {
    static AuthCoordinator *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
        singleton.client = [OneginiClientBuilder buildClient];
        singleton.client.authorizationDelegate = singleton;
    });
    
    return singleton;
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
    [[FlowController sharedInstance] authenticationFailedWithError];
}

- (void)handlePINError:(NSError *)error {
    [[FlowController sharedInstance] pinPolicyValidationFailed];
}

#pragma mark - OGAuthorizationDelegate

- (void)authorizationSuccess {
    [[FlowController sharedInstance] authorizationSucceded];
}

- (void)requestAuthorization:(NSURL *)url {
    [[FlowController sharedInstance] openURL:url];
}

- (void)askForNewPin:(NSUInteger)pinSize {
    [[FlowController sharedInstance] createPinWithSize:pinSize completion:^(NSString * pin) {
        [self.client confirmNewPin:pin validation:self];
    }];
}

- (void)askForCurrentPin {
    [[FlowController sharedInstance] askForCurrentPinCompletion:^(NSString *pin) {
        [self.client confirmCurrentPin:pin];
    }];
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
    [[FlowController sharedInstance] wrongPinEnteredRemaining:remaining];
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
    [[FlowController sharedInstance]logout];
}

- (void)logoutFailureWithError:(NSError *)error {
    [[FlowController sharedInstance]logout];
}

#pragma mark - OGDisconnectDelegate 

- (void)disconnectSuccessful {
    [[FlowController sharedInstance]disconnect];
}

- (void)disconnectFailureWithError:(NSError *)error {
    [[FlowController sharedInstance]disconnect];
}

@end
