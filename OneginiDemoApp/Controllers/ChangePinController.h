//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface ChangePinController : NSObject<ONGChangePinDelegate>

+(instancetype)changePinControllerWithNavigationController:(UINavigationController *)navigationController;

@end
