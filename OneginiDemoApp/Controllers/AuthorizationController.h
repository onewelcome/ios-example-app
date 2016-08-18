//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface AuthorizationController : NSObject<ONGAuthenticationDelegate>

+ (AuthorizationController *)sharedInstance;

@property (nonatomic, readonly) BOOL isAuthenticated;
@property (nonatomic, readonly) ONGUserProfile *authenticatedUserProfile;

- (void)authenticateUser:(ONGUserProfile *)user;

@end
