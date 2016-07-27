//
//  AuthCoordinator.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AuthorizationController.h"
#import "AppDelegate.h"
#import "PinViewController.h"
#import "ProfileViewController.h"
#import "WebBrowserViewController.h"

@implementation AuthorizationController

+ (AuthorizationController *)sharedInstance
{
    static AuthorizationController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });

    return singleton;
}

- (void)authenticateUser:(ONGUserProfile *)user
{
	[[ONGUserClient sharedInstance] authenticateUser:user delegate:self];
}

- (void)registerNewUser
{
	[[ONGUserClient sharedInstance] registerUser:@[@"read"] delegate:self];
}

- (BOOL)isAuthenticated
{
	return [[ONGUserClient sharedInstance] isAuthorized];
}

- (ONGUserProfile *)authenticatedUserProfile 
{
	return [[ONGUserClient sharedInstance] authenticatedUserProfile];
}

#pragma mark - OGAuthenticationDelegete

- (void)authenticationSuccessForUser:(ONGUserProfile *)userProfile
{
	ProfileViewController *viewController = [ProfileViewController new];
	[[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)requestAuthenticationCode:(NSURL *)url
{
    WebBrowserViewController *webBrowserViewController = [WebBrowserViewController new];
    webBrowserViewController.url = url;
    webBrowserViewController.completionBlock = ^(NSURL *completionURL) {
        if ([[AppDelegate sharedNavigationController].presentedViewController isKindOfClass:WebBrowserViewController.class]) {
            [[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [[AppDelegate sharedNavigationController] presentViewController:webBrowserViewController animated:YES completion:nil];
}

- (void)authenticationError:(NSError *)error
{
    [self handleAuthError:error];
}

- (void)authenticationErrorInvalidGrant:(NSUInteger)remaining
{
    if ([[AppDelegate sharedNavigationController].topViewController isKindOfClass:PinViewController.class]) {
        PinViewController *pinViewController = (PinViewController *)[AppDelegate sharedNavigationController].topViewController;
        [pinViewController reset];
        [pinViewController showError:[NSString stringWithFormat:@"Wrong Pin. Remaining attempts: %ld", remaining]];
    }
}

- (void)askForNewPin:(NSUInteger)pinSize user:(ONGUserProfile *)userProfile pinConfirmation:(id<ONGNewPinConfirmation>)delegate
{
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = pinSize;
    viewController.mode = PINRegistrationMode;
    viewController.profile = userProfile;
    viewController.pinEntered = ^(NSString *pin) {
        [delegate confirmNewPin:pin validation:self];
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)askForCurrentPinForUser:(ONGUserProfile *)userProfile pinConfirmation:(id<ONGPinConfirmation>)delegate
{
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = 5;
    viewController.mode = PINCheckMode;
    viewController.profile = userProfile;
    viewController.pinEntered = ^(NSString *pin) {
        [delegate confirmPin:pin];
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

#pragma mark - OGPinValidationDelegate

- (void)pinEntryError:(NSError *)error
{
    [self handlePinPolicyValidationError:error];
}

#pragma mark - 

- (void)handleAuthError:(NSError *)error
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authorization Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

- (void)handlePinPolicyValidationError:(NSError *)error
{
    if ([[AppDelegate sharedNavigationController].topViewController isKindOfClass:PinViewController.class]) {
        PinViewController *pinViewController = (PinViewController *)[AppDelegate sharedNavigationController].topViewController;
        pinViewController.mode = PINRegistrationMode;
        [pinViewController reset];
        [pinViewController showError:error.localizedDescription];
    }
}


@end
