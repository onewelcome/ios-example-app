// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The object that encapsulates response values.
 *
 * @see ONGNetworkTask.
 */
@interface ONGResourceResponse: NSObject

/**
 * The raw response object
 */
@property (nonatomic, readonly) NSHTTPURLResponse *rawResponse;

/**
 * The received HTTP response headers. A shortcut for rawResponse.allHeaderFields
 */
@property (nonatomic, copy, readonly) NSDictionary *allHeaderFields;

/**
 * The HTTP response status code. A shortcut for rawResponse.statusCode
 */
@property (nonatomic, readonly) NSInteger statusCode;

/**
 * The response body data.
 *
 * The SDK doesn't perform any data mapping and leaves this up to you. You may want to process this data as JSON, for example.
 */
@property (nonatomic, readonly, nullable) NSData *data;

- (instancetype)initWithResponse:(NSHTTPURLResponse *)response data:(nullable NSData *)data;

@end

NS_ASSUME_NONNULL_END