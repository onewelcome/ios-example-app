//
//  OneginiCordovaClient.h
//  OneginiCordovaPlugin
//
//  Created by Eduard on 13-01-15.
//
//

#import <Cordova/CDV.h>
#import "OneginiSDK.h"

@interface OneginiCordovaClient : CDVPlugin <OGAuthorizationDelegate, OGResourceHandlerDelegate, OGPinValidationDelegate, OGChangePinDelegate>

@property (strong, nonatomic) OGOneginiClient *oneginiClient;
@property (strong, nonatomic) OGConfigModel *configModel;

@property (copy, nonatomic) NSString *authorizeCommandTxId;
@property (copy, nonatomic) NSString *pinChangeCommandTxId;
@property (copy, nonatomic) NSString *fetchResourceCommandTxId;
@property (copy, nonatomic) NSString *pinValidateCommandTxId;

/** FOR TESTING PURPOSE ONLY */
- (void)clearTokens:(CDVInvokedUrlCommand *)command;

/** FOR TESTING PURPOSE ONLY */
- (void)clearCredentials:(CDVInvokedUrlCommand *)command;

/**
 Initialize this 'OGOneginiClient' with a valid config model and SSL pinning certificates.
 
 Command params:
 Dictionary config
 Array certificates
 */
- (void)initWithConfig:(CDVInvokedUrlCommand *)command __deprecated;

/**
 Initialize this 'OGOneginiClient' with a valid config model and SSL pinning certificates.
 The configuration is read from the config.plist contained in the bundle.
 
 Command params:
 Array certificates
 */
- (void)init:(CDVInvokedUrlCommand *)command;

/**
 Initiate the authorization flow
 */
- (void)authorize:(CDVInvokedUrlCommand *)command;

/**
 Change the registered PIN. The callback is invoked with a request to show a PIN change entry dialog.
 */
- (void)changePin:(CDVInvokedUrlCommand *)command;

/**
 This is not a direct entry point and only valid to be called when a delegate askForNewPin is requested.
 When the askForPinWithVerification is invoked then the user PIN entry is forwarded back to the OneginiClient by this method.
 
 Command params:
 String pin
 */
- (void)confirmNewPin:(CDVInvokedUrlCommand *)command;

/**
 This is not a direct entry point and only valid to be called when a delegate askForPin is requested.
 When the askForCurrentPin is invoked then the user PIN entry is forwarded back to the OneginiClient by this method.
 
 Command arguments:
 String pin
 */
- (void)confirmCurrentPin:(CDVInvokedUrlCommand *)command;

/**
 This is not a direct entry point and only valid to be called when a delegate askCurrentPinForChangeRequest is requested.

 Command params:
 String currentPin
 */
- (void)confirmCurrentPinForChangeRequest:(CDVInvokedUrlCommand *)command;

/**
 This is not a direct entry point and only valid to be called when a delegate askNewPinForChangeRequest is requested.
 
 Command params:
 String currentPin
 */
- (void)confirmNewPinForChangeRequest:(CDVInvokedUrlCommand *)command;

/**
 Cancel the PIN change. This is not a rollback of a changed PIN.
 It should be called when the user PIN change input dialog is cancelled by the user.
 */
//- (void)cancelPinChange:(CDVInvokedUrlCommand *)command;

/**
 Logout will invalidate the current session.
 */
- (void)logout:(CDVInvokedUrlCommand *)command;

/**
 Disconnect the device, this will clear the refresh token and access token.
 Client credentials remain untouched.
 */
- (void)disconnect:(CDVInvokedUrlCommand *)command;

/**
 Determine if the user is authorized.
 */
- (void)isAuthorized:(CDVInvokedUrlCommand *)command;

/**
 Fetches a specific resource. 
 The access token validation flow is invoked if no valid access token is available.
 
 Command arguments:
 String path
 Array scopes
 String requestMethod, GET, PUT, POST or DELETE
 String parameterEncoding, FORM, JSON or PROPERTY
 Dictionary request parameters
 */
- (void)fetchResource:(CDVInvokedUrlCommand *)command;

/**
 Fetches a specific resource anonymously using a client access token. 
 The access token validation flow is invoked if no valid access token is available.
 
 Command arguments:
 String path
 Array scopes
 String requestMethod, GET, PUT, POST or DELETE
 String parameterEncoding, FORM, JSON or PROPERTY
 Dictionary request parameters
 */
- (void)fetchAnonymousResource:(CDVInvokedUrlCommand *)command;
@end