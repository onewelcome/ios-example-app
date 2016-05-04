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
#import "OGPinValidationDelegate.h"
#import "OGChangePinDelegate.h"
#import "OGPublicCommons.h"
#import "OGDisconnectDelegate.h"
#import "OGFingerprintDelegate.h"
#import "OGLogoutDelegate.h"
#import "OGCustomizationDelegate.h"

@class OGConfigModel, OGAuthorizationManager, OGResourceManager, OGEnrollmentManager;

/**
 *  This is the main entry point into the SDK.
 *  The public API of the SDK consists of this client and an authorization delegate.
 *  The client must be instantiated early in the App lifecycle and thereafter only referred to by it's shared instance.
 */
@interface OGOneginiClient : NSObject

@property (weak, nonatomic) id<OGAuthorizationDelegate> authorizationDelegate;
@property (weak, nonatomic) id<OGPinValidationDelegate> pinValidationDelegate;
/**
 *  Registers delegate handling customizable properties within the SDK.
 */
@property (weak, nonatomic) id<OGCustomizationDelegate> customizationDelegate;

/**
 *  For verification of the bundled DER encoded CA X509 certificates,
 *  the App must provide a list of matching PEM base64 encoded certificates for each bundled DER encoded CA X509 certificate to this client.
 *  The PEM base64 encoded certificates must be stripped from their armor (remove ---BEGIN CERTIFICATE--- & ---END CERTIFICATE---)
 *
 *  This method must be called before any service request is made, preferably after initialization.
 *  If certificate verification fails prior to making a service request, an Exception is thrown.
 *
 *  To convert a DER encoded certificate to PEM, use the following openssl command:
 *  openssl x509 -in <filename>.cer -inform der -out <filename>.pem -outform pem
 *  Do not include the PEM files themselved in App bundle!
 *
 *  @param certificates array of PEM base64 encoded certificates without armor
 */
- (void)setX509PEMCertificates:(NSArray *)certificates;

/**
 *  Accesses the shared instance.
 *  If the instance is nil it must be initialized with a valid config model.
 *
 *  @see - (id)initWithConfig:(OGConfigModel *)config delegate:(id<OGAuthorizationDelegate>)delegate;
 *  @return shared instance
 */
+ (OGOneginiClient *)sharedInstance;

/**
 *  Initializes this 'OGOneginiClient' with a valid config model and delegate.
 *  This is the preferred way of creating a new instance of this class.
 *
 *  @param config   Configuration object used for initialization.
 *  @param delegate Object conforming to OGAuthorizationDelegate protocol. Delegate is not retained by OGOneginiClient.
 *
 *  @return Initialized OGOneginiClient instance
 */
- (id)initWithConfig:(OGConfigModel *)config delegate:(id<OGAuthorizationDelegate>)delegate;

/**
 *  Initializes 'OGOneginiClient' with a delegate. This initializer uses configuration and certificates through "Onegini SDK Configurator". Since certificate pinning is done within this initialization, call to setX509PEMCertificates is not necceassary.
 *
 *  @param delegate Object conforming to OGAuthorizationDelegate protocol. Delegate is not retained by OGOneginiClient.
 *
 *  @return Initialized OGOneginiClient instance
 */
- (id)initWithDelegate:(id<OGAuthorizationDelegate>)delegate;

/**
 *  Main entry point into the authorization process.
 *
 *  @param scopes NSString* array of scopes used for authorization
 */
- (void)authorize:(NSArray *)scopes;

/**
 *  Forces user's reauthorization.
 *
 *  @param scopes NSString* array of scopes used for reauthorization
 */
- (void)reauthorize:(NSArray *)scopes;

/**
 *  Initiates the PIN change sequence.
 *  If no refresh token is registered then the sequence is cancelled.
 *  This will invoke a call to the OGAuthorizationDelegate - (void)askForPinChange:(NSUInteger)pinSize;
 *
 *  @param delegate Object handling change pin callbacks
 */
- (void)changePinRequest:(id <OGChangePinDelegate>)delegate;

/**
 *  Determines if the client is registered.
 *
 *  @return true, if a refresh token is available
 */
- (BOOL)isClientRegistered;

/**
 *  Determines if the user is authorized.
 *
 *  @return true, if a valid access token is available
 */
- (BOOL)isAuthorized;

/**
 *  Checks if the pin satisfies all pin policy constraints.
 *
 *  @param pin pincode to validate against pin policy constraints
 *  @param error pin policy validation error
 *  @return true if all pin policy constraints are satisfied
 */
- (BOOL)isPinValid:(NSString *)pin error:(NSError **)error;

