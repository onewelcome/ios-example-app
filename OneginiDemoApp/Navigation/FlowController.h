//
//  FlowController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 07/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FlowController : NSObject

@property (nonatomic) UINavigationController *navigationCOntroller;

+ (FlowController *)sharedInstance;

- (void)askForCurrentPinCompletion:(void (^)(NSString* pin))completion;
- (void)wrongPinEnteredRemaining:(NSInteger)remaining;

- (void)createPinWithSize:(NSInteger)size completion:(void (^)(NSString* pin))completion;
- (void)pinPolicyValidationFailed;

- (void)authorizationSucceded;
- (void)authenticationFailedWithError;

- (void)openURL:(NSURL*)url;

- (void)logout;
- (void)disconnect;

@end
