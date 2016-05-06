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

@protocol AuthCoordinatorDelegate <NSObject>

- (void)authCoordinator:(AuthCoordinator *)coordinator didStartLoginWithURL:(NSURL *)url;
- (void)authCoordinatorDidFinishLogin:(AuthCoordinator *)coordinator;
- (void)authCoordinator:(AuthCoordinator *)coordinator didFailLoginWithError:(NSError *)error;
- (void)authCoordinatorDidEnterWrongPIN:(AuthCoordinator *)coordinator remainingAttempts:(NSUInteger)remaining;
- (void)authCoordinatorDidAskForCurrentPIN:(AuthCoordinator *)coordinator;

- (void)authCoordinator:(AuthCoordinator *)coordinator presentCreatePINWithMaxCountOfNumbers:(NSInteger)countNumbers;
- (void)authCoordinator:(AuthCoordinator *)coordinator didFailPINEnrollmentWithError:(NSError *)error;

@end

@protocol AuthCoordinatorLogoutDelegate <NSObject>

@optional

- (void)authCoordinatorDidFinishLogout:(AuthCoordinator *)coordinator;
- (void)authCoordinator:(AuthCoordinator *)coordinator didFailLogoutWithError:(NSError *)error;

@end

@interface AuthCoordinator : NSObject

- (instancetype)initWithOneginiClient:(OGOneginiClient *)client;

@property (nonatomic, weak, nullable) id<AuthCoordinatorDelegate> delegate;
@property (nonatomic, weak, nullable) id<AuthCoordinatorLogoutDelegate> logoutDelegate;
@property (nonatomic, readonly) BOOL isRegistered;

- (void)registerUser;
- (void)setNewPin:(NSString *)pin;

- (void)login;
- (void)enterCurrentPIN:(NSString *)pin;

- (void)logout;

@end

NS_ASSUME_NONNULL_END
