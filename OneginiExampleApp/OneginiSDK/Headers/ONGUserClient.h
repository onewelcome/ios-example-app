//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGChangePinDelegate.h"
#import "ONGPublicCommons.h"
#import "ONGAuthenticationDelegate.h"
#import "ONGUserProfile.h"
#import "ONGMobileAuthenticationRequestDelegate.h"
#import "ONGConfigModel.h"
#import "ONGResourceRequest.h"
#import "ONGNetworkTask.h"

@protocol ONGRegistrationDelegate;
@class ONGAuthenticator;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This is the main entry point into the SDK.
 *  The public API of the SDK consists of this client and an authorization delegate.
 *  The client must be instantiated early in the App lifecycle and thereafter only referred to by it's shared instance.
 */
@interface ONGUserClient : NSObject

/**
* Access to the initialized and configured instance of the `ONGUserClient`. Before calling this method You have to initialize
* SDK by calling `-[ONGClientBuilder build]`.
*
* @return instance of the configured `ONGUserClient`.
*
* @see `ONGClientBuilder`, `-[ONGClient userClient]`
*
* @warning If the SDK is not initialized via `-[ONGClientBuilder build]` this method throws an exception.
*/
+ (ONGUserClient *)sharedInstance;

/**
 * Developers should not try to instantiate SDK on their own. The only valid way to get `ONGUserClient` instance is by
 * calling `-[ONGUserClient sharedInstance]`.
 *
 * @see -sharedInstance
 */
- (instancetype)init ONG_UNAVAILABLE;
+ (instancetype)new ONG_UNAVAILABLE;

/**
 *  Main entry point into the authentication process.
 *
 *  @param userProfile profile to authenticate
 *  @param delegate authentication delegate, ONGUserClient keeps weak reference on delegate to avoid retain cycles
 */
- (void)authenticateUser:(ONGUserProfile *)userProfile delegate:(id<ONGAuthenticationDelegate>)delegate;

/**
 *  Main entry point into the registration process.
 *
 *  @param scopes array of scopes
 *  @param delegate registration delegate, ONGUserClient keeps weak reference on delegate to avoid retain cycles
 */
- (void)registerUser:(nullable NSArray<NSString *> *)scopes delegate:(id<ONGRegistrationDelegate>)delegate;

/**
 *  Forces profiles reauthentication.
 *
 *  @param userProfile profile to reauthenticate
 *  @param delegate authentication delegate, ONGUserClient keeps weak reference on delegate to avoid retain cycles
 */
- (void)reauthenticateUser:(ONGUserProfile *)userProfile delegate:(id<ONGAuthenticationDelegate>)delegate;

/**
 *  Initiates the PIN change sequence.
 *  If no refresh token is registered then the sequence is cancelled.
 *  This will invoke a call to the ONGAuthorizationDelegate - (void)askForPinChange:(NSUInteger)pinSize;
 *
 *  @param delegate Object handling change pin callbacks
 */
- (void)changePin:(id<ONGChangePinDelegate>)delegate;

/**
 *  Determines if the user is authorized.
 *
 *  @return true, if a valid access token is available
 */
- (BOOL)isAuthorized;

/**
 *  Return currently authenticated user.
 *
 *  @return authenticated user
 */
- (nullable ONGUserProfile *)authenticatedUserProfile;

/**
 *  Checks if the pin satisfies all pin policy constraints.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGPinValidationErrorDomain.
 *
 *  @param pin pincode to validate against pin policy constraints
 *  @param error pin policy validation error
 *  @return true if all pin policy constraints are satisfied
 */

- (void)validatePinWithPolicy:(NSString *)pin completion:(void (^)(BOOL valid, NSError * _Nullable error))completion;

/**
 *  Handles the response of the registration request from the browser redirect.
 *  The URL scheme and host must match the config model redirect URL.
 *
 *  @param url callback url
 */
- (void)handleRegistrationCallback:(NSURL *)url;

/**
 *  Performs a user logout, by invalidating the access token.
 *  The refresh token and client credentials remain untouched.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGLogoutErrorDomain.
 *
 *  @param completion completion block that is going to be invoked upon logout completion.
 */
- (void)logoutUser:(nullable void (^)(ONGUserProfile *userProfile, NSError *_Nullable error))completion;

/**
 *  Clears all tokens and reset the pin attempt count.
 *
 *  @param error not nil when deleting the refresh token from the keychain fails.
 *  @return true, if the token deletion is successful.
 */
- (BOOL)clearTokens:(NSError **)error;

/**
 *  Stores the device token for the current session.
 *
 *  This should be invoked from the UIApplicationDelegate
 *  - (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
 *
 *  @param deviceToken device token to store
 */
- (void)storeDevicePushTokenInSession:(nullable NSData *)deviceToken;

