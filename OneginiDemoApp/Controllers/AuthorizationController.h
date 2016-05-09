//
//  AuthCoordinator.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizationController : NSObject

+ (AuthorizationController *)sharedInstance;

@property (nonatomic, readonly) BOOL isRegistered;

- (void)login;

@end

NS_ASSUME_NONNULL_END
