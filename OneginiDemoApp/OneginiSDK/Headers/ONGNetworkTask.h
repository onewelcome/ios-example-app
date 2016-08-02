// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGResourceRequest, ONGResourceResponse;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ONGNetworkTaskState) {
    ONGNetworkTaskStateRunning = 0,
    ONGNetworkTaskStateSuspended = 1,
    ONGNetworkTaskStateCancelled = 2,
    ONGNetworkTaskStateCompleted = 3
};

@interface ONGNetworkTask : NSObject

@property (copy, readonly) NSString *identifier;
@property (readonly) ONGNetworkTaskState state;

@property (readonly) ONGResourceRequest *request;

@property (readonly, nullable) ONGResourceResponse *response;
@property (readonly, nullable) NSError *error;

- (void)resume;
- (void)suspend;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END