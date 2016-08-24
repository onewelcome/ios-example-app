//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface AuthenticationController : NSObject<ONGAuthenticationDelegate>

+ (instancetype)authenticationControllerWithNavigationController:(UINavigationController *)navigationController;

@end
