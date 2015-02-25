//
//  OGChangePinDelegate.h
//  OneginiSDKiOS
//
//  Created by Eduard on 20-02-15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGChangePinDelegate <NSObject>

@required

- (void)pinChanged;
- (void)invalidCurrentPin;
- (void)pinChangeError;
- (void)pinChangeError:(NSError *)error;

@end
