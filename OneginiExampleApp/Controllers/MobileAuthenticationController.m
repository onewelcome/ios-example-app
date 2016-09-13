//  Copyright © 2016 Onegini. All rights reserved.

#import "MobileAuthenticationController.h"
#import "PinViewController.h"
#import "PushConfirmationViewController.h"
#import "PinErrorMapper.h"

@interface MobileAuthenticationController ()

@property (nonatomic) PinViewController *pinViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) void (^completion)();

@end

@implementation MobileAuthenticationController

+ (instancetype)mobileAuthentiactionControllerWithNaviationController:(UINavigationController *)navigationController
                                                           completion:(void (^)())completion
{
    MobileAuthenticationController *mobileAuthenticationController = [MobileAuthenticationController new];
    mobileAuthenticationController.navigationController = navigationController;
    mobileAuthenticationController.completion = completion;
    mobileAuthenticationController.pinViewController = [PinViewController new];
    return mobileAuthenticationController;
}

- (void)userClient:(ONGUserClient *)userClient didReceiveConfirmationChallenge:(void (^)(BOOL confirmRequest))confirmation forRequest:(ONGMobileAuthenticationRequest *)request
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = request.title;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push - %@", request.userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [self.navigationController popViewControllerAnimated:YES];
        confirmation(confirmed);
    };
    [self.navigationController pushViewController:pushVC animated:YES];
}

/**
 * SDK sends challenge in order to authenticated User. In case User has entered invalid pin or SDK wasn't able to
 * connect to the server this method will be invoked again. Developer may want to inspect `challenge.error` property to understand reason of error.
 * In addition to error property `challenge` also maintains `previousFailureCount`, `maxFailureCount` and `remainingFailureCount` that
 * reflects number of attemps left. User gets deregistered once number of attempts exceeded.
 *
 * Note: during errors that are not related to the PIN validation such as network errors attempts counter remains untouched.
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request
{
    [self.pinViewController reset];
    self.pinViewController.mode = PINCheckMode;
    self.pinViewController.pinLength = 5;
    self.pinViewController.customTitle = [NSString stringWithFormat:@"Push with pin - %@", challenge.userProfile.profileId];
    __weak MobileAuthenticationController *weakSelf = self;

    self.pinViewController.pinEntered = ^(NSString *pin) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [challenge.sender respondWithPin:pin challenge:challenge];
    };

    // It is up to the developer to decide when and how to show PIN entry view controller.
    // For simplicity of the example app we're checking the top-most view controller.
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
 * In contract with -userClient:didReceivePinChallenge:forRequest: is not going to be called again in case or error - SDK fallbacks to the PIN instead.
 * This also doesn't affect on the PIN attempts count. Thats why we can skip any error handling for the fingerpint challenge.
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveFingerprintChallenge:(ONGFingerprintChallenge *)challenge forRequest:(ONGMobileAuthenticationRequest *)request
{
    PushConfirmationViewController *pushVC = [PushConfirmationViewController new];
    pushVC.pushMessage.text = request.title;
    pushVC.pushTitle.text = [NSString stringWithFormat:@"Confirm push with fingerprint - %@", request.userProfile.profileId];
    pushVC.pushConfirmed = ^(BOOL confirmed) {
        [self.navigationController popViewControllerAnimated:YES];
        [challenge.sender respondWithDefaultPromptForChallenge:challenge];
    };
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)userClient:(ONGUserClient *)userClient didHandleMobileAuthenticationRequest:(ONGMobileAuthenticationRequest *)request
{
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didFailToHandleMobileAuthenticationRequest:(ONGMobileAuthenticationRequest *)request error:(NSError *)error
{
    if (error.code == ONGGenericErrorUserDeregistered || error.code == ONGGenericErrorDeviceDeregistered) {
        // In case User has enter invalid PIN too many times (configured on the Token Server), SDK automatically deregisters User.
        // Developer at this point has to "logout" UI, shutdown user-related services and display Authorization.
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (error.code == ONGMobileAuthenticationRequestErrorNotFound) {
        // For some reason mobile request can not be found on the Token Server anymore. This can happen if push notification
        // was delivered with a huge delay and a mobile authentication request removed from the Token Server for some reason.
        // Develop may want to notify user about this.
    } else if (error.code == ONGGenericErrorActionCancelled) {
        // If challenge has been cancelled than ONGGenericErrorActionCancelled is reported. This error can be ignored.
    }

    self.completion();
}

@end
