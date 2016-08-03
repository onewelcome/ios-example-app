// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicCommons.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Supported types of parameters encoding during network request construction.
 */
typedef NS_ENUM(NSInteger, ONGParametersEncoding) {
    ONGParametersEncodingFormURL,
    ONGParametersEncodingJSON,
    ONGParametersEncodingPropertyList
};

/**
 * Object that encapsulates arguments required for performing network request.
 *
 * @see ONGRequestBuilder, ONGMutableResourceRequest, ONGNetworkTask.
 */
@interface ONGResourceRequest : NSObject <NSCopying, NSMutableCopying>

/**
 * Path to the resource.
 *
 * @warning path should be relative to the resource base URL from config model (`ONGResourceBaseURL`).
 */
@property (copy, readonly) NSString *path;

/**
 * HTTP Method. Supported values are: `GET`, `POST`, `PUT`, `DELETE`.
 * In case of invalid method request won't be executed and error returned.
 */
@property (copy, readonly) NSString *method;

/**
 * HTTP Headers to be added to the network request.
 *
 * @warning next reserved fields take precedence over custom: `Authorization`, `User-Agent`.
 */
@property (copy, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;

/**
 * Parameters that will be added to the request. In conjunction with `parametersEncoding` value it forms body or URL of the request.
 *
 * @discussion For example parameters {"key": "value"} for `parameterEncoding` equals to ONGParametersEncodingFormURL will form URL:
 * https://your.resource.server/path?key=value
 *
 * For `ONGParametersEncodingJSON` parameters dictionary will be appended to the body
 */
@property (copy, readonly, nullable) NSDictionary<NSString *, id> *parameters;

/**
 * Type of parameters encoding. It affects on how `parameters` gets appended to the request. Sets `Content-Type` header value:
 * ONGParametersEncodingFormURL - application/x-www-form-urlencoded
 * ONGParametersEncodingJSON - application/json
 * ONGParametersEncodingPropertyList - application/x-plist
 *
 * Default value is ONGParametersEncodingJSON.
 */
@property (readonly) ONGParametersEncoding parametersEncoding;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary *)parameters;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary *)parameters encoding:(ONGParametersEncoding)encoding;

@end

/**
 * Mutable companion of ONGResourceRequest.
 *
 * @see ONGResourceRequest, ONGRequestBuilder.
 */
@interface ONGMutableResourceRequest : ONGResourceRequest

@property (copy) NSString *path;
@property (copy) NSString *method;
@property (copy) NSDictionary<NSString *, NSString *> *headers;
@property (copy) NSDictionary<NSString *, id> *parameters;
@property ONGParametersEncoding parametersEncoding;

@end

NS_ASSUME_NONNULL_END