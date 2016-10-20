// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

typedef NSInteger ONGErrorCode;

/**
 * Generic errors that might happen in any flow (authentication, logout, etc) are in ONGGenericErrorDomain.
 */
ONG_EXTERN NSString *const ONGGenericErrorDomain;

/**
 * Error codes in ONGGenericErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGGenericError) {
    /// Due to a problem with the device internet connection it was not possible to initiate the requested action.
    ONGGenericErrorNetworkConnectivityFailure = 9000,
    /// Check the Onegini SDK configuration for the correct server URL.
    ONGGenericErrorServerNotReachable = 9001,
    /// The device registration was removed from the Token Server. All locally stored data is removed from the device and the user needs to register again.
    ONGGenericErrorDeviceDeregistered = 9002,
    /// The user account is deregistered from the device. The user supplied the wrong PIN for too many times. All local data associated with the user profile has been removed.
    ONGGenericErrorUserDeregistered = 9003,
    /// The Token Server denotes that the current app is no longer valid and can no longer be used. The end-user must update the application. Updating the SDK configuration might also solve the problem.
    ONGGenericErrorOutdatedApplication = 9004,
    /// The Token Server does not allow this application to run on the current OS version. Instruct the user to update the OS.
    ONGGenericErrorOutdatedOS = 9005,
    /// Requested action was cancelled.
    ONGGenericErrorActionCancelled = 9006,
    /// Requested action already in progress and can not be performed concurrently.
    ONGGenericErrorActionAlreadyInProgress = 9007,
    /// An unknown error occurred
    ONGGenericErrorUnknown = 10000,
    /// The Token Server configuration does not allow one of the requested scopes.
    ONGGenericErrorConfigurationInvalid = 10001,
    /// The request to the Token Server was invalid. Please verify that the Token Server configuration is correct and that no reverse proxy is interfering with the connection.
    ONGGenericErrorRequestInvalid = 10015,
};

/**
 * ONGAuthenticatorRegistrationErrorDomain contains errors that happen during Authenticator Registration.
 *
 * See -[ONGUserClient registerAuthenticator:delegate:]
 */
ONG_EXTERN NSString *const ONGAuthenticatorRegistrationErrorDomain;

/**
 * Error codes in ONGAuthenticatorRegistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGAuthenticatorRegistrationError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to register an authenticator.
    ONGAuthenticatorRegistrationErrorUserNotAuthenticated = 9010,
    /// The authenticator that you tried to register is invalid. It may not exist, please verify whether you have supplied the correct authenticator for registration.
    ONGAuthenticatorRegistrationErrorAuthenticatorInvalid = 9015,
    /// The given authenticator is already registered and can therefore not be registered again
    ONGAuthenticatorRegistrationErrorAuthenticatorAlreadyRegistered = 10004,
    /// The Token Server configuration does not allow you to register FIDO authenticators. Enable FIDO authentication for the current application in the Token Server configuration to allow FIDO authenticator registration
    ONGAuthenticatorRegistrationErrorFidoAuthenticationDisabled = 10005,
    /// The given authenticator is not supported.
    ONGAuthenticatorRegistrationErrorAuthenticatorNotSupported = 10006,
};

/**
 * ONGAuthenticatorDeregistrationErrorDomain contains errors that happen during Authenticator Deregistration.
 *
 * See -[ONGUserClient deregisterAuthenticator:]
 */
ONG_EXTERN NSString *const ONGAuthenticatorDeregistrationErrorDomain;

/**
 * Error codes in ONGAuthenticatorDeregistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGAuthenticatorDeregistrationError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to deregister an authenticator.
    ONGAuthenticatorDeregistrationErrorUserNotAuthenticated = 9010,
    /// The authenticator that you tried to register is invalid. It may not exist, please verify whether you have supplied the correct authenticator for registration
    ONGAuthenticatorDeregistrationErrorAuthenticatorInvalid = 9015,
    /// The given authenticator is not registered and can therefore not be deregistered
    ONGAuthenticatorDeregistrationErrorAuthenticatorNotRegistered = 10007,
    /// PIN authenticator deregistration not possible
    ONGAuthenticatorPinDeregistrationNotPossible = 10008
};

/**
 * ONGRegistrationErrorDomain contains errors that happen during User Registration.
 *
 * See -[ONGUserClient registerUser:delegate:]
 */
