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

@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSString *method;
@property (nonatomic, copy, readonly, nullable) NSDictionary *headers;
@property (nonatomic, copy, readonly, nullable) NSDictionary *parameters;
@property (nonatomic, readonly) ONGParametersEncoding parametersEncoding;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary *)parameters;
- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary *)parameters encoding:(ONGParametersEncoding)encoding;

@end

@interface ONGMutableResourceRequest : ONGResourceRequest

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSDictionary *headers;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic) ONGParametersEncoding parametersEncoding;

@end

NS_ASSUME_NONNULL_END