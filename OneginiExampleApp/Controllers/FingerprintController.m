//  Copyright © 2016 Onegini. All rights reserved.

#import "FingerprintController.h"
#import "PinViewController.h"
#import "PinErrorMapper.h"

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

/**
 * Error handling described in FingerprintController differs from what Example App does during PIN change or Authentication because
 * it is used as a delegate for authenticators registration. Therefore main difference is in the errors handling approach.
 * Possible error domains are ONGAuthenticatorRegistrationErrorDomain and ONGGenericErrorDomain.
 */
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

        // User has tried to register an authenticator for the user that is no longer authenticated.
        case ONGAuthenticatorRegistrationErrorUserNotAuthenticated:
        // Provided authenticator is not valid. For example attempt to register Fingerprint authenticator while TouchID neither available or configured.
        case ONGAuthenticatorRegistrationErrorAuthenticatorInvalid:
        // Attempt to register already registered authenticator
        case ONGAuthenticatorRegistrationErrorAuthenticatorAlreadyRegistered:
        // Currently not used, you may skip it.
        case ONGAuthenticatorRegistrationErrorFidoAuthenticationDisabled:
        // The given authenticator is not supported.
        case ONGAuthenticatorRegistrationErrorAuthenticatorNotSupported:

        // If challenge has been cancelled than ONGGenericErrorActionCancelled is reported. This error can be ignored.
        case ONGGenericErrorActionCancelled:

        // SDK doesn't allow you to perform registration of authenticators simultaneously.
        case ONGGenericErrorActionAlreadyInProgress:

        // Typical network connectivity failure errors
        case ONGGenericErrorNetworkConnectivityFailure:
        case ONGGenericErrorServerNotReachable:

        default:
            [self dismissNavigationPresentedViewController:nil];
            [self showError:error.localizedDescription];
            break;
    }

    self.completion();
}

/**
 * SDK sends challenge in order to authenticated User. In case User has entered invalid pin or SDK wasn't able to
 * connect to the server this method will be invoked again. Developer may want to inspect `challenge.error` property to understand reason of error.
 * In addition to error property `challenge` also maintains `previousFailureCount`, `maxFailureCount` and `remainingFailureCount` that
 * reflects number of attemps left. User gets deregistered once number of attempts exceeded.
 *
 * Note: during errors that are not related to the PIN validation such as network errors attempts counter remains untouched.
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    if (challenge.error) {
        [self dismissNavigationPresentedViewController:^{
            // Please read comments for the PinErrorMapper to understand intent of this class and how errors can be handled.
            NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
            [self.pinViewController showError:description];

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
