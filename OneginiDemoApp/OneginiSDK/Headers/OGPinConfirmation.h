//
//  OGPinConfirmation.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 08/03/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGPinConfirmation <NSObject>

- (void)confirmPin:(NSString *)pin;

@end
