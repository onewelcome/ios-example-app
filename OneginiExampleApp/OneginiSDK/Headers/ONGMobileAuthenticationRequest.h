// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

NS_ASSUME_NONNULL_BEGIN

@interface ONGMobileAuthenticationRequest : NSObject

/**
* The mobile authentication type which is configured in the Token Server admin panel.
* The type can be used to distinguish between business functionalities. For example, mobile authentication can be used for logging in or transaction approval.
* The type can then be used to distinguish on the mobile device which functionality is triggered.
*/
@property (nonatomic, copy, readonly) NSString *type;

/**
 * User profile for which mobile authenticate request was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Original user info recevied from the -[UIApplicationDelegate application:didReceiveRemoteNotification:]
 *
 * @see -[ONGUserClient handleMobileAuthenticationRequest:delegate:]
 */
@property (nonatomic, copy, readonly) NSDictionary *userInfo;

/**
 * Title of the request. Corresponding to the [userInfo valueForKeyPath:@"alert.body"]
 */
@property (nonatomic, readonly, nullable) NSString *title;

/**
 * Body of the request. Corresponding to the [userInfo valueForKeyPath:@"alert.title"]
 */
@property (nonatomic, readonly, nullable) NSString *body;

@end

NS_ASSUME_NONNULL_END