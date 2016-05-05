//
//  OGConfigModel.h
//  OneginiSDKiOS
//
//  Created by Eduard on 24-07-14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOGAppIdentifier					@"kOGAppIdentifier"
#define kOGAppPlatform						@"kOGAppPlatform"
#define kOGAppScheme						@"kOGAppScheme"
#define kOGAppVersion						@"kOGAppVersion"
#define kOGAppBaseURL						@"kOGAppBaseURL"
#define kOGMaxPinFailures					@"kOGMaxPinFailures"
#define kOGResourceBaseURL					@"kOGResourceBaseURL"
#define kOGRedirectURL						@"kOGRedirectURL"
#define kOGUseEmbeddedWebview				@"kOGUseEmbeddedWebview"
#define kOGStoreCookies                     @"kOGStoreCookies"

@class OGCommons;

/**
 *  This dictionary class provides a means of supplying App specific configuration properties used by the OneginiClient.
 */
@interface OGConfigModel : NSObject {
	NSDictionary *dictionary;
}

@property (readonly, nonatomic) NSDictionary *dictionary;

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
 *
 *  @return the current app identifier
 */
- (NSString *)appIdentifier;

/**
 *  Application platform used in dynamic client registration.
 *
 *  @return the current app platform
 */
- (NSString *)appPlatform;

/**
 *  Application scheme used in the callback from the authentication process to the client.
 *
 *  @return the application scheme used in the callback
 */
- (NSString *)appScheme;

/**
 *  Application secret used in dynamic client registration.
 *
 *  @return the current app secret
 */
- (NSString *)appSecret;

/**
 *  Application version used in dynamic client registration.
 *
 *  @return the current app version
 */
- (NSString *)appVersion;

/**
 *  Base url of the Oauth Server installation.
 *
 *  @return the current base URL
 */
- (NSString *)baseURL;

/**
 *  The number of authentication attempts allowed before removing the stored refresh token.
 *
 *  @return the maximum number of pin failures allowed
 */
- (NSNumber *)maxPinFailures;

/**
 *  Base url of the resource server.
 *
 *  @return the base URL for the resource server
 */
- (NSString *)resourceBaseURL;

/**
 *  @return redirect URL
 */
- (NSString *)redirectURL;

/**
 *  If the App wants to use an embedded UIWebView instead of the external Safari browser then this parameter must be set to true.
 *
 *  @return true if client uses an embedded UIWebView
 */
- (BOOL)useEmbeddedWebView;

/**
 *  If the App wants to store cookies between requests then this parameter must be set to true.
 *
 *  @return true if the app requires storing cookies between requests
 */
- (BOOL)storeCookies;

/**
 *  Returns the value associated with a given key.
 *
 *  @param key key
 *  @return object
 */
- (id)objectForKey:(NSString *)key;

@end