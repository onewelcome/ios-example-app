//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

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

NS_ASSUME_NONNULL_END