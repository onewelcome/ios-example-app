// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGUserClient.h"
#import "ONGConfigModel.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

@class ONGNetworkClient;

NS_ASSUME_NONNULL_BEGIN

/**
 * Main entry point for the Onegini SDK. This class owns SDK's configuration and such clients as `ONGUserClient` and
 * `ONGNetworkClient`. In order to use any feature of the OneginiSDK `-[ONGClientBuilder build]` needs to be called first.
 *
 * @see `ONGClientBuilder`
 */
@interface ONGClient : NSObject

/**
 * Access to the initialized and configured instance of the `ONGClient`. Before calling this method You have to initialize
 * SDK by calling `-[ONGClientBuilder build]`.
 *
 * @return instance of the configured `ONGClient`.
 *
 * @see `ONGClientBuilder`
 *
 * @warning If the SDK is not initialized via `-[ONGClientBuilder build]` this method throws an exception.
 */
+ (instancetype)sharedInstance;

/**
 * Is a mandatory first call on ONGClient which is returned by `-[ONGClientBuilder build]`.
 *
 * @param completion is called after the method processing has finished. If the SDK is successfully started, other further work is allowed.
 *
 *  @param error in one of the steps of the authentication process. This error will be either within the ONGGenericErrorDomain or the ONGSDKInitializationErrorDomain
 *
 * @see `ONGClientBuilder`
 *
 */

- (void)start:(void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 * Developers should not try to instantiate SDK on their own. The only valid way to get `ONGClient` instance is by
 * calling `-[ONGClient sharedInstance]`.
 *
 * @see -sharedInstance
 */
- (instancetype)init ONG_UNAVAILABLE;
+ (instancetype)new ONG_UNAVAILABLE;

/**
 * The ConfigModel used to configure OneginiSDK.
 */
@property (nonatomic, readonly) ONGConfigModel *configModel;

/**
 * Instance of `ONGUserClient` used for user-related features access. Once SDK has been configured, `ONGUserClient`
 * can be access either by calling this property or by `-[ONGUserClient sharedInstance]`.
 *
 * @see `-[ONGUserClient sharedInstance]`
 */
@property (nonatomic, readonly) ONGUserClient *userClient;

/**
 * Instance of `ONGNetworkClient` used for network-related features. Once SDK has been configured, `ONGNetworkClient`
 * can be access either by calling this property or by `-[ONGNetworkClient sharedInstance]`.
 *
 * @see `-[ONGNetworkClient sharedInstance]`
 */
@property (nonatomic, readonly) ONGNetworkClient *networkClient;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop