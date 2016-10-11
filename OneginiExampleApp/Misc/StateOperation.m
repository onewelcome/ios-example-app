// Copyright (c) 2016 Onegini. All rights reserved.

#import "StateOperation.h"

typedef NS_ENUM(NSInteger, OperationState) {
    OperationStateReady,
    OperationStateExecuting,
    OperationStateFinished
};

NSString * OperationStateToKeyPath(OperationState state)
{
    switch (state) {
        case OperationStateReady: return @"isReady";
        case OperationStateExecuting: return @"isExecuting";
        case OperationStateFinished: return @"isFinished";

        default:
            return nil;
    }
};

// For example app simplicity we're skipping cancellation handling
BOOL OperationStateTransitionValid(OperationState from, OperationState to)
{
    // we're ignoring ability to be cancelled in this example
    switch (from) {
        case OperationStateReady:
            return to == OperationStateExecuting;

        case OperationStateExecuting:
            return to == OperationStateFinished;

        default:
            return NO;
    }
}

@interface StateOperation ()

@property (nonatomic) OperationState state;
@property (nonatomic) NSRecursiveLock *stateLock;

@end

@implementation StateOperation

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _state = OperationStateReady;

        self.stateLock = [NSRecursiveLock new];
    }

    return self;
}

#pragma mark - NSOperation flags

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isReady
{
    return self.state == OperationStateReady && [super isReady];
}

- (BOOL)isExecuting
{
    return self.state == OperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.state == OperationStateFinished;
}

- (void)start
{
    self.state = OperationStateExecuting;

    // allow subclasses to inject their code
    [self executionStarted];
}

- (void)finish
{
    BOOL finished = NO;
    
    [self.stateLock lock];
    
    if (self.state != OperationStateFinished) {
        self.state = OperationStateFinished;
        finished = YES;
    }
    
    [self.stateLock unlock];
    
    if (finished) {
        [self executionFinished];
    }
}

#pragma mark - State Handling

- (void)setState:(OperationState)state
{
    [self.stateLock lock];

    if (OperationStateTransitionValid(_state, state)) {
        NSString *fromStateKeyPath = OperationStateToKeyPath(_state);
        NSString *toStateKeyPath = OperationStateToKeyPath(state);

        [self willChangeValueForKey:fromStateKeyPath];
        [self willChangeValueForKey:toStateKeyPath];

        _state = state;

        [self didChangeValueForKey:fromStateKeyPath];
        [self didChangeValueForKey:toStateKeyPath];
    }

    [self.stateLock unlock];
}

@end

@implementation StateOperation (Subclassing)

- (void)executionStarted
{
    // no-op
}

- (void)executionFinished
{
    // no-op
}

@end
