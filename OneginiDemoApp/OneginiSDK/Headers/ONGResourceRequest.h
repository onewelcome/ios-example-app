// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicCommons.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ONGParametersEncoding) {
    ONGParametersEncodingFormURL,
    ONGParametersEncodingJSON,
    ONGParametersEncodingPropertyList
};

@interface ONGResourceRequest : NSObject <NSCopying, NSMutableCopying>

@property (copy, readonly) NSString *path;
@property (copy, readonly) NSString *method;
@property (copy, readonly, nullable) NSDictionary *headers;
@property (copy, readonly, nullable) NSDictionary *parameters;
@property (readonly) ONGParametersEncoding parametersEncoding;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary *)parameters;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary *)parameters encoding:(ONGParametersEncoding)encoding;

@end

@interface ONGMutableResourceRequest : ONGResourceRequest

@property (copy) NSString *path;
@property (copy) NSString *method;
@property (copy) NSDictionary *headers;
@property (copy) NSDictionary *parameters;
@property ONGParametersEncoding parametersEncoding;

@end

NS_ASSUME_NONNULL_END