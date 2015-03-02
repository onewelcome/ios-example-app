//
//  OGChangePinDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 20-02-15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This protocol informs the client about the result of the PIN change request.
 Clients must also implement the OGPinValidationDelegate protocol.
 */
@protocol OGChangePinDelegate <NSObject>

@required

- (void)pinChanged;
- (void)invalidCurrentPin;
- (void)pinChangeError;
- (void)pinChangeError:(NSError *)error;

@end