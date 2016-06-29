//
//  FingerprintController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 15/06/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "FingerprintController.h"
#import "PinViewController.h"
#import "AppDelegate.h"

@interface FingerprintController ()

@property (nonatomic) PinViewController *pinViewController;

@end

@implementation FingerprintController

+ (instancetype)sharedInstance
{
	static FingerprintController *singleton;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [[self alloc] init];
	});
	return singleton;
}

- (void)enrollForFingerprintAuthentication
{
	[[OGOneginiClient sharedInstance] enrollForFingerprintAuthentication:@[@"read"] delegate:self];
}

- (BOOL)isFingerprintEnrolled
{
	return [[OGOneginiClient sharedInstance] isEnrolledForFingerprintAuthentication];
}

- (void)disableFingerprintAuthentication
{
	[[OGOneginiClient sharedInstance] disableFingerprintAuthentication];
}

- (void)askCurrentPinForFingerprintEnrollmentForUser:(OGUserProfile *)userProfile confirmationDelegate:(id<OGPinConfirmation>)pinConfirmation
{
	PinViewController *viewController = [PinViewController new];
	self.pinViewController = viewController;
	viewController.pinLength = 5;
	viewController.mode = PINCheckMode;
	viewController.profile = userProfile;
	viewController.pinEntered = ^(NSString *pin) {
		[pinConfirmation confirmPin:pin];
	};
	[[AppDelegate sharedNavigationController] presentViewController:viewController animated:YES completion:nil];
}

- (void)fingerprintAuthenticationEnrollmentSuccessful
{
	if ([AppDelegate sharedNavigationController].presentedViewController) {
		[[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)fingerprintAuthenticationEnrollmentFailure
{
	if ([AppDelegate sharedNavigationController].presentedViewController) {
		[[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:nil];
	}
	[self handleError:nil];
}

- (void)fingerprintAuthenticationEnrollmentFailureNotAuthenticated
{
	if ([AppDelegate sharedNavigationController].presentedViewController) {
		[[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)fingerprintAuthenticationEnrollmentErrorInvalidPin:(NSUInteger)attemptCount
{
	if ([AppDelegate sharedNavigationController].presentedViewController) {
		[[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:^{
			[self.pinViewController reset];
			[[AppDelegate sharedNavigationController] presentViewController:self.pinViewController animated:YES completion:nil];
		}];
	}
}

- (void)fingerprintAuthenticationEnrollmentErrorTooManyPinFailures
{
	if ([AppDelegate sharedNavigationController].presentedViewController) {
		[[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:^{
			[[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
		}];
	}
}

- (void)handleError:(NSString *)error
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fingerprint enrollment error" message:error preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okButton = [UIAlertAction
		actionWithTitle:@"Ok"
				  style:UIAlertActionStyleDefault
				handler:^(UIAlertAction *action) {
				}];
	[alert addAction:okButton];
	[[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

@end
