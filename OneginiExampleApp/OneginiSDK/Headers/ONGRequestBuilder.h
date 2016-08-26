// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGResourceRequest.h"

/**
 * Object responsible for easier `ONGResourceRequest` construction.
 *
 * @see ONGResourceRequest.
 */
@interface ONGRequestBuilder : NSObject

/**
 * Return a new instance of a builder
 */
+ (instancetype)builder;

/**
 * Set the HTTP Method for the target `ONGResourceRequest`. The supported values are: `GET`, `POST`, `PUT`, `DELETE`.
 */
- (instancetype)setMethod:(NSString *)method;

/**
 * Set the path for the target `ONGResourceRequest`.
 *
 * @warning the path must be relative to the resource base URL from the config model (`ONGResourceBaseURL`).
 */
- (instancetype)setPath:(NSString *)path;

/**
 * Set the parameters for the target `ONGResourceRequest`.
 *
 * For more information see the `ONGResourceRequest.parameters`
 */
- (instancetype)setParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 * Set the parametersEncoding for the target `ONGResourceRequest`.
 *
 * The default value is `ONGParametersEncodingJSON`.
 */
- (instancetype)setParametersEncoding:(ONGParametersEncoding)parametersEncoding;

/**
 * Set the HTTP Headers for the target `ONGResourceRequest`.
 *
 * @warning The following reserved headers take precedence over any custom values inserted by you: `Authorization`, `User-Agent`.
 */
- (instancetype)setHeaders:(NSDictionary<NSString *, NSString *> *)headers;

/**
 * The build instance of the `ONGResourceRequest` from the current parameters. Since the returned object is immutable any further parameter changes doesn't
 * have an effect on already build instances.
 *
 * @return new a instance of the `ONGResourceRequest`
 */
- (ONGResourceRequest *)build;

@end
