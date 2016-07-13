//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

NS_ASSUME_NONNULL_BEGIN

ONG_EXTERN NSString *const ONGSDKInitializationException;

typedef NS_ENUM(NSInteger, OGHTTPClientParameterEncoding) {
    OGFormURLParameterEncoding,
    OGJSONParameterEncoding,
    OGPropertyListParameterEncoding,
};

/**
 The name of the notification send to listeners to inform them that the embedded web view has been closed.
 This is only used in if the OGConfigModel kOGUseEmbeddedWebview is set to true.
 */
ONG_EXTERN NSString *const OGCloseWebViewNotification;

/**
 If the PIN validation fails with error FailPinShouldNotUseSimilarDigits then the
 userInfo contains the following key with the max similar digits value from the received pin policy.
 */
ONG_EXTERN NSString *const PinValidationMaxSimilarDigits;

extern NSString *const NSERROR_DOMAIN_PIN_VALIDATION;
typedef enum : NSInteger {
    FailPinShouldNotBeASequence,
    FailPinShouldNotUseSimilarDigits, // The PinValidationMaxSimilarDigits key is contained in the userInfo object
    FailPinTooShort,
    FailPinBlacklisted
} PinValidationErrorCode;

@interface OGPublicCommons : NSObject
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
