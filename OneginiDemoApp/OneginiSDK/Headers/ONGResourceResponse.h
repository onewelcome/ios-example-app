// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 * Object that encapsulates response values.
 *
 * @see ONGNetworkTask.
 */
@interface ONGResourceResponse: NSObject

/**
 * Received response HTTP headers.
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary *headers;

/**
 * Response HTTP Status Code.
 */
@property (nonatomic, readonly) NSInteger statusCode;

/**
 * Response body data.
 *
 * SDK doesn't perform any data mapping and leave this up to the developer. You may want to process this data as JSON, for example.
 */
@property (nonatomic, readonly, nullable) NSData *data;

@end