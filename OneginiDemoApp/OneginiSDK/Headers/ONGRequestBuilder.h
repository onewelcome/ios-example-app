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
 * Set HTTP Method for target `ONGResourceRequest`. Supported values are: `GET`, `POST`, `PUT`, `DELETE`.
 */
- (instancetype)setMethod:(NSString *)method;

/**
 * Set path for target `ONGResourceRequest`.
 *
 * @warning path should be relative to the resource base URL from config model (`ONGResourceBaseURL`).
 */
- (instancetype)setPath:(NSString *)path;

/**
 * Set parameters for target `ONGResourceRequest`.
 *
 * For more information see `ONGResourceRequest.parameters`
 */
- (instancetype)setParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 * Set parametersEncoding for target `ONGResourceRequest`.
 *
 * Default value is ONGParametersEncodingJSON.
 */
- (instancetype)setParametersEncoding:(ONGParametersEncoding)parametersEncoding;

/**
 * Set HTTP Headers for target `ONGResourceRequest`.
 *
 * @warning next reserved fields take precedence over custom: `Authorization`, `User-Agent`.
 */
- (instancetype)setHeaders:(NSDictionary<NSString *, NSString *> *)headers;

/**
 * Build instance of `ONGResourceRequest` from current parameters. Further parameters changing doesn't affect on already build instances.
 *
 * @return new instance of `ONGResourceRequest`
 */
- (ONGResourceRequest *)build;

@end
