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
 * `ONGNetworkTask` is a cancelable object, representing the actual network request.
 * It offers cancelling, pausing and resuming requests.
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
 * Value representing the actual state of the task. the initial state is: `ONGNetworkTaskStateRunning`.
 * You may want to observer it through KVO.
 *
 * @see ONGNetworkTaskState
 */
@property (readonly) ONGNetworkTaskState state;

/**
 * The request, provided to the `-[ONGUserClient fetchResource:completion:]` and `-[ONGDeviceClient fetchResource:completion:]`.
 */
@property (readonly) ONGResourceRequest *request;

/**
 * The response value fulfilled upon completion. It may be nil if the network task hasn't received any response from the server yet.
 *
 * @see ONGResourceResponse
 */
@property (readonly, nullable) ONGResourceResponse *response;

/**
 * The Error value fulfilled upon completion. It may be nil in case of a successful response.
 *
 * This error will be either within the NSURLErrorDomain or ONGGenericErrorDomain.
 */
@property (readonly, nullable) NSError *error;

/**
 * You should not try to instantiate a task on your own. The only valid way to get a valid task instance is by
 * calling `-[ONGUserClient fetchResource:completion:]` or `-[ONGDeviceClient fetchResource:completion:]`.
 */
- (instancetype)init ONG_UNAVAILABLE;
+ (instancetype)new ONG_UNAVAILABLE;

/**
 * Resume a suspended task. This moves a task from the `ONGNetworkTaskStateSuspended` state to the `ONGNetworkTaskStateRunning` state.
 * If a task is already completed (`ONGNetworkTaskStateCompleted`) or cancelled (`ONGNetworkTaskStateCancelled`) - this won't have any effect.
 *
 * By default you don't have to call `resume` - the  SDK starts a task automatically.
 *
 * Any attempt to resume an already running task doesn't have any effect.
 */
- (void)resume;

/**
 * Suspend running task. This moves a task from the `ONGNetworkTaskStateRunning` state to the `ONGNetworkTaskStateSuspended` state.
 *
 * Any attempt to suspend an already suspended, cancelled (`ONGNetworkTaskStateCancelled`) or completed (`ONGNetworkTaskStateCompleted`) task doesn't have
 * any effect.
 */
- (void)suspend;

/**
 * Cancel a running or suspended task. This moves the task to the `ONGNetworkTaskStateCancelled` state.
 *
 * Any attempt to cancel an already cancelled or completed (`ONGNetworkTaskStateCompleted`) task doesn't have any effect.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END