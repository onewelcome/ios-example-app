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

/**
 The name of the notification send to listeners to inform them that the embedded web view has been closed.
 This is only used in if the OGConfigModel kOGUseEmbeddedWebview is set to true.
 */
extern NSString* const OGCloseWebViewNotification;

/**
 If the PIN validation fails with error FailPinShouldNotUseSimilarDigits then the
 userInfo contains the following key with the max similar digits value from the received pin policy.
 */
extern NSString* const PinValidationMaxSimilarDigits;

extern NSString* const NSERROR_DOMAIN_PIN_VALIDATION;
typedef enum : NSInteger {
	FailPinShouldNotBeASequence,
	FailPinShouldNotUseSimilarDigits, // The PinValidationMaxSimilarDigits key is contained in the userInfo object
	FailPinTooShort,
	FailPinBlacklisted
} PinValidationErrorCode;

@interface OGPublicCommons : NSObject
@end
