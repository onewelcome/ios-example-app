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

- (BOOL)isAuthenticated
{
	return [[ONGUserClient sharedInstance] isAuthorized];
}

- (ONGUserProfile *)authenticatedUserProfile 
{
	return [[ONGUserClient sharedInstance] authenticatedUserProfile];
}

#pragma mark - OGAuthenticationDelegete

-(void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile
{
    ProfileViewController *viewController = [ProfileViewController new];
    [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
}

-(void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    [self handleAuthError:error];
}

-(void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    if (challenge.previousFailureCount) {
        if ([[AppDelegate sharedNavigationController].topViewController isKindOfClass:PinViewController.class]) {
            PinViewController *pinViewController = (PinViewController *)[AppDelegate sharedNavigationController].topViewController;
            [pinViewController reset];
            [pinViewController showError:[NSString stringWithFormat:@"Wrong Pin. Remaining attempts: %ld", challenge.remainingFailureCount]];
        }
    } else {
        PinViewController *viewController = [PinViewController new];
        viewController.pinLength = 5;
        viewController.mode = PINCheckMode;
        viewController.profile = challenge.userProfile;
        viewController.pinEntered = ^(NSString *pin) {
            [challenge.sender respondWithPin:pin challenge:challenge];
        };
        [[AppDelegate sharedNavigationController] pushViewController:viewController animated:YES];
    }
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

@end
