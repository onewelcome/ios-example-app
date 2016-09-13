//  Copyright © 2016 Onegini. All rights reserved.

#import "FingerprintController.h"
#import "PinViewController.h"

@interface FingerprintController ()

@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) void (^completion)();

@end

@implementation FingerprintController

+ (instancetype)fingerprintControllerWithNavigationController:(UINavigationController *)navigationController
                                                   completion:(void (^)())completion
{
    FingerprintController *fingerprintController = [FingerprintController new];
    fingerprintController.navigationController = navigationController;
    fingerprintController.completion = completion;
    return fingerprintController;
}

- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile
{
    NSSet *registeredAuthenticators = [[ONGUserClient sharedInstance] registeredAuthenticatorsForUser:userProfile];
    ONGAuthenticator *fingerprintAuthenticator = [self fingerprintAuthenticatorFromSet:registeredAuthenticators];
    [ONGUserClient sharedInstance].preferredAuthenticator = fingerprintAuthenticator;
    
    [self dismissNavigationPresentedViewController:nil];
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    switch (error.code) {
        // In case User has enter invalid PIN too many times (configured on the Token Server), SDK automatically deregisters User.
        // Developer at this point has to "logout" UI, shutdown user-related services and display Authorization.
        case ONGGenericErrorUserDeregistered:
        case ONGGenericErrorDeviceDeregistered:
            [self unwindNavigationStack];
            [self showError:error.localizedDescription];
            break;

        default:
            [self dismissNavigationPresentedViewController:nil];
            [self showError:error.localizedDescription];
            break;
    }
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    if (challenge.error) {
        [self dismissNavigationPresentedViewController:^{
            [self.pinViewController reset];
            [self.navigationController presentViewController:self.pinViewController animated:YES completion:nil];
        }];
    } else {
        PinViewController *viewController = [PinViewController new];
        self.pinViewController = viewController;
        viewController.pinLength = 5;
        viewController.mode = PINCheckMode;
        viewController.profile = challenge.userProfile;

        viewController.pinEntered = ^(NSString *pin) {
            [challenge.sender respondWithPin:pin challenge:challenge];
        };

        [self.navigationController presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)showError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fingerprint enrollment error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (ONGAuthenticator *)fingerprintAuthenticatorFromSet:(NSSet<ONGAuthenticator *> *)authenticators
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d", ONGAuthenticatorTouchID];
    return [authenticators filteredSetUsingPredicate:predicate].anyObject;
}

- (void)unwindNavigationStack
{
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (void)dismissNavigationPresentedViewController:(void (^)(void))completion
{
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:completion];
    } else if (completion != nil) {
        completion();
    }
}

@end
