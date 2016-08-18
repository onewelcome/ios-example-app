//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@class Profile;

@interface ResourceController : NSObject

+ (instancetype)sharedInstance;

- (void)getToken:(void (^)(BOOL received, NSError *error))completion;

@end
