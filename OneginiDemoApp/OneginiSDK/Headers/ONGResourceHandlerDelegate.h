//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    ONGResourceErrorCodeInvalidRequestMethod,   //provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGResourceErrorCodeGeneric                 //undefined error preventing from performing resource call
} ONGResourceErrorCode;

/**
 *  Delegate protocol for use by resource handler classes.
 */
@protocol ONGResourceHandlerDelegate<NSObject>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Method called when resource call was completed
 *
 *  @param response  object containing status code and headers. 
 *  @param body      bare data containing body which needs to be decoded.
 *  @param requestId unique request identifier which matches the `requestId` returned by fetch resource call.
 */
- (void)resourceResponse:(NSHTTPURLResponse *)response body:(nullable NSData *)body requestId:(NSString *)requestId;

/**
 *  Method called when resource call was not performed due to en error
 *
 *  @param error    defines type of error which occurred
 *  @param requestId unique request identifier which matches the `requestId` returned by fetch resource call.
 */
- (void)resourceError:(NSError *)error requestId:(NSString *)requestId;


NS_ASSUME_NONNULL_END

@end