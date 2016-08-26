//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface MobileAuthenticationController : NSObject<ONGMobileAuthenticationRequestDelegate>

+ (instancetype)mobileAuthentiactionControllerWithNaviationController:(UINavigationController *)navigationController
                                                           completion:(void (^)())completion;

@end
