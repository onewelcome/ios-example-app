// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicCommons.h"

@protocol ONGResourceHandlerDelegate;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

@interface ONGNetworkClient : NSObject

/**
 * Access to the initialized and configured instance of the `ONGNetworkClient`. Before calling this method You have to initialize
 * SDK by calling `-[ONGClientBuilder build]`.
 *
 * @return instance of the configured `ONGNetworkClient`.
 *
 * @see `ONGClientBuilder`, `-[ONGClient networkClient]`
 *
 * @warning If the SDK is not initialized via `-[ONGClientBuilder build]` this method throws an exception.
 */
+ (ONGNetworkClient *)sharedInstance;

/**
 * Developers should not try to instantiate SDK on their own. The only valid way to get `ONGNetworkClient` instance is by
 * calling `-[ONGNetworkClient sharedInstance]`.
 *
 * @see -sharedInstance
 */
- (instancetype)init ONG_UNAVAILABLE;
+ (instancetype)new ONG_UNAVAILABLE;

/**
 *  Fetches a user specific resource.
 *
 *  @param path part of URL appended to base URL provided in Onegini client configuration.
 *  @param requestMethod HTTP request method, can be one of @"GET", @"POST", @"PUT" and @"DELETE".
 *  @param params additional request parameters. Parameters are appended to URL or provided within a body depending on the request method.
 *  @param paramsEncoding encoding used for params, possible values are ONGJSONParameterEncoding, ONGFormURLParameterEncoding or ONGPropertyListParameterEncoding
 *  @param headers additional headers added to HTTP request. Onegini SDK takes responsibility of managing `Authorization`and `User-Agent` headers.
 *  @param delegate object responsible for handling resource callbacks. Onegini client invokes the delegate callback with the response payload.
 *  @return requestId unique request ID.
 */
- (NSString *)fetchResource:(NSString *)path
              requestMethod:(NSString *)requestMethod
                     params:(nullable NSDictionary<NSString *, NSString *> *)params
             paramsEncoding:(ONGHTTPClientParameterEncoding)paramsEncoding
                    headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                   delegate:(id<ONGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a resource anonymously using a client access token.
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

/**
 * Returns a string with access token for the currently authenticated user, or nil if no user is currently
 * authenticated.
 *
 * <strong>Warning</strong>: Do not use this method if you want to fetch resources from your resource gateway: use the resource methods
 * instead.
 *
 * @return String with access token or nil
 */
@property (nonatomic, readonly, nullable) NSString *userAccessToken;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop