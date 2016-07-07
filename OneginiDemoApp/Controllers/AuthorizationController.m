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

- (void)authenticateUser:(OGUserProfile *)user
{
    [[OGOneginiClient sharedInstance] authenticateUser:user delegate:self];;
}

- (void)registerNewUser
{
    [[OGOneginiClient sharedInstance] registerUser:@[@"read"] delegate:self];
}

- (BOOL)isAuthenticated
{
    return [[OGOneginiClient sharedInstance] isAuthorized];
}

- (OGUserProfile *)authenticatedUserProfile
{
    return [[OGOneginiClient sharedInstance] authenticatedUserProfile];
}

#pragma mark - OGAuthenticationDelegete

- (void)authenticationSuccessForUser:(OGUserProfile *)userProfile
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

- (void)authenticationError
{
    [self handleAuthError:nil];
}

- (void)authenticationError:(NSError *)error
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidScope
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorNotAuthorized
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidGrant:(NSUInteger)remaining
{
    if ([[AppDelegate sharedNavigationController].topViewController isKindOfClass:PinViewController.class]) {
        PinViewController *pinViewController = (PinViewController *)[AppDelegate sharedNavigationController].topViewController;
        [pinViewController reset];
        [pinViewController showError:[NSString stringWithFormat:@"Wrong Pin. Remaining attempts: %ld", remaining]];
    }
}

- (void)authenticationErrorClientRegistrationFailed:(NSError *)error
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidState
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidRequest
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidUser
{
    [self handleAuthError:@"Invalid user."];
}

- (void)authenticationErrorInvalidAppPlatformOrVersion
{
    [self handleAuthError:@"Unsupported App version, please upgrade."];
}

- (void)authenticationErrorInvalidGrantType
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorDeviceDeregistered
{
    [self handleAuthError:@"Device has been deregistered."];
}

- (void)authenticationErrorUserDeregistered
{
    [self handleAuthError:@"User has been deregistered."];
}

- (void)authenticationErrorUnsupportedOS
{
    [self handleAuthError:@"Unsupported iOS version, please upgrade."];
}

- (void)askForNewPin:(NSUInteger)pinSize user:(OGUserProfile *)userProfile pinConfirmation:(id<OGNewPinConfirmation>)delegate
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

- (void)askForCurrentPinForUser:(OGUserProfile *)userProfile pinConfirmation:(id<OGPinConfirmation>)delegate
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

- (void)pinBlackListed
{
    [self handlePinPolicyValidationError:@"Pin is blacklisted!"];
}

- (void)pinShouldNotBeASequence
{
    [self handlePinPolicyValidationError:@"Pin should not be a sequence!"];
}

- (void)pinShouldNotUseSimilarDigits:(NSUInteger)count
{
    [self handlePinPolicyValidationError:[NSString stringWithFormat:@"Maximum number of similar digits are: %ld", count]];
}

- (void)pinTooShort
{
    [self handlePinPolicyValidationError:@"Pin is too short!"];
}

- (void)pinEntryError:(NSError *)error
{
    [self handlePinPolicyValidationError:@"Pin is not valid!"];
}

#pragma mark - 

- (void)handleAuthError:(NSString *)error
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authorization Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

- (void)handlePinPolicyValidationError:(NSString *)error
{
    if ([[AppDelegate sharedNavigationController].topViewController isKindOfClass:PinViewController.class]) {
        PinViewController *pinViewController = (PinViewController *)[AppDelegate sharedNavigationController].topViewController;
        pinViewController.mode = PINRegistrationMode;
        [pinViewController reset];
        [pinViewController showError:error];
    }
}


@end
