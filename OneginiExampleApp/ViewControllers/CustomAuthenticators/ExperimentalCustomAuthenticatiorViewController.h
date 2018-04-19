//  Copyright © 2018 Onegini. All rights reserved.

#import <UIKit/UIKit.h>
#import "OneginiSDK.h"

@interface ExperimentalCustomAuthenticatiorViewController : UIViewController

@property (nonatomic, copy) void (^customAuthAction)(NSString *data, BOOL cancelled);
@property (nonatomic) NSString *viewTitle;

@end
