//  Copyright © 2016 Onegini. All rights reserved.

#import "RegistrationController.h"
#import "PinViewController.h"
#import "WebBrowserViewController.h"
#import "ProfileViewController.h"
#import "PinErrorMapper.h"

@interface RegistrationController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) void (^completion)();

@end

@implementation RegistrationController

- (PinViewController *)pinViewController
{
    if (!_pinViewController) {
        _pinViewController = [PinViewController new];
        return _pinViewController;
    }
    return _pinViewController;
}

+ (instancetype)registrationControllerWithNavigationController:(UINavigationController *)navigationController
                                                    completion:(void (^)())completion
{
    RegistrationController *registrationController = [RegistrationController new];
    registrationController.navigationController = navigationController;
    registrationController.completion = completion;
    return registrationController;
}

- (void)userClient:(ONGUserClient *)userClient didRegisterUser:(ONGUserProfile *)userProfile
{
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didFailToRegisterWithError:(NSError *)error
{
    // Errors are going to be within ONGGenericErrorDomain or ONGRegistrationErrorDomain domains.
    switch (error.code) {
        // Both errors from ONGRegistrationErrorDomain mean that registration can not be completed.
        // Most likely you will encounter them only during development with invalid configuration.

        // The device could not be registered with the Token Server, verify that the SDK configuration, Token Server configuration and security features are correctly configured
        case ONGRegistrationErrorDeviceRegistrationFailure:
        // A possible security issue was detected during User Registration.
        case ONGRegistrationErrorInvalidState:
            // display an error to the user, hide registration UI, etc
            break;

        // Generic errors
        // In case User has cancelled PIN challenge, cancellation error will be reported. This error can be ignored.
        case ONGGenericErrorActionCancelled:
            break;

        // Undefined error occurred
        case ONGGenericErrorUnknown:

        // Typical network errors
        case ONGGenericErrorNetworkConnectivityFailure:
        case ONGGenericErrorServerNotReachable:

        // This error should not happen in the Production because it means that the configuration is invalid and / or server has proxy.
        // Developer will most likely face with such errors during development itself.
        case ONGGenericErrorRequestInvalid:

        // User trying to perform a registration, but previous registration is not finished yet.
        case ONGGenericErrorActionAlreadyInProgress:

        // Developer typical won't face with ONGGenericErrorOutdatedApplication and ONGGenericErrorOutdatedOS during PIN change.
        // However it is potentially possible, so we need to handle then as well.
        case ONGGenericErrorOutdatedApplication:
        case ONGGenericErrorOutdatedOS:

        default:
            // display error.
            break;
    }

    [self showError:error];

    self.completion();
}

/**
 * In contrast with ONGPinChallenge that can be found during pin change, mobile authentication and other flows
 * ONGCreatePinChallenge doesn't have `challenge.previousFailureCount`. In other words enter of invalid pin
 * do not lead to any attempts counter incrementing. Therefore User is able to enter a pin as many times as needed.
 *
 * Reason of failure can be found by inspecting `challenge.error` property.
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinRegistrationChallenge:(ONGCreatePinChallenge *)challenge
{
    self.pinViewController.pinLength = challenge.pinLength;
    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.profile = challenge.userProfile;

    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };

    // It is up to the developer to decide when and how to show PIN entry view controller.
    // For simplicity of the example app we're checking the top-most view controller.
    if (![self.navigationController.topViewController isEqual:self.pinViewController]) {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }

    if (challenge.error) {
        // Please read comments for the PinErrorMapper to understand intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofCreatePinChallenge:challenge];
        [self.pinViewController showError:description];
        [self.pinViewController reset];
    }
}

- (void)userClient:(ONGUserClient *)userClient didReceiveRegistrationRequestWithUrl:(NSURL *)url
{
    WebBrowserViewController *webBrowserViewController = [WebBrowserViewController new];
    webBrowserViewController.url = url;
    webBrowserViewController.completionBlock = ^(NSURL *completionURL) {
        if ([self.navigationController.presentedViewController isKindOfClass:WebBrowserViewController.class]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [self.navigationController presentViewController:webBrowserViewController animated:YES completion:nil];
}

- (void)showError:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
