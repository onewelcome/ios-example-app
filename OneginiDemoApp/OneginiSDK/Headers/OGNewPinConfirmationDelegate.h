//
//  OGNewPinConfirmationDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 15/03/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGPinValidationDelegate.h"

@protocol OGNewPinConfirmationDelegate <NSObject>

- (bool)confirmNewPin:(NSString *)aPin validation:(id<OGPinValidationDelegate>)delegate;

@end
