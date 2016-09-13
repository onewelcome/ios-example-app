//  Copyright © 2016 Onegini. All rights reserved.

#import "AuthenticationController.h"
#import "PinViewController.h"
#import "ProfileViewController.h"

@interface AuthenticationController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) void (^completion)();

@end

@implementation AuthenticationController

+ (instancetype)authenticationControllerWithNavigationController:(UINavigationController *)navigationController
                                                      completion:(void (^)())completion
{
    AuthenticationController *authorizationController = [AuthenticationController new];
    authorizationController.navigationController = navigationController;
    authorizationController.completion = completion;
    authorizationController.pinViewController = [PinViewController new];
    return authorizationController;
}

- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile
{
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    [self showError:error];

    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    [self.pinViewController reset];
    self.pinViewController.pinLength = 5;
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = challenge.userProfile;

    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithPin:pin challenge:challenge];
    };

    if (challenge.previousFailureCount > 0) {
        [self.pinViewController showError:[NSString stringWithFormat:@"Wrong Pin. Remaining attempts: %@", @(challenge.remainingFailureCount)]];
    } else {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }
}

- (void)showError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authentication Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
