//
//  OneginiCordovaClient.m
//  OneginiCordovaPlugin
//
//  Created by Eduard on 13-01-15.
//
//

#import "OneginiCordovaClient.h"
#import <Cordova/NSDictionary+Extensions.h>

NSString* const kReason				= @"reason";
NSString* const kRemainingAttempts	= @"remainingAttempts";
NSString* const kMethod				= @"method";
NSString* const kError				= @"error";
NSString* const kMaxSimilarDigits	= @"maxSimilarDigits";

@implementation OneginiCordovaClient

@synthesize oneginiClient, pluginInitializedCommandTxId, authorizeCommandTxId, configModel;
@synthesize fetchResourceCommandTxId, pinDialogCommandTxId, pinValidateCommandTxId, pinChangeCommandTxId;

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

- (void)onAppTerminate {
	[oneginiClient logout:nil];
}

#pragma mark -
- (void)resetAll {
    self.pluginInitializedCommandTxId = nil;
	self.authorizeCommandTxId = nil;
	self.fetchResourceCommandTxId = nil;
    self.pinValidateCommandTxId = nil;
    self.pinChangeCommandTxId = nil;
}

- (void)authorizationErrorCallbackWIthReason:(NSString *)reason {
	[self authorizationErrorCallbackWIthReason:reason error:nil];
}

- (void)authorizationErrorCallbackWIthReason:(NSString *)reason error:(NSError *)error {
	if (authorizeCommandTxId == nil) {
		return;
	}
	
	NSDictionary *d = @{ kReason:reason };
	if (error != nil) {
		NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:d];
		[md setObject:error.userInfo forKey:kError];
		d = md;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:d];
	[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
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
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 2 arguments but received %lu", (unsigned long)command.arguments.count]];
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

- (void)awaitPluginInitialization:(CDVInvokedUrlCommand *)command {
    self.pluginInitializedCommandTxId = command.callbackId;
}

- (void)initPinCallbackSession:(CDVInvokedUrlCommand *)command {
	self.pinDialogCommandTxId = command.callbackId;
	
	CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	pluginResult.keepCallback = @(1);
	[self.commandDelegate sendPluginResult:pluginResult callbackId:pinDialogCommandTxId];
    [self sendSuccessCallback:pluginInitializedCommandTxId];
}

- (void)authorize:(CDVInvokedUrlCommand *)command {
	[self resetAll];
	
	self.authorizeCommandTxId = command.callbackId;
	[oneginiClient authorize:command.arguments];
}

- (void)isAuthorized:(CDVInvokedUrlCommand *)command {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[oneginiClient isAuthorized]];
	[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)confirmNewPin:(CDVInvokedUrlCommand *)command {
    self.pinValidateCommandTxId = nil;
    self.pinChangeCommandTxId = nil;
	if (command.arguments.count != 1) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 1 argument but received %lu", (unsigned long)command.arguments.count]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}

	NSString *pin = command.arguments.firstObject;
	
	[oneginiClient confirmNewPin:pin validation:self];
}

- (void)confirmCurrentPin:(CDVInvokedUrlCommand *)command {
	if (command.arguments.count != 1) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 1 argument but received %lu", (unsigned long)command.arguments.count]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	
	NSString *pin = command.arguments.firstObject;

	[oneginiClient confirmCurrentPin:pin];
}

- (void)changePin:(CDVInvokedUrlCommand *)command {
    self.pinChangeCommandTxId = command.callbackId;
    self.pinValidateCommandTxId = nil;
    
	[oneginiClient changePinRequest:self];
}

- (void)cancelPinChange:(CDVInvokedUrlCommand *)command {
    self.pinChangeCommandTxId = nil;
    self.pinValidateCommandTxId = nil;
	// TODO add cancel PIN change method to public API of OGOneginiClient in order to invalidate the state.
}

- (void)confirmCurrentPinForChangeRequest:(CDVInvokedUrlCommand *)command {
    self.pinValidateCommandTxId = nil;
    
	if (command.arguments.count != 1) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 1 argument but received %lu", (unsigned long)command.arguments.count]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	
	NSString *pin = command.arguments.firstObject;
	[oneginiClient confirmCurrentPinForChangeRequest:pin];
}

- (void)confirmNewPinForChangeRequest:(CDVInvokedUrlCommand *)command {
    self.pinValidateCommandTxId = nil;
    
	if (command.arguments.count != 1) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 1 argument but received %lu", (unsigned long)command.arguments.count]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}

	// Register the transaction id for validation callbacks.
    self.pinValidateCommandTxId = command.callbackId;
	NSString *pin = command.arguments.firstObject;

	[oneginiClient confirmNewPinForChangeRequest:pin validation:self];
}

- (void)validatePin:(CDVInvokedUrlCommand *)command {
	if (command.arguments.count != 1) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 1 argument but received %lu", (unsigned long)command.arguments.count]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	
	NSString *pin = command.arguments.firstObject;
	NSError *error;
	BOOL result = [oneginiClient isPinValid:pin error:&error];
	
	CDVPluginResult *pluginResult;
	if (result) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	
	if (![error.domain isEqualToString:@"com.onegini.PinValidation"]) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	
    self.pinValidateCommandTxId = command.callbackId;
	// TODO move error codes into OGPublicCommons public API
	switch (error.code) {
		case 0: {
			[self pinShouldNotBeASequence];
			break;
		}
		case 1: {
			NSNumber *n = error.userInfo[@"kMaxSimilarDigits"];
			[self pinShouldNotUseSimilarDigits:n.integerValue];
			break;
		}
		case 2: {
			[self pinTooShort];
			break;
		}
		case 3: {
			[self pinBlackListed];
			break;
		}
		default: {
			CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		}
	}
}

- (void)fetchResource:(CDVInvokedUrlCommand *)command {
	if (command.arguments.count != 5) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 5 arguments but received %lu", (unsigned long)command.arguments.count]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	
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
	if (command.arguments.count != 5) {
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"expected 5 arguments but received %lu", (unsigned long)command.arguments.count]];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}

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
        [self sendSuccessCallback:command.callbackId];
		[self resetAll];
	}
}

