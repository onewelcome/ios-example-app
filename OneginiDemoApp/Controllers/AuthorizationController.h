//
//  AuthCoordinator.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface AuthorizationController : NSObject <OGAuthorizationDelegate, OGPinValidationDelegate>

+ (AuthorizationController *)sharedInstance;

@property (nonatomic, readonly) BOOL isRegistered;

- (void)login;

@end
