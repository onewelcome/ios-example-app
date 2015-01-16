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

@implementation OneginiCordovaClient {
	PinEntryConfirmation pinEntryConfirmation;
	PinEntryWithVerification pinEntryWithVerification;
}

@synthesize oneginiClient, authorizeCommandTxId, configModel;
@synthesize confirmPinCommandTxId;

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

- (void)authorizationErrorCallbackWIthReason:(NSString *)reason {
	[self authorizationErrorCallbackWIthReason:reason error:nil];
}

- (void)authorizationErrorCallbackWIthReason:(NSString *)reason error:(NSError *)error {
	if (authorizeCommandTxId == nil) {
		[self resetAuthorizationState];
		return;
	}
	
	@try {
		NSDictionary *d = @{ @"reason":reason };
		if (error != nil) {
			NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:d];
			[md setObject:error forKey:@"error"];
			d = md;
		}
		
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:d];
		[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];

		if (confirmPinCommandTxId != nil) {
			[self.commandDelegate sendPluginResult:result callbackId:confirmPinCommandTxId];
		}
	}
	@finally {
		[self resetAuthorizationState];
	}
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
 
 Command params: 
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

#pragma mark -
#pragma mark OGAuthorizationDelegate

- (void)requestAuthorization:(NSURL *)url {
	if (configModel.useEmbeddedWebView) {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"method":@"requestAuthorization", @"url":url.absoluteString}];
		[result setKeepCallbackAsBool:YES];
		
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
		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"authorizationSuccess"]
									callbackId:confirmPinCommandTxId];
	}
	@finally {
		[self resetAuthorizationState];
	}
}

- (void)authorizationError {
	[self authorizationErrorCallbackWIthReason:@"authorizationError"];
}

- (void)authorizationError:(NSError *)error {
	[self authorizationErrorCallbackWIthReason:@"authorizationError" error:error];
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
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{ @"method":@"askForPinWithVerification" }];
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
	
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"method":@"askForPin"}];
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
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{ @"reason":@"authorizationErrorInvalidGrant", @"remainingAttempts":@(remaining)}];
		[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	}
	@finally {
		[self resetAuthorizationState];
	}
}

- (void)authorizationErrorTooManyPinFailures {
	[self authorizationErrorCallbackWIthReason:@"authorizationErrorTooManyPinFailures"];
}

/*

- (void)requestAuthorizationWithNotification:(NSNotification *)notification {
	NSURL *url = notification.object;
	[self requestAuthorization:url];
}

- (void)authorizationErrorNotAuthenticated {
	NSLog(@"authorizationErrorNotAuthenticated");
	[self.view makeToast:@"authorizationErrorNotAuthenticated"];
}

- (void)authorizationErrorInvalidScope {
	NSLog(@"authorizationErrorInvalidScope");
	[self.view makeToast:@"authorizationErrorInvalidScope"];
}

- (void)authorizationErrorInvalidState {
	NSLog(@"authorizationErrorInvalidState");
	[self.view makeToast:@"authorizationErrorInvalidState"];
}

- (void)authorizationErrorNoAccessToken {
	NSLog(@"authorizationErrorNoAccessToken");
	[self.view makeToast:@"authorizationErrorNoAccessToken"];
}

- (void)authorizationErrorNotAuthorized {
	NSLog(@"authorizationErrorNotAuthorized");
	[self.view makeToast:@"authorizationErrorNotAuthorized"];
}

- (void)authorizationErrorInvalidRequest {
	NSLog(@"authorizationErrorInvalidRequest");
	[self.view makeToast:@"authorizationErrorInvalidRequest"];
}

- (void)authorizationErrorInvalidGrantType {
	NSLog(@"authorizationErrorInvalidGrantType");
	[self.view makeToast:@"authorizationErrorInvalidGrantType"];
}

- (void)authorizationErrorNoAuthorizationGrant {
	NSLog(@"authorizationErrorNoAuthorizationGrant");
	[self.view makeToast:@"authorizationErrorNoAuthorizationGrant"];
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
	NSLog(@"authorizationErrorClientRegistrationFailed: %@", error);
	
	if (error != nil) {
		[self.view makeToast:@"Authorization client registration failed"];
	}
}

- (void)pinEntryError:(NSError *)error {
	// Receive a PIN match fail error
	[self.view makeToast:[NSString stringWithFormat:@"%@", error.localizedDescription]];
}

- (void)askForPushAuthenticationConfirmation:(NSString *)message notificationType:(NSString *)notificationType confirm:(PushAuthenticationConfirmation)confirm {
	NSLog(@"askForPushAuthenticationConfirmation with message '%@' of type '%@'", message, notificationType);
	
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Attention" message:message delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
	av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
		if (buttonIndex == alertView.firstOtherButtonIndex) {
			confirm(YES);
		} else if (buttonIndex == alertView.cancelButtonIndex) {
			confirm(NO);
		}
	};
	
	[av show];
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message notificationType:(NSString *)notificationType
											pinSize:(NSUInteger)pinSize	maxAttempts:(NSUInteger)maxAttempts retryAttempt:(NSUInteger)retryAttempt
											confirm:(PushAuthenticationWithPinConfirmation)confirm {
	
	NSLog(@"askForPushAuthenticationWithPinConfirmation with message '%@' of type '%@'", message, notificationType);
	
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Attention" message:message delegate:nil cancelButtonTitle:@"Deny" otherButtonTitles:@"PIN", [NSString stringWithFormat:@"Retry %d/%d", retryAttempt, maxAttempts], nil];
	av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
		if (buttonIndex == alertView.firstOtherButtonIndex) {
			confirm(@"12345", YES, YES);
		} else if (buttonIndex == 2) {
			confirm(@"00000", YES, YES);
		} else if (buttonIndex == alertView.cancelButtonIndex) {
			confirm(nil, NO, NO);
		}
	};
	
	[av show];
}
*/

#pragma mark -
#pragma mark Util 
- (NSString*)getDeviceName {
	UIDevice *dev = [UIDevice currentDevice];
	NSString *name = [NSString stringWithFormat:@"%@_%@_%@", dev.name, dev.systemName, dev.systemVersion];
	return [[name componentsSeparatedByString:@" "] componentsJoinedByString:@"_"];
}

@end