ONG_EXTERN NSString *const ONGRegistrationErrorDomain;

/**
 * Error codes in ONGRegistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGRegistrationError) {
    /// The device could not be registered with the Token Server, verify that the SDK configuration, Token Server configuration and security features are correctly configured
    ONGRegistrationErrorDeviceRegistrationFailure = 9008,
    /// A possible security issue was detected during User Registration.
    ONGRegistrationErrorInvalidState = 10002
};

/**
 * ONGDeregistrationErrorDomain contains errors that happen during User Deregistration.
 *
 * See -[ONGUserClient deregisterUser:completion:]
 */
ONG_EXTERN NSString *const ONGDeregistrationErrorDomain;

/**
 * Error codes in ONGDeregistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGDeregistrationError) {
    /// The user was only deregistered on the device. The device registration has not been removed on the server-side due to a connection problem. This does not pose a problem but you might want to inform the end-user as he might be able to see that he/she is still registered through a web portal.
    ONGDeregistrationErrorLocalDeregistration = 10003,
};

/**
 * ONGChangePinErrorDomain contains errors that happen during Pin Change.
 *
 * See -[ONGUserClient changePin:]
 */
ONG_EXTERN NSString *const ONGChangePinErrorDomain;

/**
 * Error codes in ONGChangePinErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGChangePinError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to change PIN.
    ONGPinChangeErrorUserNotAuthenticated = 9010
};

/**
 * ONGPinAuthenticationErrorDomain contains errors that happen during invalid pin authentication.
 *
 * @discussion During any authentication operation that require pin, user may enter invalid pin.
 * Those error are included within ONGPinAuthenticationErrorDomain.
 */
ONG_EXTERN NSString *const ONGPinAuthenticationErrorDomain;

/**
 * Error codes in ONGPinAuthenticationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGPinAuthenticationError) {
    /// The provided PIN was invalid
    ONGPinAuthenticationErrorInvalidPin = 9009
};

/**
 * ONGPinValidationErrorDomain contains errors that happen during Pin Validation.
 *
 * See -[ONGUserClient validatePinWithPolicy:completion:]
 */
ONG_EXTERN NSString *const ONGPinValidationErrorDomain;

/**
 * The key for max similar digits value returned within userInfo. The value is defined by the received pin policy.
 * It is returned when Pin Validation fails with error ONGPinValidationErrorPinShouldNotUseSimilarDigits.
 */
ONG_EXTERN NSString *const ONGPinValidationErrorMaxSimilarDigitsKey;

/**
 * The key for recommended pin length returned within userInfo. The value is defined by the received pin policy.
 * It is returned when Pin Validation fails with error ONGPinValidationErrorWrongPinLength.
 */
ONG_EXTERN NSString *const ONGPinValidationErrorRequiredLengthKey;

/**
 * Error codes in ONGPinValidationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGPinValidationError) {
    /// The provided PIN was marked as blacklisted on the Token Server.
    ONGPinValidationErrorPinBlackListed = 9011,
    /// The provided PIN contains a not allowed sequence
    ONGPinValidationErrorPinShouldNotBeASequence = 9012,
    /// The provided PIN contains too many similar digits
    ONGPinValidationErrorPinShouldNotUseSimilarDigits = 9013,
    /// The provided PIN length is wrong
    ONGPinValidationErrorWrongPinLength = 9014
};

/**
 * ONGMobileAuthenticationEnrollmentErrorDomain contains errors that happen during Mobile Authentication Enrollment.
 *
 * See -[ONGUserClient enrollForMobileAuthentication:]
 */
