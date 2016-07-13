//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

typedef NS_ENUM(NSInteger, ONGHTTPClientParameterEncoding) {
    ONGFormURLParameterEncoding,
    ONGJSONParameterEncoding,
    ONGPropertyListParameterEncoding,
};

/**
 The name of the notification send to listeners to inform them that the embedded web view has been closed.
 This is only used in if the ONGConfigModel kOGUseEmbeddedWebview is set to true.
 */
extern NSString *const ONGCloseWebViewNotification;

/**
 If the PIN validation fails with error ONGPinValidationErrorPinShouldNotUseSimilarDigits then the
 userInfo contains the following key with the max similar digits value from the received pin policy.
 */
extern NSString *const ONGPinValidationMaxSimilarDigits;

extern NSString *const ONGErrorDomainPinValidation;
typedef enum : NSInteger {
    ONGPinValidationErrorPinShouldNotBeASequence,
    ONGPinValidationErrorPinShouldNotUseSimilarDigits, // The ONGPinValidationMaxSimilarDigits key is contained in the userInfo object
    ONGPinValidationErrorPinTooShort,
    ONGPinValidationErrorPinBlacklisted
} ONGPinValidationErrorCode;

@interface ONGPublicCommons : NSObject
@end

#pragma clang diagnostic pop