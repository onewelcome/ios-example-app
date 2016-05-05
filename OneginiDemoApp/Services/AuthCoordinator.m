//
//  AuthCoordinator.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AuthCoordinator.h"

#import "OneginiClientBuilder.h"

// Services
#import "AuthorizationService.h"
#import "PINEnrollmentService.h"

@interface AuthCoordinator () <AuthorizationServiceDelegate, PINEnrollmentServiceDelegate>

@property (nonatomic, strong) id<AuthorizationService> authService;
@property (nonatomic, strong) id<PINEnrollmentService> pinEnrollmentService;

@end

@implementation AuthCoordinator

// Create dependencies here for demo purpose only. It shoud be set from the outside
- (instancetype)init {
    self = [super init];
    if (self) {
        OGOneginiClient *client = [OneginiClientBuilder buildClient];
        self.authService = [[AuthorizationService alloc] initWithClient:client];
        self.authService.delegate = self;
        self.pinEnrollmentService = [[PINEnrollmentService alloc] initWithClient:client];
        self.pinEnrollmentService.delegate = self;
    }
    return self;
}

#pragma mark - Public API

- (void)login {
    [self.authService login];
}

- (void)setNewPin:(NSString *)pin {
    [self.pinEnrollmentService setNewPin:pin];
}

- (void)enterCurrentPIN:(NSString *)pin {
    [self.authService enterCurrentPIN:pin];
}

#pragma mark - PINEnrollmentServiceDelegate

- (void)authorizationService:(id<AuthorizationService>)service didStartLoginWithURL:(NSURL *)url {
    [self.delegate authCoordinator:self didStartLoginWithURL:url];
}

- (void)authorizationService:(id<AuthorizationService>)service didFailLoginWithError:(NSError *)error {
    [self.delegate authCoordinator:self didFailLoginWithError:error];
}

- (void)authorizationService:(id<AuthorizationService>)service didRequestPINEnrollemntWithCountNumbers:(NSInteger)count {
    [self.delegate authCoordinator:self presentCreatePINWithMaxCountOfNumbers:count];
}

- (void)authorizationServiceDidFinishLogin:(id<AuthorizationService>)service {
    [self.delegate authCoordinatorDidFinishLogin:self];
}

- (void)authorizationServiceDidAskForCurrentPIN:(id<AuthorizationService>)service {
    [self.delegate authCoordinatorDidAskForCurrentPIN:self];
}

#pragma mark - PINEnrollmentServiceDelegate

- (void)PINEnrollmentServiceDidFinishEnrollment:(id<PINEnrollmentService>)service {
    [self.delegate authCoordinatorDidFinishPINEnrollment:self];
}

- (void)PINEnrollmentService:(id<PINEnrollmentService>)service didFailEnrollmentWithError:(NSError *)error {
    [self.delegate authCoordinator:self didFailPINEnrollmentWithError:error];
}

@end
