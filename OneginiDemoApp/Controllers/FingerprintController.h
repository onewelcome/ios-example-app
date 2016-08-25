//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface FingerprintController : NSObject<ONGAuthenticationDelegate>

+ (instancetype)fingerprintControllerWithNavigationController:(UINavigationController *)navigationController
                                                   completion:(void(^)())completion;

@end
