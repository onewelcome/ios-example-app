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
    [[ONGUserClient sharedInstance] changePinRequest:self];
}

- (void)invalidCurrentPin:(NSUInteger)remaining
{
    [self.pinViewController reset];
}

- (void)askCurrentPinForChangeRequestForUser:(ONGUserProfile *)userProfile pinConfirmation:(id<ONGPinChallengeSender>)delegate
{
    self.pinViewController = [PinViewController new];
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = userProfile;
    self.pinViewController.pinLength = 5;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [delegate continueChallengeWithPin:pin];
    };
    [[AppDelegate sharedNavigationController] pushViewController:self.pinViewController animated:YES];
}

- (void)askNewPinForChangeRequest:(NSUInteger)pinSize pinConfirmation:(id<ONGCreatePinChallengeSender>)delegate
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [delegate continueChallengeWithPin:pin];
    };
}

- (void)pinChangeError:(NSError *)error
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
    [self handleAuthError:error];
}

- (void)pinChanged
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
}

- (void)handleAuthError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change pin error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

@end
