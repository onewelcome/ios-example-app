//
//  PINEnrollmentServiceProtocol.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PINEnrollmentService;

@protocol PINEnrollmentServiceDelegate <NSObject>

- (void)PINEnrollmentServiceDidFinishEnrollment:(id<PINEnrollmentService>)service;
- (void)PINEnrollmentService:(id<PINEnrollmentService>)service didFailEnrollmentWithError:(NSError *)error;

@end

@protocol PINEnrollmentService <NSObject>

@property (nonatomic, weak, nullable) id<PINEnrollmentServiceDelegate> delegate;

- (void)setNewPin:(NSString *)pin;

@end

NS_ASSUME_NONNULL_END