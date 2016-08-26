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
 * The object that encapsulates arguments required for performing a network request.
 *
 * @see ONGRequestBuilder, ONGMutableResourceRequest, ONGNetworkTask.
 */
@interface ONGResourceRequest : NSObject <NSCopying, NSMutableCopying>

/**
 * The path to the resource.
 *
 * @warning The path must be relative to the resource base URL from the config model (`ONGResourceBaseURL`).
 */
@property (copy, readonly) NSString *path;

/**
 * The HTTP Method. Supported values are: `GET`, `POST`, `PUT`, `DELETE`.
 * In case of an invalid method the request won't be executed and an error is returned.
 *
 * The default value is `GET`.
 */
@property (copy, readonly) NSString *method;

/**
 * The HTTP Headers to be added to the network request.
 *
 * @warning The following reserved headers take precedence over any custom values inserted by you: `Authorization`, `User-Agent`.
 */
@property (copy, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;

/**
 * The parameters that will be added to the request. In conjunction with the `parametersEncoding` value it forms the body or URL of the request.
 *
 * @discussion For example the parameters {"key": "value"} for `parameterEncoding` equals to ONGParametersEncodingFormURL will form the following URL:
 * https://your.resource.server/path?key=value
 *
 * When using the `ONGParametersEncodingJSON` encoding, the parameters dictionary will be appended to the body.
 */
@property (copy, readonly, nullable) NSDictionary<NSString *, id> *parameters;

/**
 * The type of parameters encoding. It affects on how `parameters` get appended to the request. Sets the `Content-Type` header value:
 * ONGParametersEncodingFormURL - application/x-www-form-urlencoded
 * ONGParametersEncodingJSON - application/json
 * ONGParametersEncodingPropertyList - application/x-plist
 *
 * The default value is ONGParametersEncodingJSON.
 */
@property (readonly) ONGParametersEncoding parametersEncoding;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary<NSString *, id> *)parameters;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary<NSString *, id> *)parameters encoding:(ONGParametersEncoding)encoding;

@end

/**
 * The mutable companion of the ONGResourceRequest.
 *
 * @see ONGResourceRequest, ONGRequestBuilder.
 */
@interface ONGMutableResourceRequest : ONGResourceRequest

@property (copy) NSString *path;
@property (copy) NSString *method;
@property (copy, nullable) NSDictionary<NSString *, NSString *> *headers;
@property (copy, nullable) NSDictionary<NSString *, id> *parameters;
@property ONGParametersEncoding parametersEncoding;

@end

NS_ASSUME_NONNULL_END