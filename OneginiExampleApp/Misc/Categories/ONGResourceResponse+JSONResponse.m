// Copyright (c) 2016 Onegini. All rights reserved.

#import "ONGResourceResponse+JSONResponse.h"

@implementation ONGResourceResponse (JSONResponse)

- (id)JSONResponse
{
    if (self.data != nil) {
        return [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:nil];
    }

    return nil;
}

@end