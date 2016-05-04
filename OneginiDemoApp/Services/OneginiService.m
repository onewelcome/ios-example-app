//
//  OneginiService.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "OneginiService.h"

@interface OneginiService ()

@property (nonatomic, strong) OGOneginiClient *client;

@end

@implementation OneginiService

- (instancetype)initWithClient:(OGOneginiClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

@end
