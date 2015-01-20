//
//  OneginiCordovaClient.m
//  OneginiCordovaPlugin
//
//  Created by Eduard on 13-01-15.
//
//

#import "OneginiCordovaClient.h"
#import <Cordova/NSDictionary+Extensions.h>
#import "UIAlertView+Blocks.h"

NSString* const kReason				= @"reason";
NSString* const kRemainingAttempts	= @"remainingAttempts";
NSString* const kMethod				= @"method";
NSString* const kError				= @"error";

@implementation OneginiCordovaClient {
	PinEntryConfirmation pinEntryConfirmation;
	PinEntryWithVerification pinEntryWithVerification;
}

@synthesize oneginiClient, authorizeCommandTxId, configModel;
@synthesize confirmPinCommandTxId, fetchResourceCommandTxId;

#pragma mark -
#pragma mark overrides

- (void)pluginInitialize {
#ifdef DEBUG
	NSLog(@"pluginInitialize");
#endif
}

- (void)handleOpenURL:(NSNotification *)notification {
	[super handleOpenURL:notification];
	
	[[OGOneginiClient sharedInstance] handleAuthorizationCallback:notification.object];
}

#pragma mark -
- (void)resetAuthorizationState {
	self.authorizeCommandTxId = nil;
	self.confirmPinCommandTxId = nil;
	
	pinEntryWithVerification = nil;
	pinEntryConfirmation = nil;
}

- (void)resetAll {
	[self resetAuthorizationState];
	self.fetchResourceCommandTxId = nil;
}

- (void)authorizationErrorCallbackWIthReason:(NSString *)reason {
	[self authorizationErrorCallbackWIthReason:reason error:nil];
}

- (void)authorizationErrorCallbackWIthReason:(NSString *)reason error:(NSError *)error {
	if (authorizeCommandTxId == nil) {
		[self resetAuthorizationState];
		return;
	}
	
	NSDictionary *d = @{ kReason:reason };
	if (error != nil) {
		NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:d];
		[md setObject:error.userInfo forKey:kError];
		d = md;
	}
	
//	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:d];
//	[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
//
//	if (confirmPinCommandTxId != nil) {
//		[self.commandDelegate sendPluginResult:result callbackId:confirmPinCommandTxId];
//	}
}

#pragma mark -
#pragma mark Cordova entry points
- (void)clearTokens:(CDVInvokedUrlCommand *)command {
	NSError *error;
	if (![[OGOneginiClient sharedInstance] clearTokens:&error]) {
#ifdef DEBUG
		NSLog("clearTokens error %@", error);
#endif
	}
}

- (void)clearCredentials:(CDVInvokedUrlCommand *)command {
	[[OGOneginiClient sharedInstance] clearCredentials];
}

- (void)initWithConfig:(CDVInvokedUrlCommand *)command {
#ifdef DEBUG
	NSLog(@"initWithConfig %@", command);
#endif
	NSParameterAssert(command.arguments.count == 2);
	
	[CDVPluginResult setVerbose:YES];

	if (command.arguments.count != 2) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"argument count is not 2"];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	
	[self.commandDelegate runInBackground:^{
		NSMutableDictionary *configuration = [command.arguments firstObject];
		if ([configuration objectForKey:kOGDeviceName] == nil) {
			[configuration setObject:[self getDeviceName] forKey:kOGDeviceName];
		}

		self.configModel = [[OGConfigModel alloc] initWithDictionary:configuration];
		self.oneginiClient = [[OGOneginiClient alloc] initWithConfig:configModel delegate:self];

		NSArray *certificates = [command.arguments objectAtIndex:1];
		[oneginiClient setX509PEMCertificates:certificates];
		
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"initWithConfig"];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)authorize:(CDVInvokedUrlCommand *)command {
	[self resetAuthorizationState];
	
	self.authorizeCommandTxId = command.callbackId;
	
//	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//	[result setKeepCallbackAsBool:YES];
//	[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	
	[[OGOneginiClient sharedInstance] authorize:command.arguments];
}

/**
 This is not a direct entry point and only valid to be called when a delegate askForPinWithVerification is requested.
 When the askForPinWithVerification is invoked then the user PIN entry is forwarded back to the OneginiClient by this method.
 
 Command params:
 String pin
 String verifyPin
 Boolean retry
 */
- (void)confirmPinWithVerification:(CDVInvokedUrlCommand *)command {
	// If no request for a PIN entry is registered then this invokation is illegal.
	if (pinEntryWithVerification == nil) {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION];
		[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
		return;
	}
	
	if (command.arguments.count != 3) {
		return;
	}
	
	NSString *pin = command.arguments.firstObject;
	NSString *verification = [command.arguments objectAtIndex:1];
	NSNumber *retry = [command.arguments objectAtIndex:2];
	
	self.confirmPinCommandTxId = command.callbackId;
	
	@try {
		pinEntryWithVerification(pin, verification, retry.boolValue);
	}
	@finally {
		pinEntryWithVerification = nil;
	}
}

