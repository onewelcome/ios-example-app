// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicCommons.h"

@class ONGNetworkTask;
@class ONGResourceRequest;
@class ONGResourceResponse;

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
 * Performs device authentication.
 *
 * The returned error will be of the ONGGenericErrorDomain.
 *
 * @param scopes array of scopes.
 * @param completion block that will be called on authentication completion.
 */
- (void)authenticateDevice:(nullable NSArray<NSString *> *)scopes completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 * Perform an authenticated network request. It requires passing an instance of the `ONGResourceRequest` as parameter.
 * In case of a malformed request no task will be returned and the completion block is called immediatelly (sychronously).
 * The device needs to be authenticated, otherwise SDK will return the `ONGFetchAnonymousResourceErrorDeviceNotAuthenticated` error.
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGFetchAnonymousResourceErrorDomain or NSURLErrorDomain.
 *
 * @param request instance of `ONGResourceRequest` instantiated manually or by using `ONGRequestBuilder`
 * @param completion block that will be called either upon request completion or immediatelly in case if validation error.
 * @return instance of `ONGNetworkTask` or nil. By utilizing `ONGNetworkTask` developer may observe and control execution of the request.
 */
- (nullable ONGNetworkTask *)fetchResource:(ONGResourceRequest *)request completion:(nullable void (^)(ONGResourceResponse * _Nullable response, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop