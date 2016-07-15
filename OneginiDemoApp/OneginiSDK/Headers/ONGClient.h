// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

#import "ONGOneginiClient.h"
#import "ONGConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Main entry point for the Onegini SDK. This class owns SDK's configuration and such clients as `ONGOneginiClient` and
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
 * Instance of `ONGOneginiClient` used for user-related features access. Once SDK has been configured, `ONGOneginiClient`
 * can be access either by calling this property or by `-[ONGOneginiClient sharedInstance]`.
 *
 * @see `-[ONGOneginiClient sharedInstance]`
 */
@property (nonatomic, readonly) ONGOneginiClient *userClient;

@end

NS_ASSUME_NONNULL_END