/**
 This is not a direct entry point and only valid to be called when a delegate askForPin is requested.
 When the askForPin is invoked then the user PIN entry is forwarded back to the OneginiClient by this method.
 
 Command arguments:
 String pin
 Boolean retry
 */
- (void)confirmPin:(CDVInvokedUrlCommand *)command {
	// If no request for a PIN entry is registered then this invokation is illegal.
	if (pinEntryConfirmation == nil) {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION];
		[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
		return;
	}
	
	if (command.arguments.count != 2) {
		return;
	}
	
	NSString *pin = command.arguments.firstObject;
	NSNumber *retry = command.arguments.lastObject;

	self.confirmPinCommandTxId = command.callbackId;
	
	@try {
		pinEntryConfirmation(pin, retry.boolValue);
	}
	@finally {
		pinEntryConfirmation = nil;
	}
}

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
- (void)fetchResource:(CDVInvokedUrlCommand *)command {
	NSString *path = [command.arguments objectAtIndex:0];
	NSArray *scopes = [command.arguments objectAtIndex:1];
	NSString *requestMethodString = [command.arguments objectAtIndex:2];
	NSString *paramsEncodingString = [command.arguments objectAtIndex:3];
	NSDictionary *params = [command.arguments objectAtIndex:4];
	
	HTTPRequestMethod requestMethod = [self requestMethodForString:requestMethodString];
	HTTPClientParameterEncoding parameterEncoding = [self parameterEncodingForString:paramsEncodingString];
	
	self.fetchResourceCommandTxId = command.callbackId;
	
	[oneginiClient fetchResource:path scopes:scopes requestMethod:requestMethod params:params paramsEncoding:parameterEncoding delegate:self];
}

- (void)fetchAnonymousResource:(CDVInvokedUrlCommand *)command {
	NSString *path = [command.arguments objectAtIndex:0];
	NSArray *scopes = [command.arguments objectAtIndex:1];
	NSString *requestMethodString = [command.arguments objectAtIndex:2];
	NSString *paramsEncodingString = [command.arguments objectAtIndex:3];
	NSDictionary *params = [command.arguments objectAtIndex:4];
	
	HTTPRequestMethod requestMethod = [self requestMethodForString:requestMethodString];
	HTTPClientParameterEncoding parameterEncoding = [self parameterEncodingForString:paramsEncodingString];
	
	self.fetchResourceCommandTxId = command.callbackId;
	
	[oneginiClient fetchAnonymousResource:path scopes:scopes requestMethod:requestMethod params:params paramsEncoding:parameterEncoding delegate:self];
}

- (void)logout:(CDVInvokedUrlCommand *)command {
	@try {
		[self.oneginiClient logout:nil];
	}
	@finally {
		[self resetAll];
	}
}

- (void)disconnect:(CDVInvokedUrlCommand *)command {
	@try {
		[self.oneginiClient disconnect];
	}
	@finally {
		[self resetAll];
	}
}

#pragma mark -
#pragma mark OGAuthorizationDelegate

- (void)requestAuthorization:(NSURL *)url {
	if (configModel.useEmbeddedWebView) {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ kMethod:@"requestAuthorization", @"url":url.absoluteString}];
		result.keepCallback = @(1);
		
		[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	} else {
		[[UIApplication sharedApplication] openURL:url];
	}
}

- (void)authorizationSuccess {
	if (authorizeCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"authorizationSuccess");
#endif
		[self resetAuthorizationState];
		return;
	}
	
	@try {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"authorizationSuccess"];
		result.keepCallback = @(0);
		[self.commandDelegate sendPluginResult:result
									callbackId:authorizeCommandTxId];
	}
	@finally {
		[self resetAuthorizationState];
	}
}

- (void)authorizationError {
	[self authorizationErrorCallbackWIthReason:@"authorizationError"];
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorClientRegistrationFailed" error:error];
}

- (void)askForPinWithVerification:(NSUInteger)pinSize confirmation:(PinEntryWithVerification)confirm {
#ifdef DEBUG
	NSLog(@"askForPinWithVerification:");
#endif

	if (authorizeCommandTxId == nil) {
		return;
	}

	// Keep a reference for the duration of the JS callback cycle
	pinEntryWithVerification = confirm;
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ kMethod:@"askForPinWithVerification" }];
	result.keepCallback = @(1);
	[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	
	// Show a dialog where the user can enter a PIN (not this alert view used for testing)
	
//	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Register '12345' code" delegate:nil cancelButtonTitle:@"Force retry" otherButtonTitles:@"PIN", nil];
//	av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
//		if (buttonIndex == alertView.firstOtherButtonIndex) {
//			confirm(@"12345", @"12345", YES);
//		} else if (buttonIndex == alertView.cancelButtonIndex) {
//			confirm(@"12345", @"00000", YES);
//		}
//	};
//	
//	[av show];
}

- (void)askForPin:(NSUInteger)pinSize confirmation:(PinEntryConfirmation)confirm {
	// Show a dialog where the user can enter a PIN (not this alert view used for testing)
	
#ifdef DEBUG
	NSLog(@"askForPin:");
#endif

	if (authorizeCommandTxId == nil) {
		return;
	}
	
	pinEntryConfirmation = confirm;
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ kMethod:@"askForPin"}];
	result.keepCallback = @(1);
	[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	
//	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Enter '12345' code" delegate:nil cancelButtonTitle:@"Force retry" otherButtonTitles:@"PIN", nil];
//	av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
//		if (buttonIndex == alertView.firstOtherButtonIndex) {
//			confirm(@"12345", YES);
//		} else if (buttonIndex == alertView.cancelButtonIndex) {
//			confirm(@"00000", YES);
//		}
//	};
//	
//	[av show];
}

- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining {
	if (authorizeCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"authorizationErrorInvalidGrant: remaining attempts %d", remaining);
#endif
		return;
	}

	@try {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{ kReason:@"authorizationErrorInvalidGrant", kRemainingAttempts:@(remaining)}];
		result.keepCallback = @(0);
		[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	}
	@finally {
		[self resetAuthorizationState];
	}
}

- (void)authorizationErrorTooManyPinFailures {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorTooManyPinFailures"];
}

- (void)authorizationErrorNotAuthenticated {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorNotAuthenticated"];
}

- (void)authorizationErrorInvalidScope {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorInvalidScope"];
}

- (void)authorizationErrorInvalidState {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorInvalidState"];
}

- (void)authorizationErrorNoAccessToken {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorNoAccessToken"];
}

- (void)authorizationErrorNotAuthorized {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorNotAuthorized"];
}

- (void)authorizationErrorInvalidRequest {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorInvalidRequest"];
}

- (void)authorizationErrorInvalidGrantType {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorInvalidGrantType"];
}

- (void)authorizationErrorNoAuthorizationGrant {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorNoAuthorizationGrant"];
}

- (void)askForPushAuthenticationConfirmation:(NSString *)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm {
	// Not implemented, should be made optional in the SDK
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message notificationType:(NSString *)notificationType
											pinSize:(NSUInteger)pinSize	maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt
											confirm:(PushAuthenticationWithPinConfirmation)confirm {
	// Not implemented, should be made optional in the SDK
}

- (void)askForPinChangeWithVerification:(NSUInteger)pinSize confirmation:(ChangePinEntryWithVerification)confirm cancel:(Cancel)cancel {
	// Not implemented, should be made optional in the SDK
}

// @optional
- (void)pinEntryError:(NSError *)error {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"pinEntryError", kError:error.userInfo }];
	[self.commandDelegate sendPluginResult:result callbackId:confirmPinCommandTxId];
}

// @optional
- (void)authorizationError:(NSError *)error {
	[self authorizationErrorCallbackWIthReason:@"authorizationError" error:error];
}

#pragma mark -
#pragma mark OGResourceHandlerDelegate

- (void)resourceSuccess:(id)response {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:response];
	[self.commandDelegate sendPluginResult:result callbackId:fetchResourceCommandTxId];
}

- (void)resourceError {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"resourceError" }];
	[self.commandDelegate sendPluginResult:result callbackId:fetchResourceCommandTxId];
}

- (void)resourceBadRequest {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"resourceBadRequest" }];
	[self.commandDelegate sendPluginResult:result callbackId:fetchResourceCommandTxId];
}

- (void)scopeError {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"scopeError" }];
	[self.commandDelegate sendPluginResult:result callbackId:fetchResourceCommandTxId];
}

- (void)unauthorizedClient {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"unauthorizedClient" }];
	[self.commandDelegate sendPluginResult:result callbackId:fetchResourceCommandTxId];
}

- (void)resourceErrorAuthenticationFailed {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"resourceErrorAuthenticationFailed" }];
	[self.commandDelegate sendPluginResult:result callbackId:fetchResourceCommandTxId];
}

#pragma mark -
#pragma mark Util 
- (NSString*)getDeviceName {
	UIDevice *dev = [UIDevice currentDevice];
	NSString *name = [NSString stringWithFormat:@"%@_%@_%@", dev.name, dev.systemName, dev.systemVersion];
	return [[name componentsSeparatedByString:@" "] componentsJoinedByString:@"_"];
}

- (HTTPRequestMethod)requestMethodForString:(NSString *)requestMethodString {
	if ([requestMethodString isEqualToString:@"GET"]) {
		return GET;
	} else	if ([requestMethodString isEqualToString:@"PUT"]) {
		return PUT;
	} else	if ([requestMethodString isEqualToString:@"DELETE"]) {
		return DELETE;
	} else	if ([requestMethodString isEqualToString:@"POST"]) {
		return POST;
	} else {
		return GET;
	}
}

- (HTTPClientParameterEncoding)parameterEncodingForString:(NSString *)paramsEncodingString {
	if ([paramsEncodingString isEqualToString:@"FORM"]) {
		return FormURLParameterEncoding;
	} else if ([paramsEncodingString isEqualToString:@"JSON"]) {
		return JSONParameterEncoding;
	} else if ([paramsEncodingString isEqualToString:@"PROPERTY"]) {
		return PropertyListParameterEncoding;
	} else {
		return JSONParameterEncoding;
	}
}

@end