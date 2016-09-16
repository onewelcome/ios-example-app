//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface MobileAuthenticationController : NSObject<ONGMobileAuthenticationRequestDelegate>

@property (nonatomic) void (^didDismiss)(void);

+ (instancetype)mobileAuthenticationControllerWithNaviationController:(UINavigationController *)navigationController
                                                           completion:(void (^)())completion;

@end
