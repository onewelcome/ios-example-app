//
//  OGPinConfirmationDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 08/03/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGPinConfirmationDelegate <NSObject>

- (void)confirmPin:(NSString *)pin;

@end
