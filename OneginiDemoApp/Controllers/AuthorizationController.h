//
//  AuthCoordinator.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface AuthorizationController : NSObject<OGAuthenticationDelegate, OGPinValidationDelegate>

+ (AuthorizationController *)sharedInstance;

@property (nonatomic, readonly) BOOL isAuthenticated;
@property (nonatomic, readonly) OGUserProfile *authenticatedUserProfile;

- (void)authenticateUser:(OGUserProfile *)user;

- (void)registerNewUser;

@end
