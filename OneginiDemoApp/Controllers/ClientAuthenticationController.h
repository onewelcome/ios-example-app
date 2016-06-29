//
//  OGClientAuthenticationController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 19/06/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface ClientAuthenticationController : NSObject<OGClientAuthenticationDelegate>

+ (ClientAuthenticationController *)sharedInstance;

- (void)authenticateClient;

@end
