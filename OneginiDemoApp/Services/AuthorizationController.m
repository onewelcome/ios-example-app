//
//  AuthCoordinator.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AuthorizationController.h"
#import "OneginiSDK.h"
#import "AppDelegate.h"
#import "PinViewController.h"
#import "ProfileViewController.h"
#import "WebBrowserViewController.h"

@interface AuthorizationController () <OGAuthorizationDelegate, OGPinValidationDelegate>

@end

@implementation AuthorizationController

+ (AuthorizationController *)sharedInstance {
    static AuthorizationController *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
        [OGOneginiClient sharedInstance].authorizationDelegate = singleton;
        [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(closeWebBrowser) name:OGCloseWebViewNotification object:nil];
    });
    
    return singleton;
}

- (void)login {
    [[OGOneginiClient sharedInstance] authorize:@[@"read"]];
}

- (BOOL)isRegistered {
    return [[OGOneginiClient sharedInstance] isClientRegistered];
}

#pragma mark -

- (void)handleAuthError:(NSString *)error {
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authorization Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action){}];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

- (void)handlePinPolicyValidationError:(NSString *)error {
    if ([[AppDelegate sharedNavigationController].topViewController isKindOfClass:PinViewController.class]){
        PinViewController *pinViewController = (PinViewController*)[AppDelegate sharedNavigationController].topViewController;
        pinViewController.mode = PINRegistrationMode;
        [pinViewController reset];
        [pinViewController showError:error];
    }
}

#pragma mark - OGAuthorizationDelegate

- (void)authorizationSuccess {
    ProfileViewController *viewController = [ProfileViewController new];
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)requestAuthorization:(NSURL *)url {
    WebBrowserViewController *webBrowserViewController = [WebBrowserViewController new];
    webBrowserViewController.url = url;
    [[AppDelegate sharedNavigationController] presentViewController:webBrowserViewController animated:YES completion:nil];
}

- (void)closeWebBrowser{
    if ([[AppDelegate sharedNavigationController].presentedViewController isKindOfClass:WebBrowserViewController.class]){
        [[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)askForNewPin:(NSUInteger)pinSize {
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = pinSize;
    viewController.mode = PINRegistrationMode;
    viewController.pinEntered = ^(NSString * pin) {
        [[OGOneginiClient sharedInstance] confirmNewPin:pin validation:self];
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)askForCurrentPin {
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = 5;
    viewController.mode = PINCheckMode;
    viewController.pinEntered = ^(NSString *pin) {
        [[OGOneginiClient sharedInstance] confirmCurrentPin:pin];
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)askCurrentPinForChangeRequest {
    
}

- (void)askNewPinForChangeRequest:(NSUInteger)pinSize {
    
}

- (void)askForPushAuthenticationConfirmation:(NSString *)message
                            notificationType:(NSString *)notificationType
                                     confirm:(PushAuthenticationConfirmation)confirm {
    
}

- (void)askForPushAuthenticationWithPinConfirmation:(NSString *)message
                                   notificationType:(NSString *)notificationType
                                            pinSize:(NSUInteger)pinSize
                                        maxAttempts:(NSUInteger)maxAttempts
                                       retryAttempt:(NSUInteger)retryAttempt
                                            confirm:(PushAuthenticationWithPinConfirmation)confirm {
    
}

- (void)askForPushAuthenticationWithFingerprint:(NSString*)message
                               notificationType:(NSString *)notificationType
                                        confirm:(PushAuthenticationConfirmation)confirm {
    
}

- (void)authorizationError {
    [self handleAuthError:nil];
}

- (void)authorizationErrorTooManyPinFailures {
    [self handleAuthError:@"Too many Pin failures. User has benn disconnected."];
}

- (void)authorizationErrorInvalidGrant:(NSUInteger)remaining {
    if ([[AppDelegate sharedNavigationController].topViewController isKindOfClass:PinViewController.class]){
        PinViewController *pinViewController = (PinViewController*)[AppDelegate sharedNavigationController].topViewController;
        [pinViewController reset];
        [pinViewController showError:[NSString stringWithFormat:@"Wrong Pin. Remaining attempts: %ld",remaining]];
    }
}

- (void)authorizationErrorNoAuthorizationGrant {
    [self handleAuthError:nil];
}

- (void)authorizationErrorNoAccessToken {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidRequest {
    [self handleAuthError:nil];
}

- (void)authorizationErrorClientRegistrationFailed:(NSError *)error {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidState {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidScope {
    [self handleAuthError:nil];
}

- (void)authorizationErrorNotAuthenticated {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidGrantType {
    [self handleAuthError:nil];
}

- (void)authorizationErrorInvalidAppPlatformOrVersion {
    [self handleAuthError:@"Unsupported App version, please upgrade."];
}

- (void)authorizationErrorUnsupportedOS {
    [self handleAuthError:@"Unsupported iOS version, please upgrade."];
}

- (void)authorizationErrorNotAuthorized {
    [self handleAuthError:nil];
}

- (void)authorizationError:(NSError *)error {
    [self handleAuthError:nil];
}

#pragma mark - OGPinValidationDelegate

- (void)pinBlackListed {
    [self handlePinPolicyValidationError:@"Pin is blacklisted!"];
}

- (void)pinShouldNotBeASequence {
    [self handlePinPolicyValidationError:@"Pin should not be a sequence!"];
}

- (void)pinShouldNotUseSimilarDigits:(NSUInteger)count {
    [self handlePinPolicyValidationError:@"Pin should not use similar digits!"];
}

- (void)pinTooShort {
    [self handlePinPolicyValidationError:@"Pin is too short!"];
}

- (void)pinEntryError:(NSError *)error {
    [self handlePinPolicyValidationError:@"Pin is not valid!"];
}


@end
