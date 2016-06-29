//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OGPinValidationDelegate.h"

@protocol OGNewPinConfirmation<NSObject>

- (bool)confirmNewPin:(NSString *)aPin validation:(id<OGPinValidationDelegate>)delegate;

@end