- (void)disconnect:(CDVInvokedUrlCommand *)command {
	@try {
		[self.oneginiClient disconnect];
	}
	@finally {
        [self sendSuccessCallback:command.callbackId];
		[self resetAll];
	}
}

- (void)sendSuccessCallback:(NSString *)callbackId {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
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
		[self resetAll];
		return;
	}
	
	@try {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"authorizationSuccess"];
		result.keepCallback = @(0);
		[self.commandDelegate sendPluginResult:result
									callbackId:authorizeCommandTxId];
	}
	@finally {
		[self resetAll];
	}
}

- (void)authorizationError {
	[self authorizationErrorCallbackWIthReason:@"authorizationError"];
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorClientRegistrationFailed" error:error];
}

- (void)askForCurrentPin {
	if (pinDialogCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"askForCurrentPin: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ kMethod:@"askForCurrentPin"}];
	result.keepCallback = @(1);
	[self.commandDelegate sendPluginResult:result callbackId:pinDialogCommandTxId];
}

- (void)askForNewPin:(NSUInteger)pinSize {
	if (pinDialogCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"askForNewPin: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ kMethod:@"askForNewPin" }];
	result.keepCallback = @(1);
	[self.commandDelegate sendPluginResult:result callbackId:pinDialogCommandTxId];
}

- (void)askNewPinForChangeRequest:(NSUInteger)pinSize {
	if (pinDialogCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"askNewPinForChangeRequest: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ kMethod:@"askNewPinForChangeRequest" }];
	result.keepCallback = @(1);
	[self.commandDelegate sendPluginResult:result callbackId:pinDialogCommandTxId];
}

- (void)askCurrentPinForChangeRequest {
	if (pinDialogCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"askCurrentPinForChangeRequest: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ kMethod:@"askCurrentPinForChangeRequest" }];
	result.keepCallback = @(1);
	[self.commandDelegate sendPluginResult:result callbackId:pinDialogCommandTxId];
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
		[self resetAll];
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

// @optional
- (void)authorizationError:(NSError *)error {
	[self authorizationErrorCallbackWIthReason:@"authorizationError" error:error];
}

#pragma mark -
#pragma mark OGResourceHandlerDelegate

- (void)resourceSuccess:(id)response {
	CDVPluginResult *result;
	
	if ([response isKindOfClass:[NSData class]]) {
		NSData *data = response;
		NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonString];
	} else {
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:response];
	}

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
#pragma mark OGPinValidationHandler

/*
 PIN validation errors should not reset the transaction cause these errors allow for re entering the PIN
 */

- (void)pinBlackListed {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"pinBlackListed" }];
	
	[self.commandDelegate sendPluginResult:result callbackId:pinValidateCommandTxId];
}

- (void)pinShouldNotBeASequence {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"pinShouldNotBeASequence" }];
	[self.commandDelegate sendPluginResult:result callbackId:pinValidateCommandTxId];
}

- (void)pinShouldNotUseSimilarDigits:(NSUInteger)count {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"pinShouldNotUseSimilarDigits", kMaxSimilarDigits:@(count) }];
	[self.commandDelegate sendPluginResult:result callbackId:pinValidateCommandTxId];
}

- (void)pinTooShort {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"pinTooShort" }];
	[self.commandDelegate sendPluginResult:result callbackId:pinValidateCommandTxId];
}

// @optional
- (void)pinEntryError:(NSError *)error {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
											messageAsDictionary:@{ kReason:@"pinEntryError", kError:error.userInfo }];
	[self.commandDelegate sendPluginResult:result callbackId:pinValidateCommandTxId];
}

#pragma mark - 
#pragma mark OGChangePinDelegate

- (void)pinChangeError:(NSError *)error {
	if (pinChangeCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"pinChangeError: pinCommandTxId is nil, invocation is out of context");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{ kReason:@"pinChangeError", kError:error.userInfo} ];
	[self.commandDelegate sendPluginResult:result callbackId:pinChangeCommandTxId];
}

- (void)invalidCurrentPin {
	if (pinChangeCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"invalidCurrentPin: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{ kReason:@"invalidCurrentPin"} ];
	[self.commandDelegate sendPluginResult:result callbackId:pinChangeCommandTxId];
}

- (void)invalidCurrentPin:(NSUInteger)remaining {
	if (pinChangeCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"invalidCurrentPin: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{ kReason:@"invalidCurrentPin", kRemainingAttempts:@(remaining)} ];
	[self.commandDelegate sendPluginResult:result callbackId:pinChangeCommandTxId];
}

- (void)pinChanged {
	if (pinChangeCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"pinChanged: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK	messageAsString:@"pinChanged"];
	[self.commandDelegate sendPluginResult:result callbackId:pinChangeCommandTxId];
}

- (void)pinChangeError {
	if (pinChangeCommandTxId == nil) {
#ifdef DEBUG
		NSLog(@"pinChangeError: pinCommandTxId is nil");
#endif
		return;
	}
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{ kReason:@"pinChangeError"} ];
	[self.commandDelegate sendPluginResult:result callbackId:pinChangeCommandTxId];
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