/**
 *  Confirms the PIN entry
 *  This is the callback entry after the delegate is requested to ask the user for the current pin.
 *  @see OGAuthorizationDelegate -(void)askForPin:(NSUInteger)pinSize;
 *
 *  @param pin pin to confirm
 */
- (void)confirmCurrentPin:(NSString *)pin;

/**
 *  Confirms the new PIN.
 *  This is the callback entry after the delegate is requested to ask the user for a new pin.
 *  @see OGAuthorizationDelegate -(void)askForNewPin:(NSUInteger)pinSize;
 *
 *  @param pin pin
 *  @param delegate delegate
 */
- (void)confirmNewPin:(NSString *)pin validation:(id<OGPinValidationDelegate>)delegate;

/**
 *  Confirms the current PIN as part of the change PIN request flow.
 *  This method should be called after a call to OGAuthorizationDelegate - (void)askCurrentPinForChangeRequest;
 *
 *  @param pin pin
 */
- (void)confirmCurrentPinForChangeRequest:(NSString *)pin;

/**
 *  Confirms the new PIN for the change request.
 *  Call this method in reponse to OGAuthorizationDelegate - (void)askNewPinForChangeRequest:(NSUInteger)pinSize;
 *
 *  @param pin pin
 *  @param delegate validation delegate
 */
- (void)confirmNewPinForChangeRequest:(NSString *)pin validation:(id<OGPinValidationDelegate>)delegate;

/**
 *  Confirms the current PIN as part of the Fingerprint Authorization enrollment.
 *  This method should be called after a call - (void)enrollForFingerprintAuthentication:(NSArray *)scopes delegate:(id <OGEnrollmentHandlerDelegate>)delegate;
 *
 *  @param pin pin
 */
- (void)confirmCurrentPinForFingerprintAuthorization:(NSString *)pin;

/**
 *  Handles the response of the authorization request from the browser redirect.
 *  The URL scheme and host must match the config model redirect URL.
 *
 *  @param url callback url
 *  @return true, if the URL is handled by the client
 */
- (BOOL)handleAuthorizationCallback:(NSURL *)url;

/**
 *  Disconnects from the service, this will clear the refresh token and access token.
 *  Client credentials remain untouched.
 *
 *  @param delegate disconnection delegate
 */
- (void)disconnectWithDelegate:(id<OGDisconnectDelegate>)delegate;

/**
 *  Performs a user logout, by invalidating the access token.
 *  The refresh token and client credentials remain untouched.
 *
 *  @param delegate logout delegate
 */
- (void)logoutWithDelegate:(id<OGLogoutDelegate>)delegate;

/**
 *  Clears the client credentials.
 *  A new dynamic client registration has to be performed on the next authorization request.
 */
- (void)clearCredentials;

/**
 *  Clears all tokens and reset the pin attempt count.
 *
 *  @param error not nil when deleting the refresh token from the keychain fails.
 *  @return true, if the token deletion is successful.
 */
- (BOOL)clearTokens:(NSError **)error;

/**
 *  Fetches a specific resource.
 *  The access token validation flow is invoked if no valid access token is available.
 *  Params are encoded using JSON notation.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchResource:(NSString *)path
					 scopes:(NSArray *)scopes
			  requestMethod:(HTTPRequestMethod)requestMethod
					 params:(NSDictionary *)params
				   delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a specific resource.
 *  The access token validation flow is invoked if no valid access token is available.
 *  Params are encoded using JSON notation.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param headers additional headers
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchResource:(NSString *)path
					 scopes:(NSArray *)scopes
			  requestMethod:(HTTPRequestMethod)requestMethod
					 params:(NSDictionary *)params
					headers:(NSDictionary *)headers
				   delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a specific resource.
 *  The access token validation flow is invoked if no valid access token is available.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param paramsEncoding encoding
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchResource:(NSString *)path
					 scopes:(NSArray *)scopes
			  requestMethod:(HTTPRequestMethod)requestMethod
					 params:(NSDictionary *)params
			 paramsEncoding:(HTTPClientParameterEncoding)paramsEncoding
				   delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a specific resource.
 *  The access token validation flow is invoked if no valid access token is available.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param paramsEncoding encoding
 *  @param headers additional headers
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchResource:(NSString *)path
					 scopes:(NSArray *)scopes
			  requestMethod:(HTTPRequestMethod)requestMethod
					 params:(NSDictionary *)params
			 paramsEncoding:(HTTPClientParameterEncoding)paramsEncoding
					headers:(NSDictionary *)headers
				   delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a specific resource anonymously using a client access token.
 *  The access token validation flow is invoked if no valid access token is available.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchAnonymousResource:(NSString *)path
							  scopes:(NSArray *)scopes
					   requestMethod:(HTTPRequestMethod)requestMethod
							  params:(NSDictionary *)params
							delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a specific resource anonymously using a client access token.
 *  The access token validation flow is invoked if no valid access token is available.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param headers additional headers
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchAnonymousResource:(NSString *)path
							  scopes:(NSArray *)scopes
					   requestMethod:(HTTPRequestMethod)requestMethod
							  params:(NSDictionary *)params
							 headers:(NSDictionary *)headers
							delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a specific resource anonymously using a client access token.
 *  The access token validation flow is invoked if no valid access token is available.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param paramsEncoding encoding
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchAnonymousResource:(NSString *)path
							  scopes:(NSArray *)scopes
					   requestMethod:(HTTPRequestMethod)requestMethod
							  params:(NSDictionary *)params
					  paramsEncoding:(HTTPClientParameterEncoding)paramsEncoding
							delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Fetches a specific resource anonymously using a client access token.
 *  The access token validation flow is invoked if no valid access token is available.
 *
 *  @param path relative path to the resource end point
 *  @param scopes scopes
 *  @param requestMethod request method
 *  @param params additional request parameters
 *  @param paramsEncoding encoding
 *  @param headers additional headers
 *  @param delegate delegate
 *  @return transactionId
 */
