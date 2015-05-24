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
#define kOGAppSecret						@"kOGAppSecret"
#define kOGAppVersion						@"kOGAppVersion"
#define kOGBaseURL							@"kAppBaseURL"
#define kOGMaxPinFailures					@"kOGMaxPinFailures"
#define kOGResourceBaseURL					@"kOGResourceBaseURL"
#define kOGShouldConfirmNewPin				@"kOGShouldConfirmNewPin"
#define kOGShouldDirectlyShowPushMessage	@"kOGShouldDirectlyShowPushMessage"
#define kOGKeyStorePassword					@"kOGKeyStorePassword"
#define kOGCertificatePinningKeyStore		@"kOGCertificatePinningKeyStore"
#define kOGCertificatePinningStorePassword	@"kOGCertificatePinningStorePassword"
#define kOGRedirectURL						@"kOGRedirectURL"
#define kOGDeviceName						@"kOGDeviceName"
#define kOGUseEmbeddedWebview				@"kOGUseEmbeddedWebview"
#define kOGStoreCookies                     @"kOGStoreCookies"

@class OGCommons;

/**
 This dictionary class provides a means of supplying App specific configuration properties
 used by the OneginiClient.

 @warning For security reasons the 'kOGAppSecret' value should not be stored in the .plist configuration file.
 The secret should either be provided by subclassing or by suppling the 'kOGAppSecret' key in the configuration dictionary.
 
 ## Subclass notes
 Override the 'appSecret' accessor.
 
 */
@interface OGConfigModel : NSObject {
	NSDictionary *dictionary;
}

@property (readonly, nonatomic) NSDictionary *dictionary;

/**
 Create a new instance and populate it with the contents of a .plist configuration file
 
 @param A full or relative pathname. The file identified by path must contain a string representation of a property list whose root object is a dictionary.
 */
- (id)initWithContentsOfFile:(NSString *)path;

/**
 Create a new instance using the provided dictionary.
 
 @param config dictionary
 */
- (id)initWithDictionary:(NSDictionary *)config;

/**
 Application identifier used in dynamic client registration.
 
 @return the current app identifier
 */
- (NSString *)appIdentifier;

/**
 Application platform used in dynamic client registration.
 
 @return the current app platform
 */
- (NSString *)appPlatform;

/**
 Application scheme used in the callback from the authentication process to the client
 
 @return the application scheme used in the callback
 */
- (NSString *)appScheme;

/**
 Application secret used in dynamic client registration.
 
 If the 'kOGAppSecret' is omitted from the dictionary, a default MD5 hash is generated from
 the concatenated values of the dictionary.
 
 @return the current app secret
 */
- (NSString *)appSecret;

/**
 Application version used in dynamic client registration.
 
 @return the current app version
 */
- (NSString *)appVersion;

/**
 Base url of the Oauth Server installation.
 
 @return the current base URL
 */
- (NSString *)baseURL;

/**
 The number of authentication attempts allowed before removing the stored refresh token
 
 @return the maximum number of pin failures allowed
 */
- (NSNumber *)maxPinFailures;

/**
 Base url of the resource server
 
 @return the base URL for the resource server
 */
- (NSString *)resourceBaseURL;

/**
 Confirm a new pin
 
 @return true if you should confirm the pin created by the user, false otherwise
 */
- (BOOL)shouldConfirmNewPin DEPRECATED_ATTRIBUTE;

/**
 Always show the push message right away, or just show a small notification
 
 @return true if the push message should be shown right away, false otherwise
 */
- (BOOL)shouldDirectlyShowPushMessage;

/**
 @return redirect URL
 */
- (NSString *)redirectURL;

/**
 The device name is used in the dynamic client registration and identifies the device in the oAuth portal
 
 @return device name
 */
- (NSString *)deviceName;

/**
 If the App wants to use an embedded UIWebView instead of the external Safari browser then this parameter must be set to true.
 
 @return true if client uses an embedded UIWebView
 */
- (BOOL)useEmbeddedWebView;

/**
 If the App wants to store cookies between requests then this parameter must be set to true.

@return true if the app requires storing cookies between requests
*/
- (BOOL)storeCookies;

/**
 Returns the value associated with a given key.
 
 @param key
 @return object
 */
- (id)objectForKey:(NSString *)key;

@end
