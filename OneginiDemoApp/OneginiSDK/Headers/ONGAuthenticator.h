// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ONGAuthenticatorType) {
    ONGAuthenticatorPIN = 1,
    ONGAuthenticatorTouchID = 2,
    ONGAuthenticatorFIDO = 3
};

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents an authenticator. Authenticator objects can be obtains using `ONGUserClient` `registeredAuthenticators` or
 * `fetchNonRegisteredAuthenticators`.
 */
@interface ONGAuthenticator : NSObject <NSSecureCoding>

/**
 * Unique authenticator identifier.
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 * Human-readable authenticator name.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * Authenticator type.
 */
@property (nonatomic, readonly) ONGAuthenticatorType type;

@end

NS_ASSUME_NONNULL_END