//
//  RegistrationController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 25/07/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "RegistrationController.h"
#import "ONGUserClient.h"
#import "AppDelegate.h"
#import "PinViewController.h"
#import "WebBrowserViewController.h"
#import "OneginiSDK.h"
#import "ProfileViewController.h"

@implementation RegistrationController

+ (RegistrationController *)sharedInstance
{
    static RegistrationController *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (void)registerNewUser
{
    [[ONGUserClient sharedInstance] registerUser:@[@"read"] delegate:self];
}

- (void)userClient:(ONGUserClient *)userClient didRegisterUser:(ONGUserProfile *)userProfile
{
    ProfileViewController *viewController = [ProfileViewController new];
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didFailToRegisterWithError:(NSError *)error
{
    [self handleAuthError:error];
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinRegistrationChallenge:(ONGCreatePinChallenge *)challenge
{
    NSLog(@"%@",challenge.error);
    PinViewController *viewController = [PinViewController new];
    viewController.pinLength = challenge.pinLength;
    viewController.mode = PINRegistrationMode;
    viewController.profile = challenge.userProfile;
    viewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didReceiveAuthenticationCodeRequestWithUrl:(NSURL *)url
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

#pragma mark - OGPinValidationDelegate

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
