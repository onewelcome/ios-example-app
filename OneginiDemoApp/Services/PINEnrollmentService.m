//
//  PINEnrollmentService.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "PINEnrollmentService.h"

@interface PINEnrollmentService () <OGPinValidationDelegate>

@end

@implementation PINEnrollmentService

@synthesize delegate = _delegate;

#pragma mark - Public API

- (void)setNewPin:(NSString *)pin {
    [self.client confirmNewPin:pin validation:self];
    [self.delegate PINEnrollmentServiceDidFinishEnrollment:self];
}

#pragma mark - Private API

- (void)handleError:(NSError *)error {
    [self.delegate PINEnrollmentService:self didFailEnrollmentWithError:error];
}

#pragma mark - OGPinValidationDelegate

- (void)pinBlackListed {
    [self handleError:nil];
}

- (void)pinShouldNotBeASequence {
    [self handleError:nil];
}

- (void)pinShouldNotUseSimilarDigits:(NSUInteger)count {
    [self handleError:nil];
}

- (void)pinTooShort {
    [self handleError:nil];
}

- (void)pinEntryError:(NSError *)error {
    [self handleError:error];
}

@end
