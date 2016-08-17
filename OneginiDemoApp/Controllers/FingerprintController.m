//  Copyright © 2016 Onegini. All rights reserved.

#import "FingerprintController.h"
#import "PinViewController.h"
#import "AppDelegate.h"

@interface FingerprintController ()

@property (nonatomic) PinViewController *pinViewController;

@end

@implementation FingerprintController

+ (instancetype)sharedInstance
{
    static FingerprintController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (void)enrollForFingerprintAuthentication
{
    [[ONGUserClient sharedInstance] fetchNonRegisteredAuthenticators:^(NSSet<ONGAuthenticator *> * _Nullable authenticators, NSError * _Nullable error) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", @"Fingerprint"];
        ONGAuthenticator *fingerprintAuthenticator = [authenticators filteredSetUsingPredicate:predicate].anyObject;
        
        [[ONGUserClient sharedInstance] registerAuthenticator:fingerprintAuthenticator delegate:self];
        [ONGUserClient sharedInstance].preferredAuthenticator = fingerprintAuthenticator;
    }];
}

- (BOOL)isFingerprintEnrolled
{
    for (ONGAuthenticator *authenticator in [[ONGUserClient sharedInstance] registeredAuthenticators]) {
        if ([authenticator.identifier isEqualToString:@"Fingerprint"]){
            return YES;
        }
    }
    return NO;
}

- (void)disableFingerprintAuthentication
{
    for (ONGAuthenticator *authenticator in [[ONGUserClient sharedInstance] registeredAuthenticators]) {
        if ([authenticator.identifier isEqualToString:@"Fingerprint"]){
            [[ONGUserClient sharedInstance] deregisterAuthenticator:authenticator completion:nil];
        }
    }
}

- (void)unwindNavigationStack
{
    if ([AppDelegate sharedNavigationController].presentedViewController) {
        [[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:^{
            [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES];
        }];
    }
}

- (void)dismissNavigationPresentedViewController:(void (^)(void))completion
{
    if ([AppDelegate sharedNavigationController].presentedViewController) {
        [[AppDelegate sharedNavigationController] dismissViewControllerAnimated:YES completion:completion];
    } else if (completion != nil) {
        completion();
    }
}

// MARK: - OGFingerprintDelegate

- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile
{
    [self dismissNavigationPresentedViewController:nil];
}

- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile error:(NSError *)error
{
    switch(error.code){
        case ONGGenericErrorUserDeregistered:
        case ONGGenericErrorDeviceDeregistered:
            [self unwindNavigationStack];
            [self handleError:error.description];
            break;
        default:
            [self dismissNavigationPresentedViewController:nil];
            [self handleError:error.description];
            break;
    }
}

- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge
{
    if (challenge.error) {
        [self dismissNavigationPresentedViewController:^{
            [self.pinViewController reset];
            [[AppDelegate sharedNavigationController] presentViewController:self.pinViewController animated:YES completion:nil];
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
        [[AppDelegate sharedNavigationController] presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)handleError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fingerprint enrollment error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
}

@end
