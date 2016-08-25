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
    [[ONGDeviceClient sharedInstance] authenticateDevice:self completion:nil];
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

- (void)authenticationError:(NSError *)error
{
    [self handleAuthError:error];
}

- (void)handleAuthError:(NSError *)error
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Client authentication error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

@end
