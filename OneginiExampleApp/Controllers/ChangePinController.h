//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface ChangePinController : NSObject<ONGChangePinDelegate>

@property (nonatomic, copy) void (^progressStateDidChange)(BOOL);

+ (instancetype)changePinControllerWithNavigationController:(UINavigationController *)navigationController
                                                 completion:(void (^)())completion;

@end
