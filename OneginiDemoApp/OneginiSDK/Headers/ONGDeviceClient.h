// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicCommons.h"
#import "ONGDeviceAuthenticationDelegate.h"

@protocol ONGResourceHandlerDelegate;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

@interface ONGDeviceClient : NSObject

/**
 * Access to the initialized and configured instance of the `ONGDeviceClient`. Before calling this method You have to initialize
 * SDK by calling `-[ONGClientBuilder build]`.
 *
 * @return instance of the configured `ONGDeviceClient`.
 *
 * @see `ONGClientBuilder`, `-[ONGClient deviceClient]`
 *
 * @warning If the SDK is not initialized via `-[ONGClientBuilder build]` this method throws an exception.
 */
+ (ONGDeviceClient *)sharedInstance;

/**
 * Developers should not try to instantiate SDK on their own. The only valid way to get `ONGDeviceClient` instance is by
 * calling `-[ONGDeviceClient sharedInstance]`.
 *
 * @see -sharedInstance
 */
- (instancetype)init ONG_UNAVAILABLE;
+ (instancetype)new ONG_UNAVAILABLE;


/**
 *  Performs client's authentication. Uses client's credentials to request an accessToken object, which can be used for performing anonymous resource calls.
 *
 *  @param scopes array of scopes
 *  @param delegate authentication delegate
 */
- (void)authenticateDevice:(nullable NSArray<NSString *> *)scopes delegate:(id<ONGDeviceAuthenticationDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop