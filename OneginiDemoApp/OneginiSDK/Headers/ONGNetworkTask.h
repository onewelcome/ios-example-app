// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

@class ONGResourceRequest, ONGResourceResponse;

NS_ASSUME_NONNULL_BEGIN

/**
 * Possible values for ONGNetworkTask.state.
 */
typedef NS_ENUM(NSInteger, ONGNetworkTaskState) {
    ONGNetworkTaskStateRunning = 0, // default running state
    ONGNetworkTaskStateSuspended = 1, // task is suspended
    ONGNetworkTaskStateCancelled = 2, // task has been cancelled
    ONGNetworkTaskStateCompleted = 3 // task has been completed
};

/**
 * `ONGNetworkTask` is a cancelable object, representing actual network request.
 * If offers cancellation, taking request onto pause and resuming it.
 * Produced by `-[ONGUserClient fetchResource:completion:]` and `-[ONGDeviceClient fetchResource:completion:]`.
 *
 * @see ONGUserClient, ONGDeviceClient
 */
@interface ONGNetworkTask : NSObject

/**
 * Unique identifier given to every task.
 */
@property (copy, readonly) NSString *identifier;

/**
 * Value representing actual state of the task. Initial is `ONGNetworkTaskStateRunning`.
 * You may want to observer it through KVO.
 *
 * @see ONGNetworkTaskState
 */
@property (readonly) ONGNetworkTaskState state;

/**
 * Request, provided to the `-[ONGUserClient fetchResource:completion:]` and `-[ONGDeviceClient fetchResource:completion:]`.
 */
@property (readonly) ONGResourceRequest *request;

/**
 * Response value fulfilled upon completion. It may be nil if network task hasn't received any response from the server.
 *
 * @see ONGResourceResponse
 */
@property (readonly, nullable) ONGResourceResponse *response;

/**
 * Error value fulfilled upon completion. It may be nil in case of successful response.
 *
 * This error will be either within the ONGGenericErrorDomain, ONGFetchResourceErrorDomain (when instantiated via `-[ONGUserClient fetchResource:completion:]` or the ONGFetchAnonymousResourceErrorDomain (when instantiated via `-[ONGDeviceClient fetchResource:completion:]`).
 */
@property (readonly, nullable) NSError *error;

/**
 * Developers should not try to instantiate task on their own. The only valid way to get valid task instance is by
 * calling `-[ONGUserClient fetchResource:completion:]` or `-[ONGDeviceClient fetchResource:completion:]`.
 */
- (instancetype)init ONG_UNAVAILABLE;
+ (instancetype)new ONG_UNAVAILABLE;

/**
 * Resume suspended task. This moves task from the `ONGNetworkTaskStateSuspended` state to the `ONGNetworkTaskStateRunning`.
 * If task already completed (`ONGNetworkTaskStateCompleted`) or cancelled (`ONGNetworkTaskStateCancelled`) - this won't have any effect.
 *
 * By default you don't have to call `resume` - SDK starts task automatically.
 *
 * Attempt to resume already running task doesn't have any effect.
 */
- (void)resume;

/**
 * Suspend running task. This moves task from the `ONGNetworkTaskStateRunning` state to the `ONGNetworkTaskStateSuspended`.
 *
 * Attempt to suspend already suspended, cancelled (`ONGNetworkTaskStateCancelled`) or completed (`ONGNetworkTaskStateCompleted`) task doesn't have any effect.
 */
- (void)suspend;

/**
 * Cancel running or suspended task. This moves task to the `ONGNetworkTaskStateCancelled`.
 *
 * Attempt to cancle already cancelled or completed (`ONGNetworkTaskStateCompleted`) task doesn't have any effect.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END