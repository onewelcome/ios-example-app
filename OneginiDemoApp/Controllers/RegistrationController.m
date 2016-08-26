//  Copyright © 2016 Onegini. All rights reserved.

#import "RegistrationController.h"
#import "PinViewController.h"
#import "WebBrowserViewController.h"
#import "ProfileViewController.h"

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
    [self showError:error];
    self.completion();
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinRegistrationChallenge:(ONGCreatePinChallenge *)challenge
{
    self.pinViewController.pinLength = challenge.pinLength;
    self.pinViewController.mode = PINRegistrationMode;
    self.pinViewController.profile = challenge.userProfile;

    self.pinViewController.pinEntered = ^(NSString *pin) {
        [challenge.sender respondWithCreatedPin:pin challenge:challenge];
    };

    if (challenge.error) {
        [self.pinViewController showError:challenge.error.localizedDescription];
        [self.pinViewController reset];
    } else {
        [self.navigationController pushViewController:self.pinViewController animated:YES];
    }
}

- (void)userClient:(ONGUserClient *)userClient didReceiveAuthenticationCodeRequestWithUrl:(NSURL *)url
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