- (NSString *)fetchAnonymousResource:(NSString *)path
							  scopes:(NSArray *)scopes
					   requestMethod:(HTTPRequestMethod)requestMethod
							  params:(NSDictionary *)params
					  paramsEncoding:(HTTPClientParameterEncoding)paramsEncoding
							 headers:(NSDictionary *)headers
							delegate:(id <OGResourceHandlerDelegate>)delegate;

/**
 *  Stores the device token for the current session.
 *
 *  This should be invoked from the UIApplicationDelegate
 *  - (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
 *
 *  @param deviceToken device token to store
 */
- (void)storeDevicePushTokenInSession:(NSData *)deviceToken;

/**
 *  Enrolls the currently connected device for mobile push authentication.
 *
 *  The device push token must be stored in the session before invoking this method.
 *  @see storeDevicePushTokenInSession:
 *
 *  @param scopes scopes used for mobile authentication
 *  @param delegate delegate handling mobile enrollment callbacks
 */
- (void)enrollForMobileAuthentication:(NSArray *)scopes delegate:(id <OGEnrollmentHandlerDelegate>)delegate;

/**
 *  Enrolls the currently connected device for fingerprint authentication. OGFingerprintDelegate askCurrentPinForFingerprintAuthentication method must be implemented. Pin provided by user must be passed by confirmCurrentPinForFingerprintAuthorization method to complete the flow. Fingerprint authentication must be available for current user and device 
 *  @see -(bool)isFingerprintAuthenticationAvailable
 *
 *  @param scopes scopes used for fingerprint authentication
 *  @param delegate delegate handling fingerprint enrollment callbacks
 */
- (void)enrollForFingerprintAuthentication:(NSArray *)scopes delegate:(id <OGFingerprintDelegate>)delegate;

/**
 *  Disables fingerprint authentication for currently connected device.
 */
- (void)disableFingerprintAuthentication;

/**
 *  Unenrolls the currently connected device for fingerprint authentication.
 *  This method is deprecated, please use disableFingerprintAuthentication.
 *
 *  @param delegate delegate handling fingerprint unenrollment callbacks
 */
- (void)unenrollForFingerprintAuthenticationWithDelegate:(id <OGFingerprintDelegate>)delegate DEPRECATED_ATTRIBUTE;

/**
 *  Determines if device is enrolled for fingerprint authentication.
 *
 *  @param delegate
 */
- (bool)isEnrolledForFingerprintAuthentication;

/**
 *  Determines if fingerprint authentication is possible by checking if device possess Touch ID sensor, at least one fingerprint is registered and if fingerprint is enabled for client configuration provided by token server. Device cannot be jailbroken and have to be running iOS 9 or greater.
 */
- (bool)isFingerprintAuthenticationAvailable;

/**
 *  When a push notification is received by the application, the notificaton must be forwarded to the client.
 *  The client will then fetch the actual encrypted payload and invoke the delegate with the embedded message.
 *
 *  This should be invoked from the UIApplicationDelegate
 *  - (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
 *
 *  @see UIApplication
 *
 *  @param userInfo userInfo of received push notification
 *  @return true, if the notification is processed by the client
 */
- (BOOL)handlePushNotification:(NSDictionary *)userInfo;

@end