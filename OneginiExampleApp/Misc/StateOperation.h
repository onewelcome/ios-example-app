// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface StateOperation : NSOperation

- (void)finish;

@end

@interface StateOperation (Subclassing)

// For simplicity of example app we do not implement other lifecycle events such as cancellation, finishing, etc.
- (void)executionStarted;

@end