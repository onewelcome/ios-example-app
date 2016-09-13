//  Copyright © 2016 Onegini. All rights reserved.

#import "ChangePinController.h"
#import "PinViewController.h"

@interface ChangePinController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) void (^completion)();

@end

@implementation ChangePinController

+ (instancetype)changePinControllerWithNavigationController:(UINavigationController *)navigationController
                                                 completion:(void (^)())completion
{
    ChangePinController *changePinController = [ChangePinController new];
    changePinController.navigationController = navigationController;
    changePinController.pinViewController = [PinViewController new];
    changePinController.completion = completion;
    return changePinController;
}

/*
 * SDK sends challenge in order to authenticated User. In case User has entered invalid pin or SDK wasn't able to
 * connect to the server this method will be invoked again. Developer may want to inspect `challenge.error` property to understand reason of error.
 * In addition to error property `challenge` also maintains `previousFailureCount`, `maxFailureCount` and `remainingFailureCount` that
 * reflects number of attemps left. User gets deregistered once number of attempts exceeded.
 *
 * Note: during errors that are not related to the PIN validation such as network errors attempts counter remains untouched.
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.profile = challenge.userProfile;
    self.pinViewController.pinLength = 5;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithPin:pin challenge:challenge];
    };

    // It is up to the developer to decide when and how to show PIN entry view controller.
    // For simplicity of the example app we're checking top-most view controller.
    if (![self.navigationController.topViewController isEqual:self.pinViewController]) {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }

    if (challenge.error) {
        // Error is going to be either within ONGPinAuthenticationErrorDomain or ONGGenericErrorDomain.
        // However since error codes from different domains are not intersects we can skip domains check (optional)
        NSString *reason = nil;
        switch (challenge.error.code) {
            // Typical error for invalid PIN
            case ONGPinChangeErrorUserNotAuthenticated:
                reason = @"Invalid pin";
                break;

            // Device is not connected to the internet or server is not reachable.
            case ONGGenericErrorNetworkConnectivityFailure:
            case ONGGenericErrorServerNotReachable:
                reason = @"Failed to connect to the server. Please try again";
                break;

            // Such errors breaks pin change and leads to its finishing.
            // They will be propagated to the -userClient:didFailToChangePinForUser:error: instead
            // case ONGGenericErrorDeviceDeregistered:
            // case ONGGenericErrorUserDeregistered:

            // Some undefined error occurred. This not a typical situation but worth to display at least something.
            case ONGGenericErrorUnknown:
            default:
                reason = @"Something went wrong. Please try again";
                break;
        }

        // As mentioned above attempts counter may remain untouched for non-ONGPinChangeErrorUserNotAuthenticated,
        // however we still want to give a hint to the User.
        NSString *description = [NSString stringWithFormat:@"%@. You have still %@ attempts left", reason, @(challenge.remainingFailureCount)];
        [self.pinViewController showError:description];
    }
}

- (void)userClient:(ONGUserClient *)userClient didReceiveCreatePinChallenge:(ONGCreatePinChallenge *)challenge
{
    [self.pinViewController reset];

    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };

    if (challenge.error) {
        // Similar to the -userClient:didReceivePinChallenge: `challenge` contains an error.
        // However domains are slightly different: ONGPinValidationErrorDomain and ONGGenericError.
        //
        // In contrast with -userClient:didReceivePinChallenge: failure in -userClient:didReceiveCreatePinChallenge:
        // do not lead to any attempts counter incrementing. Therefore User is able to enter a pin as many times as needed.
        NSString *description = nil;
        switch (challenge.error.code) {
            // For security reasons some PINs can be blacklisted on the Token Server.
            case ONGPinValidationErrorPinBlackListed:
                description = @"PIN you've entered is blacklisted. Try a different one";
                break;

            // PIN can not be a sequence: 1234 and similar.
            case ONGPinValidationErrorPinShouldNotBeASequence:
                description = @"PIN you've entered appears to be a sequence. Try a different one";
                break;

            // PIN is either too long or too short. Error's user info provides required length.
            // For more information about how to deal with PIN length please follow "PIN Handling Recommendations" guide.
            case ONGPinValidationErrorWrongPinLength: {
                NSNumber *requiredLength = challenge.error.userInfo[ONGPinValidationErrorRequiredLengthKey];
                description = [NSString stringWithFormat:@"PIN has to be of %@ characters length", requiredLength];
                break;
            }

            // PIN uses too many similar digits and insecure (1113, 0000 and similar).
            // SDK provides recommended max of similar digits within `error.userInfo`.
            case ONGPinValidationErrorPinShouldNotUseSimilarDigits: {
                NSNumber *maxSimilarDigits = challenge.error.userInfo[ONGPinValidationErrorMaxSimilarDigitsKey];
                description = [NSString stringWithFormat:@"PIN should not use more that %@ similar digits", maxSimilarDigits];
            }
                break;

            // Rest of the errors most are most likely about network connectivity issues.
            default:
                // Onegini provides reach description for every error. It may not be the case for Production use,
                // however useful during development.
                description = challenge.error.localizedDescription;
                break;
        }

        [self.pinViewController showError:description];
    }
}

- (void)userClient:(ONGUserClient *)userClient didChangePinForUser:(ONGUserProfile *)userProfile
{
    [self.navigationController popViewControllerAnimated:YES];
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didFailToChangePinForUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    // In case User has enter invalid PIN too many times (configured on the Token Server), SDK automatically deregisters User.
    // Developer at this point has to "logout" UI, shutdown user-related services and display Authorization.
    if (error.code == ONGGenericErrorDeviceDeregistered || error.code == ONGGenericErrorUserDeregistered) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

    [self showError:error];

    self.completion();
}

- (void)showError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change pin error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
