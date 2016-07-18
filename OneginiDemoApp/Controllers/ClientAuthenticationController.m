//  Copyright © 2016 Onegini. All rights reserved.

#import "ClientAuthenticationController.h"
#import "AppDelegate.h"

@implementation ClientAuthenticationController

+ (instancetype)sharedInstance
{
    static ClientAuthenticationController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });

    return singleton;
}

- (void)authenticateClient
{
    [[ONGUserClient sharedInstance] authenticateClient:@[@"read"] delegate:self];
}

- (void)authenticationSuccess
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Client authentication successful" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

- (void)authenticationErrorUnsupportedOS
{
    [self handleAuthError:nil];
}

- (void)authenticationError
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidGrantType
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorNotAuthorized
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidScope
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorClientRegistrationFailed:(NSError *)error
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidRequest
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorInvalidAppPlatformOrVersion
{
    [self handleAuthError:nil];
}

- (void)authenticationErrorDeviceDeregistered
{
    [self handleAuthError:nil];
}

- (void)handleAuthError:(NSString *)error
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Client authentication error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

@end
