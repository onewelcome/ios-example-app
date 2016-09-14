// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

#import "ONGResourceResponse.h"

@interface ONGResourceResponse (JSONResponse)

/// Return JSON decoded response (if any). This property is not stored and therefore not recommended to call in cycles.
- (id)JSONResponse;

@end