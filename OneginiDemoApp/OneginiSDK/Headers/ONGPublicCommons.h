//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

NS_ASSUME_NONNULL_BEGIN

ONG_EXTERN NSString *const ONGSDKInitializationException;

typedef NS_ENUM(NSInteger, ONGHTTPClientParameterEncoding) {
    ONGFormURLParameterEncoding,
    ONGJSONParameterEncoding,
    ONGPropertyListParameterEncoding,
};

/**
 The name of the notification send to listeners to inform them that the embedded web view has been closed.
 This is only used in if the ONGConfigModel kOGUseEmbeddedWebview is set to true.
 */
ONG_EXTERN NSString *const ONGCloseWebViewNotification;

/**
 If the PIN validation fails with error ONGPinValidationErrorPinShouldNotUseSimilarDigits then the
 userInfo contains the following key with the max similar digits value from the received pin policy.
 */
ONG_EXTERN NSString *const ONGPinValidationMaxSimilarDigits;

ONG_EXTERN NSString *const ONGErrorDomainPinValidation;
typedef enum : NSInteger {
    ONGPinValidationErrorPinShouldNotBeASequence,
    ONGPinValidationErrorPinShouldNotUseSimilarDigits, // The ONGPinValidationMaxSimilarDigits key is contained in the userInfo object
    ONGPinValidationErrorPinTooShort,
    ONGPinValidationErrorPinBlacklisted
} ONGPinValidationErrorCode;

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop