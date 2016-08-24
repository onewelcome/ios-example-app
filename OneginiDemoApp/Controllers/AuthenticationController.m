//  Copyright © 2016 Onegini. All rights reserved.

#import "AuthenticationController.h"
#import "PinViewController.h"
#import "ProfileViewController.h"

@interface AuthenticationController ()

@property (nonatomic) UINavigationController *navigationController;

@end

@implementation AuthenticationController

+ (instancetype)authenticationControllerWithNavigationController:(UINavigationController *)navigationController
{
    AuthenticationController *authorizationController = [AuthenticationController new];
    authorizationController.navigationController = navigationController;
    return authorizationController;
}

#pragma mark - OGAuthenticationDelegete

- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile
{
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    [self handleAuthError:error];
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    if (challenge.previousFailureCount) {
        if ([self.navigationController.topViewController isKindOfClass:PinViewController.class]) {
            PinViewController *pinViewController = (PinViewController *)self.navigationController.topViewController;
            [pinViewController reset];
            [pinViewController showError:[NSString stringWithFormat:@"Wrong Pin. Remaining attempts: %@", @(challenge.remainingFailureCount)]];
        }
    } else {
        PinViewController *viewController = [PinViewController new];
        viewController.pinLength = 5;
        viewController.mode = PINCheckMode;
        viewController.profile = challenge.userProfile;
        viewController.pinEntered = ^(NSString *pin) {
            [challenge.sender respondWithPin:pin challenge:challenge];
        };
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)handleAuthError:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authentication Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
