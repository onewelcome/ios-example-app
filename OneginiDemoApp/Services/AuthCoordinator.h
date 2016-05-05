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

@protocol AuthCoordinatorDelegate <NSObject>

- (void)authCoordinator:(AuthCoordinator *)coordinator didStartLoginWithURL:(NSURL *)url;
- (void)authCoordinatorDidFinishLogin:(AuthCoordinator *)coordinator;
- (void)authCoordinator:(AuthCoordinator *)coordinator didFailLoginWithError:(NSError *)error;

- (void)authCoordinator:(AuthCoordinator *)coordinator presentCreatePINWithMaxCountOfNumbers:(NSInteger)countNumbers;
- (void)authCoordinatorDidFinishPINEnrollment:(AuthCoordinator *)coordinator;
- (void)authCoordinator:(AuthCoordinator *)coordinator didFailPINEnrollmentWithError:(NSError *)error;

@end

@interface AuthCoordinator : NSObject

@property (nonatomic, weak, nullable) id<AuthCoordinatorDelegate> delegate;

- (void)login;
- (void)setNewPin:(NSString *)pin;

@end

NS_ASSUME_NONNULL_END
