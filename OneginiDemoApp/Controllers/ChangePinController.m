//  Copyright © 2016 Onegini. All rights reserved.

#import "ChangePinController.h"
#import "PinViewController.h"

@interface ChangePinController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;

@end

@implementation ChangePinController

+ (instancetype)changePinControllerWithNavigationController:(UINavigationController *)navigationController
{
    ChangePinController *changePinController = [ChangePinController new];
    changePinController.navigationController = navigationController;
    return changePinController;
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
    [self.navigationController pushViewController:self.pinViewController animated:YES];
}

-( void)userClient:(ONGUserClient *)userClient didReceiveCreatePinChallenge:(ONGCreatePinChallenge *)challenge
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };
    if (challenge.error) {
        [self.pinViewController showError:challenge.error.localizedDescription];
    }
}

- (void)userClient:(ONGUserClient *)userClient didChangePinForUser:(ONGUserProfile *)userProfile
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didFailToChangePinForUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    [self pinChangeError:error];
}

- (void)pinChangeError:(NSError *)error
{
    [self.navigationController popViewControllerAnimated:YES];
    [self handleAuthError:error];
}

- (void)handleAuthError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change pin error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
