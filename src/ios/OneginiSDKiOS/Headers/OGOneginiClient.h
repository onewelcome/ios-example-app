//
//  OGOneginiClient.h
//  OneginiSDKiOS
//
//  Created by Eduard on 28-07-14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGResourceHandlerDelegate.h"
#import "OGAuthorizationDelegate.h"
#import "OGEnrollmentHandlerDelegate.h"
#import "OGPublicCommons.h"

@class OGConfigModel, OGAuthorizationManager, OGResourceManager, OGEnrollmentManager;

/**
 This is the main entry point into the SDK.
 The public API of the SDK consists of this client and an authorization delegate.
 The client must be instantiated early in the App lifecycle and thereafter only referred to by it's shared instance.
 */
@interface OGOneginiClient : NSObject

@property (weak, nonatomic) id<OGAuthorizationDelegate> authorizationDelegate;

/**
 For verification of the bundled DER encoded CA X509 certificates, 
 the App must provide a list of matching PEM base64 encoded certificates for each bundled DER encoded CA X509 certificate to this client.
 The PEM base64 encoded certificates must be stripped from their armor (remove ---BEGIN CERTIFICATE--- & ---END CERTIFICATE---)
 
 This method must be called before any service request is made, preferably after initialization.
 If certificate verification fails prior to making a service request, an Exception is thrown.

 To convert a DER encoded certificate to PEM, use the following openssl command:
 openssl x509 -in <filename>.cer -inform der -out <filename>.pem -outform pem
 Do not include the PEM files themselved in App bundle!
 
 @param certificates array of PEM base64 encoded certificates without armor
 */
- (void)setX509PEMCertificates:(NSArray *)certificates;

/**
 Access the shared instance. 
 If the instance is nil it must be initialized with a valid config model.
 
 @see 'initWithConfig'
 @return shared instance
 */
+ (OGOneginiClient *)sharedInstance;

/**
 Initialize this 'OGOneginiClient' with a valid config model and delegate.
 This is the preferred way of creating a new instance of this class.
 
 @param config
 @param delegate
 */
- (id)initWithConfig:(OGConfigModel *)config delegate:(id<OGAuthorizationDelegate>)delegate;

/**
 Main entry point into the authorization process.
 
 @param scopes
 @param delegate
 */
- (void)authorize:(NSArray *)scopes;

/**
Change the user's current PIN
The user will be requested to enter the current, a new and a verification PIN
The PIN must satisfy the client's PIN policy.

@param scopes
@param delegate
*/
- (void)authorizeAndChangePin:(NSArray *)scopes;

/**
 Determine if the device is linked to a user
 
 @return true, if the device is linked to a user
 */
- (BOOL)isRegistered DEPRECATED_ATTRIBUTE;

/**
 Determine if the client is registered.
 
 @return true, if a refresh token is available
 */
- (BOOL)isClientRegistered;

/**
 Determine if the user is authorized
 
 @return true, if a valid access token is available
 */
- (BOOL)isAuthorized;

/**
 Handle the response of the authorization request from the browser redirect.
 The URL scheme and host must match the config model redirect URL.
 
 @param callback url
 @return true, if the URL is handled by the client
 */
- (BOOL)handleAuthorizationCallback:(NSURL *)url;

/**
 Disconnect from the service, this will clear the refresh token and access token.
 Client credentials remain untouched.
 */
- (void)disconnect;

/**
 This will end the current session and invalidate the access token.
 The refresh token and client credentials remain untouched.
 
 @param result callback, true if logout is successful
 */
- (void)logout:(void (^)(BOOL))result;

/**
 Clear the client credentials. 
 A new dynamic client registration has to be performed on the next authorization request.
 */
- (void)clearCredentials;

/**
 Clear all tokens and reset the pin attempt count.
 
 @param error not nil when deleting the refresh token from the keychain fails.
 @return true, if the token deletion is successful.
 */
- (BOOL)clearTokens:(NSError **)error;

/**
 Fetches a specific resource.
 The access token validation flow is invoked if no valid access token is available.
 Params are encoded using JSON notation
 
 @param path relative path to the resource end point
 @param scopes
 @param params additional request parameters
 @param delegate
 @return transactionId
 */
- (NSString *)fetchResource:(NSString *)path
					 scopes:(NSArray *)scopes
			  requestMethod:(HTTPRequestMethod)requestMethod
					 params:(NSDictionary *)params
				   delegate:(id <OGResourceHandlerDelegate>)delegate;


/**
 Fetches a specific resource.
 The access token validation flow is invoked if no valid access token is available.
 
 @param path relative path to the resource end point
 @param scopes
 @param params additional request parameters
 @param paramsEncoding
 @param delegate
 @return transactionId
 */
- (NSString *)fetchResource:(NSString *)path
					 scopes:(NSArray *)scopes
			  requestMethod:(HTTPRequestMethod)requestMethod
					 params:(NSDictionary *)params
			 paramsEncoding:(HTTPClientParameterEncoding)paramsEncoding
				   delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 Fetches a specific resource anonymously using a client access token.
 The access token validation flow is invoked if no valid access token is available.
 
 @param path relative path to the resource end point
 @param scopes
 @param params additional request parameters
 @param delegate
 @return transactionId
 */
- (NSString *)fetchAnonymousResource:(NSString *)path
							  scopes:(NSArray *)scopes
					   requestMethod:(HTTPRequestMethod)requestMethod
							  params:(NSDictionary *)params
							delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 Fetches a specific resource anonymously using a client access token.
 The access token validation flow is invoked if no valid access token is available.
 
 @param path relative path to the resource end point
 @param scopes
 @param params additional request parameters
 @param paramsEncoding
 @param delegate
 @return transactionId
 */
- (NSString *)fetchAnonymousResource:(NSString *)path
							  scopes:(NSArray *)scopes
					   requestMethod:(HTTPRequestMethod)requestMethod
							  params:(NSDictionary *)params
					  paramsEncoding:(HTTPClientParameterEncoding)paramsEncoding
							delegate:(id <OGResourceHandlerDelegate>)delegate;


/**
 Stores the device token for the current session.
 
 This should be invoked from the UIApplicationDelegate
 - (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
 
 @param deviceToken
 */
- (void)storeDevicePushTokenInSession:(NSData *)deviceToken;

/**
 Enrolls the currently connected device for mobile push authentication.

 The device push token must be stored in the session before invoking this method.
 @see storeDevicePushTokenInSession:
 
 @param scopes
 @param delegate
 */
- (void)enrollForMobileAuthentication:(NSArray *)scopes delegate:(id <OGEnrollmentHandlerDelegate>)delegate;

/**
 When a push notification is received by the application, the notificaton must be forwarded to the client.
 The client will then fetch the actual encrypted payload and invoke the delegate with the embedded message.
 
 This should be invoked from the UIApplicationDelegate
 - (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
 
 @see UIApplication
 
 @param userInfo
 @return true, if the notification is processed by the client
 */
- (BOOL)handlePushNotification:(NSDictionary *)userInfo;

@end