/**
 *  Enrolls the currently connected device for mobile push authentication.
 *
 *  The device push token must be stored in the session before invoking this method.
 *  @see storeDevicePushTokenInSession:
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGMobileAuthenticationEnrollmentErrorDomain
 *
 *  @param completion delegate handling mobile enrollment callbacks
 */
- (void)enrollForMobileAuthentication:(void (^)(BOOL enrolled, NSError *_Nullable error))completion;

/**
 *  When a push notification is received by the application, the notificaton must be forwarded to the client.
 *  The client will then fetch the actual encrypted payload and invoke the delegate with the embedded message.
 *
 *  This should be invoked from the UIApplicationDelegate
 *  - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 *
 *  @see UIApplication
 *
 *  @param userInfo userInfo of received push notification
 *  @param delegate delegate responsinble for handling push messages
 *  @return true, if the notification is processed by the client
 */
- (BOOL)handleMobileAuthenticationRequest:(NSDictionary *)userInfo delegate:(id<ONGMobileAuthenticationRequestDelegate>)delegate;

/**
 *  List of enrolled users stored locally
 *
 *  @return Enrolled users
 */
- (NSSet<ONGUserProfile *> *)userProfiles;

/**
 *  Delete user locally and revoke it from token server
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGDeregistrationErrorDomain.
 *
 *  @param userProfile user to disconnect.
 *  @param completion completion block that will be invoke upon deregistration completion.
 */
- (void)deregisterUser:(ONGUserProfile *)userProfile completion:(nullable void (^)(BOOL deregistered, NSError *_Nullable error))completion;

/**
 * Perform an authenticated network request. It requires passing an instance of the `ONGResourceRequest` as parameter.
 * In case of a malformed request no task will be returned and the completion block is called immediatelly (sychronously).
 * The User needs to be authenticated, otherwise SDK will return the `ONGFetchResourceErrorUserNotAuthenticated` error.
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGFetchResourceErrorDomain or NSURLErrorDomain.
 *
 * @param request instance of `ONGResourceRequest` instantiated manually or by using `ONGRequestBuilder`
 * @param completion block that will be called either upon request completion or immediatelly in case if validation error.
 * @return instance of `ONGNetworkTask` or nil. By utilizing `ONGNetworkTask` developer may observe and control execution of the request.
 */
- (nullable ONGNetworkTask *)fetchResource:(ONGResourceRequest *)request completion:(nullable void (^)(ONGResourceResponse * _Nullable response, NSError * _Nullable error))completion;

/**
 * Returns a access token for the currently authenticated user, or nil if no user is currently
 * authenticated.
 *
 * <strong>Warning</strong>: Do not use this method if you want to fetch resources from your resource gateway: use the resource methods
 * instead.
 *
 * @return String with access token or nil
 */
@property (nonatomic, readonly, nullable) NSString *accessToken;

/**
 * Discovers and returns a set of authenticators which are supported both, client and server side, and are not yet registered.
 *
 * The returned errors will be within the ONGGenericErrorDomain.
 *
 * @param profile user profile to fetch authenticators
 *
 * @param completion block returning non registered authenticators or any encountered error
 */

- (void)fetchNonRegisteredAuthenticatorsForProfile:(ONGUserProfile *)profile completion:(void (^)(NSSet<ONGAuthenticator *> *_Nullable authenticators, NSError *_Nullable error))completion;

/**
 * Set of registered authenticators.
 */
@property (nonatomic, readonly) NSSet<ONGAuthenticator *> *registeredAuthenticators;

/**
 * Registers an authenticator. Use one of the non registeres authenticators returned by `fetchNonRegisteredAuthenticators` method.
 * Registering an authenticator requires user authentication which is handled by the delegate.
 *
 * The returned errors will be within the ONGGenericErrorDomain or ONGAuthenticatorRegistrationErrorDomain.
 *
 * @param authenticator to be registered authenticator
 * @param delegate delegate authenticating user
 */
- (void)registerAuthenticator:(ONGAuthenticator *)authenticator delegate:(id<ONGAuthenticationDelegate>)delegate;

/**
 * Deregisters an authenticator. Use one of the registered authenticators returned by `registeredAuthenticators` method.
 *
 * The returned errors will be within the ONGGenericErrorDomain or ONGAuthenticatorDeregistrationErrorDomain.
 *
 * @param authenticator to be deregistered authenticator
 * @param completion block returning result of deregistration action or any encountered error
 */
- (void)deregisterAuthenticator:(ONGAuthenticator *)authenticator completion:(nullable void (^)(BOOL deregistered, NSError * _Nullable error))completion;

/**
 * Represents preferred authenticator. By default SDK uses PIN as preferred authenticator.
 */
@property (nonatomic) ONGAuthenticator *preferredAuthenticator;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop