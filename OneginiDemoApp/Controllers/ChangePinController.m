//  Copyright © 2016 Onegini. All rights reserved.

#import "ChangePinController.h"
#import "PinViewController.h"
#import "AppDelegate.h"

@interface ChangePinController ()

@property (nonatomic) PinViewController *pinViewController;

@end

@implementation ChangePinController

+ (instancetype)sharedInstance
{
    static ChangePinController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });

    return singleton;
}

- (void)changePin
{
    [[ONGOneginiClient sharedInstance] changePinRequest:self];
}

- (void)invalidCurrentPin:(NSUInteger)remaining
{
    [self.pinViewController reset];
}


- (void)askCurrentPinForChangeRequestForUser:(ONGUserProfile *)userProfile pinConfirmation:(id<ONGPinConfirmation>)delegate
{
    self.pinViewController = [PinViewController new];
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = userProfile;
    self.pinViewController.pinLength = 5;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [delegate confirmPin:pin];
    };
    [[AppDelegate sharedNavigationController] pushViewController:self.pinViewController animated:YES];
}

- (void)askNewPinForChangeRequest:(NSUInteger)pinSize pinConfirmation:(id<ONGNewPinConfirmation>)delegate
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [delegate confirmNewPin:pin validation:nil];
    };
}

- (void)pinChangeError
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
    [self handleAuthError:nil];
}

- (void)pinChangeErrorTooManyPinFailures
{
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
    [self handleAuthError:nil];
}

- (void)pinChangeError:(NSError *)error
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
    [self handleAuthError:nil];
}

- (void)pinChangeErrorDeviceDeregistered
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
    [self handleAuthError:nil];
}

- (void)pinChanged
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
}

- (void)handleAuthError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change pin error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

@end
