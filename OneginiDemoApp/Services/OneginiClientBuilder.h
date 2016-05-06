//
//  OneginiClientBuilder.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 4/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGOneginiClient;

@interface OneginiClientBuilder : NSObject

+ (OGOneginiClient *)buildClient;

@end
