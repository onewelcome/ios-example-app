//
//  OneginiService.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OneginiClientInitable <NSObject>

- (instancetype)initWithClient:(OGOneginiClient *)client;

@property (nonatomic, strong, readonly) OGOneginiClient *client;

@end

@interface OneginiService : NSObject <OneginiClientInitable>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END