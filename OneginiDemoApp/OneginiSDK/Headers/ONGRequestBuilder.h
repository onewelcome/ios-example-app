// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGResourceRequest.h"

@interface ONGRequestBuilder : NSObject

- (instancetype)setMethod:(NSString *)method;
- (instancetype)setPath:(NSString *)path;
- (instancetype)setParameters:(NSDictionary *)parameters;
- (instancetype)setParametersEncoding:(ONGParametersEncoding)parametersEncoding;
- (instancetype)setHeaders:(NSDictionary *)headers;

- (ONGResourceRequest *)build;

@end