ONG_EXTERN NSString *const ONGMobileAuthenticationEnrollmentErrorDomain;

/**
 * Error codes in ONGMobileAuthenticationEnrollmentErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGMobileAuthenticationEnrollmentError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to enroll for mobile authentication.
    ONGMobileAuthenticationEnrollmentErrorUserNotAuthenticated = 9010,
    /// The device is already enrolled for mobile authentication. This may happen in case an old push token is still left behind in the Token Server database and is reused by the OS.
    ONGMobileAuthenticationEnrollmentErrorDeviceAlreadyEnrolled = 9016,
    /// The Mobile authentication feature is disabled in the Token Server configuration.
    ONGMobileAuthenticationEnrollmentErrorEnrollmentNotAvailable = 9017,
    /// The user is already enrolled for mobile authentication on another device.
    ONGMobileAuthenticationEnrollmentErrorUserAlreadyEnrolled = 9018,
    /// The device Push Token is not set.
    ONGMobileAuthenticationEnrollmentErrorMissingDevicePushToken = 10011
};

/**
 * ONGMobileAuthenticationEnrollmentErrorDomain contains errors that happen during handling of the Mobile Authentication Request.
 *
 * See -[ONGUserClient handleMobileAuthenticationRequest:delegate:]
 */
ONG_EXTERN NSString *const ONGMobileAuthenticationRequestErrorDomain;

/**
 * Error codes in ONGMobileAuthenticationRequestErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGMobileAuthenticationRequestError) {
    /// The mobile authentication request was not found. Please make sure that the mobile authentication request is available. This might be an indication that your Token Server setup is not correct. Cache replication might not work properly.
    ONGMobileAuthenticationRequestErrorNotFound = 10013,
};

/**
 * ONGMobileAuthenticationEnrollmentErrorDomain contains errors that happen during User Logout.
 *
 * See -[ONGUserClient logout:]
 */
ONG_EXTERN NSString *const ONGLogoutErrorDomain;

/**
 * Error codes in ONGLogoutErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGLogoutError) {
    /// The user was only logged out on the device. The access token has not been invalidated on the server-side. This does not pose a problem but you might want to inform the end-user as he might be able to see that he/she is still logged in through a web portal.
    ONGLogoutErrorLocalLogout = 10009
};

/**
 * ONGFetchResourceErrorDomain contains errors that happen during Resource Fetching for Authenticated User.
 *
 * See -[ONGUserClient fetchResource:completion:]
 */
ONG_EXTERN NSString *const ONGFetchResourceErrorDomain;

/**
 * Error codes in ONGFetchResourceErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGFetchResourceError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to fetch resources.
    ONGFetchResourceErrorUserNotAuthenticated = 9010,
    /// provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchResourceErrorInvalidMethod = 10010,
};

/**
 * ONGFetchResourceErrorDomain contains errors that happen during Resource Fetching for Authenticated User.
 *
 * See -[ONGDeviceClient fetchAnonymousResource:completion:]
 */
ONG_EXTERN NSString *const ONGFetchAnonymousResourceErrorDomain;

/**
 * Error codes in ONGFetchAnonymousResourceErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGFetchAnonymousResourceError) {
    /// provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchAnonymousResourceErrorInvalidMethod = 10010,
    /// A device access token could not be retrieved. Check your Application configuration in the Token Server
    ONGFetchAnonymousResourceErrorDeviceNotAuthenticated = 10012,
};

/**
 * Error codes in ONGSDKInitializationErrorDomain
 */
ONG_EXTERN NSString *const ONGSDKInitializationErrorDomain;

typedef NS_ENUM(ONGErrorCode, ONGSDKInitializationError) {
    /// The device could not be registered with the Token Server, verify that the SDK configuration, Token Server configuration and security features are correctly configured
    ONGSDKInitialisationErrorDeviceRegistrationFailed = 9008,
};
