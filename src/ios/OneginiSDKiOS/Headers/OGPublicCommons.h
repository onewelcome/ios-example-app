//
//  OGPublicCommons.h
//  OneginiSDKiOS
//
//  Created by Eduard on 16-09-14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GET,
    POST,
    PUT,
	DELETE
} HTTPRequestMethod;

typedef enum : NSInteger {
	FormURLParameterEncoding,
	JSONParameterEncoding,
	PropertyListParameterEncoding,
} HTTPClientParameterEncoding;

extern NSString* const OGCloseWebViewNotification;

@interface OGPublicCommons : NSObject
@end
