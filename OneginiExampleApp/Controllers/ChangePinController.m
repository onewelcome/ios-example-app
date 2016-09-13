//  Copyright © 2016 Onegini. All rights reserved.

#import "ChangePinController.h"
#import "PinViewController.h"
#import "PinErrorMapper.h"

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
        // Please read comments for the PinErrorMapper to understand intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofPinChallenge:challenge];
        [self.pinViewController showError:description];
    }
}

/**
 * Similar to the -userClient:didReceivePinChallenge: `challenge` contains an error.
 * However domains are slightly different: ONGPinValidationErrorDomain and ONGGenericError.
 *
 * In contrast with -userClient:didReceivePinChallenge: failure in -userClient:didReceiveCreatePinChallenge:
 * do not lead to any attempts counter incrementing. Therefore User is able to enter a pin as many times as needed.
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCreatePinChallenge:(ONGCreatePinChallenge *)challenge
{
    [self.pinViewController reset];

    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };

    if (challenge.error) {
        // Please read comments for the PinErrorMapper to understand intent of this class and how errors can be handled.
        NSString *description = [PinErrorMapper descriptionForError:challenge.error ofCreatePinChallenge:challenge];
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
