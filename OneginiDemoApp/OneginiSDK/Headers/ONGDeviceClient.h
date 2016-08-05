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
 *  Performs device authentication.
 *
 *  @param scopes array of scopes
 *  @param delegate authentication delegate
 */
- (void)authenticateDevice:(nullable NSArray<NSString *> *)scopes delegate:(id<ONGDeviceAuthenticationDelegate>)delegate;

/**
 *  Fetches a resource anonymously using a client access token.
 *  Requires deviece to be authenticated.
 *
 *  @param path part of URL appended to base URL provided in Onegini client configuration.
 *  @param requestMethod HTTP request method, can be one of @"GET", @"POST", @"PUT" and @"DELETE".
 *  @param params additional request parameters. Parameters are appended to URL or provided within a body depending on the request method.
 *  @param paramsEncoding encoding used for params, possible values are ONGJSONParameterEncoding, ONGFormURLParameterEncoding or ONGPropertyListParameterEncoding
 *  @param headers additional headers added to HTTP request. Onegini SDK takes responsibility of managing `Authorization`and `User-Agent` headers.
 *  @param delegate object responsible for handling resource callbacks. Onegini client invokes the delegate callback with the response payload.
 *  @return requestId unique request ID.
 */
- (NSString *)fetchAnonymousResource:(NSString *)path
                       requestMethod:(NSString *)requestMethod
                              params:(nullable NSDictionary<NSString *, NSString *> *)params
                      paramsEncoding:(ONGHTTPClientParameterEncoding)paramsEncoding
                             headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                            delegate:(id<ONGResourceHandlerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop