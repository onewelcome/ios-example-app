//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface RegistrationController : NSObject <ONGRegistrationDelegate, ONGPinValidationDelegate>

+(instancetype)registrationControllerWithNavigationController:(UINavigationController *)navigationController;

@end
