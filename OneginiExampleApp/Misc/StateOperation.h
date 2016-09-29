// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

// Simple successor of NSOperation that handles state-related KVO notications as well as providing handy methods and
// operation's lifetime notifications such as `executionStarted`. 
@interface StateOperation : NSOperation

- (void)finish;

@end

@interface StateOperation (Subclassing)

// For simplicity of example app we do not implement other lifecycle events such as cancellation, finishing, etc.
- (void)executionStarted;
- (void)executionFinished;

@end
