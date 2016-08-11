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
    [[ONGUserClient sharedInstance] changePin:self];
}

#pragma mark - ONGPinChangeDelegate

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    self.pinViewController = [PinViewController new];
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = challenge.userProfile;
    self.pinViewController.pinLength = 5;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithPin:pin challenge:challenge];
    };
    [[AppDelegate sharedNavigationController] pushViewController:self.pinViewController animated:YES];
}

-( void)userClient:(ONGUserClient *)userClient didReceiveCreatePinChallenge:(ONGCreatePinChallenge *)challenge
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };
}

- (void)userClient:(ONGUserClient *)userClient didChangePinForUser:(ONGUserProfile *)userProfile
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didFailToChangePinForUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    [self pinChangeError:error];
}

- (void)pinChangeError:(NSError *)error
{
    [[AppDelegate sharedNavigationController] popViewControllerAnimated:YES];
    [self handleAuthError:error];
}

- (void)handleAuthError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change pin error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

@end
