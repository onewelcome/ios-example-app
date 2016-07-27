//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

ONG_EXTERN NSString *const ONGAppIdentifier;
ONG_EXTERN NSString *const ONGAppPlatform;
ONG_EXTERN NSString *const ONGAppVersion;
ONG_EXTERN NSString *const ONGAppBaseURL;
ONG_EXTERN NSString *const ONGResourceBaseURL;
ONG_EXTERN NSString *const ONGRedirectURL;

@class ONGCommons;

/**
 *  This dictionary class provides a means of supplying App specific configuration properties used by the OneginiClient.
 */
@interface ONGConfigModel : NSObject

@property (readonly, nonatomic, copy) NSDictionary<NSString *, NSString *> *dictionary;

/**
 *  Creates a new instance and populate it with the contents of a .plist configuration file.
 *
 *  @param path A full or relative pathname. The file identified by path must contain a string representation of a property list whose root object is a dictionary.
 */
- (id)initWithContentsOfFile:(NSString *)path;

/**
 *  Creates a new instance using the provided dictionary.
 *
 *  @param config dictionary
 */
- (id)initWithDictionary:(NSDictionary *)config;

/**
 *  Application identifier used in dynamic client registration.
 */
@property (nonatomic, readonly) NSString *appIdentifier;

/**
 *  Application platform used in dynamic client registration.
 */
@property (nonatomic, readonly) NSString *appPlatform;

/**
 *  Application version used in dynamic client registration.
 */
@property (nonatomic, readonly) NSString *appVersion;

/**
 *  Base url of the OAuth Server installation.
 */
@property (nonatomic, readonly) NSString *baseURL;

/**
 *  Base url of the resource server.
 */
@property (nonatomic, readonly) NSString *resourceBaseURL;

/**
 *  Redirect url used to complete registration process.
 */
@property (nonatomic, readonly) NSString *redirectURL;

/**
 *  Returns the value associated with a given key.
 *
 *  @param key key
 *  @return object
 */
- (id)objectForKey:(NSString *)key;

@end
