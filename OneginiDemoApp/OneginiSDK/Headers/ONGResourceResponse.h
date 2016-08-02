// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGResourceResponse: NSObject

@property (nonatomic, copy, readonly, nullable) NSDictionary *headers;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly, nullable) NSData *data;

@end