//
//  AuthCoordinator.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AuthCoordinator;
@class OGOneginiClient;

@interface AuthCoordinator : NSObject

+ (AuthCoordinator *)sharedInstance;

@property (nonatomic, readonly) BOOL isRegistered;

- (void)registerUser;
- (void)setNewPin:(NSString *)pin;
- (BOOL)isRegistered;

- (void)login;
- (void)enterCurrentPIN:(NSString *)pin;

- (void)logout;
- (void)disconnect;

@end

NS_ASSUME_NONNULL_END
