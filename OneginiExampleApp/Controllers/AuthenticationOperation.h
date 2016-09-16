//
//  AuthenticationOperation.h
//  OneginiExampleApp
//
//  Created by Aleksey on 16.09.16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MobileAuthenticationController;

@interface AuthenticationOperation: NSOperation

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
                                notification:(NSDictionary *)userInfo;

@end
