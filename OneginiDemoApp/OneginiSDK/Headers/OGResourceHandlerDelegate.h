//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    OGResourceErrorCode_InvalidRequestMethod,   //provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    OGResourceErrorCode_Generic                 //undefined error preventing from performing resource call
} OGResourceErrorCode;

/**
 *  Delegate protocol for use by resource handler classes.
 */
@protocol OGResourceHandlerDelegate<NSObject>

NS_ASSUME_NONNULL_BEGIN

@optional

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
 *  @param error    defines type of error which occured
 *  @param requestId unique request identifier which matches the `requestId` returned by fetch resource call.
 */
- (void)resourceError:(NSError *)error requestId:(NSString *)requestId;

#pragma mark - DEPRECATED

/**
 *  Method called when the resource call was successfully made.
 *  Optional but either this one or the one with the headers should be implemented.
 */
- (void)resourceSuccess:(id)response DEPRECATED_ATTRIBUTE;

/**
 *  Method called when the resource call was successfully made.
 *  Optional but either this one or the one with the headers should be implemented.
 *  @param response the response of the resource call
 *  @param headers the headers returned on the resource call
 */
- (void)resourceSuccess:(id)response
                headers:(NSDictionary *)headers DEPRECATED_ATTRIBUTE;

/**
 *  Method called when the resource call failed because of an unknown error.
 */
- (void)resourceError DEPRECATED_ATTRIBUTE;

/**
 *  Method called when the requested grant type is not allowed for this client.
 */
- (void)unauthorizedClient DEPRECATED_ATTRIBUTE;
- (void)resourceErrorNotAuthenticated;

NS_ASSUME_NONNULL_END

@end