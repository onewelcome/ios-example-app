//
//  APIClient.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Profile;

typedef void(^ProfileCompletionBlock)(Profile *profile, NSError *error);

@interface ResourceController : NSObject

- (void)getProfile:(ProfileCompletionBlock)completion;

@end
