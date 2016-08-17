// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGAuthenticator : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;

+ (instancetype)authenticatorWithIdentifier:(NSString *)identifier;

@end