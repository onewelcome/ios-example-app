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
 * The error handling described in the FingerprintController differs from what the Example App does during PIN change or PIN Authentication because
 * it is used as a delegate for authenticator registration. Therefore the main difference is in the error handling approach.
 * Possible error domains are ONGAuthenticatorRegistrationErrorDomain and ONGGenericErrorDomain.
 */
- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    switch (error.code) {
        // In case the user is deregistered on the server side the SDK will return the ONGGenericErrorUserDeregistered error. There are a few reasons why this can
        // happen (e.g. the user has entered too many failed PIN attempts). The app needs to handle this situation by deleting any locally stored data for the
        // deregistered user.
        // In case the entire device registration has been removed from the Token Server the SDK will return the ONGGenericErrorDeviceDeregistered error. In this
        // case the application needs to remove any locally stored data that is associated with any user. It is probably best to reset the app in the state as if
        // the user is starting up the app for the first time.
        case ONGGenericErrorUserDeregistered:
        case ONGGenericErrorDeviceDeregistered:
            [self unwindNavigationStack];
            [self showError:error.localizedDescription];
            break;

        // The user has tried to register an authenticator for the user that is no longer authenticated.
        case ONGAuthenticatorRegistrationErrorUserNotAuthenticated:
        // The provided authenticator is not valid. For example attempt to register Fingerprint authenticator while TouchID is neither available nor configured.
        case ONGAuthenticatorRegistrationErrorAuthenticatorInvalid:
        // Attempt to register an already registered authenticator
        case ONGAuthenticatorRegistrationErrorAuthenticatorAlreadyRegistered:
        // Currently not used, you may skip it.
        case ONGAuthenticatorRegistrationErrorFidoAuthenticationDisabled:
        // The given authenticator is not supported.
        case ONGAuthenticatorRegistrationErrorAuthenticatorNotSupported:

        // If the challenge has been cancelled then the ONGGenericErrorActionCancelled error is returned. This error can be ignored.
        case ONGGenericErrorActionCancelled:

        // The SDK doesn't allow you to perform registration of authenticators simultaneously.
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
* The SDK sends a challenge in order to authenticate a user. In case the user has entered an invalid pin or the SDK wasn't able to
 * connect to the server this method will be invoked again. Developer may want to inspect the `challenge.error` property to understand reason of the error.
 * In addition to the error property the `challenge` also maintains `previousFailureCount`, `maxFailureCount` and `remainingFailureCount` that
 * reflects number of PIN attemps left. The user gets deregistered once number of attempts exceeds the maximum amount.
 *
 * Note: during errors that are not related to PIN validation such as network errors the attempts counter remains untouched.
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    if (challenge.error) {
        [self dismissNavigationPresentedViewController:^{
            // Please read the comments written in the PinErrorMapper class to understand the intent of this class and how errors can be handled.
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
