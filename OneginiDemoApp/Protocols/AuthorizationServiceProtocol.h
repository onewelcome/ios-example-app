//
//  AuthorizationServiceProtocol.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 4/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AuthorizationService;

@protocol AuthorizationServiceDelegate <NSObject>

- (void)authorizationService:(id<AuthorizationService>)service didStartLoginWithURL:(NSURL *)url;
- (void)authorizationService:(id<AuthorizationService>)service didFailLoginWithError:(NSError *)error;
- (void)authorizationService:(id<AuthorizationService>)service didRequestPINEnrollemntWithCountNumbers:(NSInteger)count;
- (void)authorizationServiceDidFinishLogin:(id<AuthorizationService>)service;

- (void)authorizationServiceDidAskForCurrentPIN:(id<AuthorizationService>)service;

@end

@protocol AuthorizationService <NSObject>

@property (nonatomic, weak) id<AuthorizationServiceDelegate> delegate;

- (void)login;
- (void)enterCurrentPIN:(NSString *)pin;

@end

NS_ASSUME_NONNULL_END