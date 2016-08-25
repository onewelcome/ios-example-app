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
    ONGGenericErrorUnknown = 9000,
    ONGGenericErrorActionCancelled = 9001, // Requested action was cancelled.
    ONGGenericErrorActionAlreadyInProgress = 9002, // Requested action already in progress and can not be performed concurrently.

    ONGGenericErrorNetworkConnectivityFailure = 9010, // Due to a problem with the device internet connection it was not possible to initiate the requested action.
    ONGGenericErrorServerNotReachable = 9011, // Check the Onegini SDK configuration for the correct server URL.

    ONGGenericErrorConfigurationInvalid = 9020, // The Token Server configuration does not allow one of the requested scopes.
    ONGGenericErrorRequestInvalid = 9021, // The request to the Token Server was invalid. Please verify that the Token Server configuration is correct and that no reverse proxy is interfering with the connection.
    ONGGenericErrorOutdatedApplication = 9022, // The Token Server denotes that the current app is no longer valid and can no longer be used. The end-user must update the application. Updating the SDK configuration might also solve the problem.
    ONGGenericErrorOutdatedOS = 9023, // The Token Server does not allow this application to run on the current OS version. Instruct the user to update the OS.

    ONGGenericErrorDeviceDeregistered = 9030, // The device registration was removed from the Token Server. All locally stored data is removed from the device and the user needs to register again.
    ONGGenericErrorUserDeregistered = 9031, // The user account is deregistered from the device. The user supplied the wrong PIN for too many times. All local data associated with the user profile has been removed.
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
    ONGAuthenticatorRegistrationErrorUserNotAuthenticated = 9100, // No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to register an authenticator.

    ONGAuthenticatorRegistrationErrorAuthenticatorInvalid = 9110, // The authenticator that you tried to register is invalid. It may not exist, please verify whether you have supplied the correct authenticator for registration.
    ONGAuthenticatorRegistrationErrorAuthenticatorAlreadyRegistered = 9111, // The given authenticator is already registered and can therefore not be registered again
    ONGAuthenticatorRegistrationErrorFidoAuthenticationDisabled = 9112, // The Token Server configuration does not allow you to register FIDO authenticators. Enable FIDO authentication for the current application in the Token Server configuration to allow FIDO authenticator registration
    ONGAuthenticatorRegistrationErrorAuthenticatorNotSupported = 9113, //The given authenticator is not supported.
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
    ONGAuthenticatorDeregistrationErrorUserNotAuthenticated = 9200, // No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to deregister an authenticator.

    ONGAuthenticatorDeregistrationErrorAuthenticatorInvalid = 9210, // The authenticator that you tried to register is invalid. It may not exist, please verify whether you have supplied the correct authenticator for registration
    ONGAuthenticatorDeregistrationErrorAuthenticatorNotRegistered = 9211, // The given authenticator is not registered and can therefore not be deregistered
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
    ONGRegistrationErrorDeviceRegistrationFailure = 9300, // The device could not be registered with the Token Server, verify that the SDK configuration, Token Server configuration and security features are correctly configured
    ONGRegistrationErrorInvalidState = 9301 // A possible security issue was detected during User Registration.
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
    ONGDeregistrationErrorLocalDeregistration = 9400, // The user was only deregistered on the device. The device registration has not been removed on the server-side due to a connection problem. This does not pose a problem but you might want to inform the end-user as he might be able to see that he/she is still registered through a web portal.
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
    ONGPinChangeErrorUserNotAuthenticated = 9500 // No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to change PIN.
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
    ONGPinAuthenticationErrorInvalidPin = 9600
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
 * Error codes in ONGPinValidationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGPinValidationError) {
    ONGPinValidationErrorPinBlackListed = 9700, // The provided PIN was marked as blacklisted on the Token Server.
    ONGPinValidationErrorPinShouldNotBeASequence = 9701, // The provided PIN contains a not allowed sequence
    ONGPinValidationErrorWrongPinLength = 9702, // The provided PIN length is wrong
    ONGPinValidationErrorPinShouldNotUseSimilarDigits = 9703 // The provided PIN contains too many similar digits
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
    ONGMobileAuthenticationEnrollmentErrorUserNotAuthenticated = 9800, // No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to enroll for mobile authentication.
    ONGMobileAuthenticationEnrollmentErrorDeviceAlreadyEnrolled = 9810, // The device is already enrolled for mobile authentication. This may happen in case an old push token is still left behind in the Token Server database and is reused by the OS.
    ONGMobileAuthenticationEnrollmentErrorEnrollmentNotAvailable = 9811, // The Mobile authentication feature is disabled in the Token Server configuration.
    ONGMobileAuthenticationEnrollmentErrorUserAlreadyEnrolled = 9812, // The user is already enrolled for mobile authentication on another device.
    ONGMobileAuthenticationEnrollmentErrorMissingDevicePushToken = 9820 // The device Push Token is not set.
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
    ONGMobileAuthenticationRequestErrorNotFound = 9900,
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
    ONGLogoutErrorLocalLogout = 10000 // The user was only logged out on the device. The access token has not been invalidated on the server-side. This does not pose a problem but you might want to inform the end-user as he might be able to see that he/she is still logged in through a web portal.
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
    ONGFetchResourceErrorInvalidMethod = 10100, // provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchResourceErrorUserNotAuthenticated = 10101 // No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to fetch resources.
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
    ONGFetchAnonymousResourceErrorInvalidMethod = 10200, // provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchAnonymousResourceErrorDeviceNotAuthenticated = 10201, // A device access token could not be retrieved. Check your Application configuration in the Token Server
};

/**
 * Error codes in ONGSDKInitializationErrorDomain
 */
ONG_EXTERN NSString *const ONGSDKInitializationErrorDomain;

typedef NS_ENUM(ONGErrorCode, ONGSDKInitializationError) {
    ONGSDKInitialisationErrorDeviceRegistrationFailed = 10300, // The device could not be registered with the Token Server, verify that the SDK configuration, Token Server configuration and security features are correctly configured
};
