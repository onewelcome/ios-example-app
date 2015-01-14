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

@implementation OneginiCordovaClient
@synthesize oneginiClient, authorizeCommandTxId, configModel;

- (void)pluginInitialize {
#ifdef DEBUG
	NSLog(@"pluginInitialize");
#endif
}

- (void)initWithConfig:(CDVInvokedUrlCommand *)command {
#ifdef DEBUG
	NSLog(@"initWithConfig %@", command);
#endif
	NSParameterAssert(command.arguments.count == 2);
	
	[self.commandDelegate runInBackground:^{
		NSMutableDictionary *configuration = [command.arguments firstObject];
		if ([configuration objectForKey:kOGDeviceName] == nil) {
			[configuration setObject:[self getDeviceName] forKey:kOGDeviceName];
		}

		self.configModel = [[OGConfigModel alloc] initWithDictionary:configuration];
		self.oneginiClient = [[OGOneginiClient alloc] initWithConfig:configModel delegate:self];

		NSArray *certificates = [command.arguments objectAtIndex:1];
		[oneginiClient setX509PEMCertificates:certificates];
		
		CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)authorize:(CDVInvokedUrlCommand *)command {
	NSParameterAssert(command.arguments.count == 1);
	
	self.authorizeCommandTxId = command.callbackId;
	
	[[OGOneginiClient sharedInstance] authorize:command.arguments];
}

#pragma mark -
#pragma mark OGAuthorizationDelegate

- (void)requestAuthorization:(NSURL *)url {
	if (configModel.useEmbeddedWebView) {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url.absoluteString];
		[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	} else {
		[[UIApplication sharedApplication] openURL:url];
	}
}

- (void)askForPinWithVerification:(NSUInteger)pinSize confirmation:(PinEntryWithVerification)confirm {
#ifdef DEBUG
	NSLog(@"askForPinWithVerification:");
#endif
	// Show a dialog where the user can enter a PIN (not this alert view used for testing)
	
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Register '12345' code" delegate:nil cancelButtonTitle:@"Force retry" otherButtonTitles:@"PIN", nil];
	av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
		if (buttonIndex == alertView.firstOtherButtonIndex) {
			confirm(@"12345", @"12345", YES);
		} else if (buttonIndex == alertView.cancelButtonIndex) {
			confirm(@"12345", @"00000", YES);
		}
	};
	
	[av show];
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
	if (authorizeCommandTxId == nil) {
		return;
	}
	
	@try {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
		[self.commandDelegate sendPluginResult:result callbackId:authorizeCommandTxId];
	}
	@finally {
		self.authorizeCommandTxId = nil;
	}
}

/*
- (void)askForPin:(NSUInteger)pinSize confirmation:(PinEntryConfirmation)confirm {
	// Show a dialog where the user can enter a PIN (not this alert view used for testing)
	
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Enter '12345' code" delegate:nil cancelButtonTitle:@"Force retry" otherButtonTitles:@"PIN", nil];
	av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
		if (buttonIndex == alertView.firstOtherButtonIndex) {
			confirm(@"12345", YES);
		} else if (buttonIndex == alertView.cancelButtonIndex) {
			confirm(@"00000", YES);
		}
	};
	
	[av show];
}

- (void)authorizationSuccess {
	NSLog(@"authorizationSuccess");
	
	entryCount = 0;
	[self performSegueWithIdentifier:@"authenticated" sender:self];
}

- (void)authorizationError {
	NSLog(@"authorizationError");
	[self.view makeToast:@"Authorization error"];
}

- (void)authorizationError:(NSError *)error {
	NSLog(@"authorizationError: %@", error);
	[self.view makeToast:error.localizedDescription];
}

- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining {
	NSLog(@"authorizationErrorInvalidGrant: remaining attempts %d", remaining);
	[self.view makeToast:[NSString stringWithFormat:@"Remaining attempts %ld", (unsigned long)remaining]];
}

- (void)authorizationErrorTooManyPinFailures {
	NSLog(@"authorizationErrorTooManyPinFailures");
	
	entryCount = 0;
	
	[self.view makeToast:@"Too many pin failures"];
}

- (void)requestAuthorizationWithNotification:(NSNotification *)notification {
	NSURL *url = notification.object;
	[self requestAuthorization:url];
}

- (void)authorizationErrorNotAuthenticated {
	NSLog(@"authorizationErrorNotAuthenticated");
	[self.view makeToast:@"authorizationErrorNotAuthenticated"];
}

- (void)requestAuthorization:(NSURL *)url {
	[[UIApplication sharedApplication] openURL:url];
	
	//	webViewOverlay = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
	//					  instantiateViewControllerWithIdentifier:@"WebViewOverlay"];
	//	[webViewOverlay setUrl:url];
	//
	//	webViewOverlay.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	//		[self presentViewController:webViewOverlay animated:YES completion:^{
	//	}];
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
