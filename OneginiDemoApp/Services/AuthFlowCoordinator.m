//
//  AuthFlowCoordinator.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "AuthFlowCoordinator.h"

// Services
#import "AuthCoordinator.h"

// ViewControllers
#import "WelcomeViewController.h"
#import "PINViewController.h"
#import "ProfileViewController.h"
#import <SafariServices/SafariServices.h>

@interface AuthFlowCoordinator ()
<
    AuthCoordinatorDelegate,
    PINViewControllerDelegate,
    WelcomeViewControllerDelegate
>

@property (nonatomic, strong) AuthCoordinator *authCoordinator;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, weak) UIViewController *loginViewController;
@property (nonatomic, weak) PINViewController *pinViewController;

@end

@implementation AuthFlowCoordinator

- (instancetype)initWithAuthCoordinator:(AuthCoordinator *)authCoordinator {
    self = [super init];
    if (self) {
        self.authCoordinator = authCoordinator;
        self.authCoordinator.delegate = self;
    }
    return self;
}

- (void)executeInWindow:(UIWindow *)window {
    WelcomeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController]; 
    viewController.delegate = self;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController setNavigationBarHidden:YES];
    window.rootViewController = self.navigationController;
}

- (void)showLoginControllerWithURL:(NSURL *)url {
    UIViewController *viewController = [[SFSafariViewController alloc] initWithURL:url];
    [self.navigationController.topViewController presentViewController:viewController animated:YES completion:NULL];
    
    self.loginViewController = viewController;
}

- (void)showPINController {
    PINViewController *viewController = [PINViewController new];
    viewController.maxCountOfNumbers = 5;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
    
    self.pinViewController = viewController;
}

- (void)showProfileController {
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - AuthCoordinatorDelegate

- (void)authCoordinator:(AuthCoordinator *)coordinator didStartLoginWithURL:(NSURL *)url {
    NSLog(@"Start login with url: %@", url);
    [self showLoginControllerWithURL:url];
}

- (void)authCoordinatorDidFinishLogin:(AuthCoordinator *)coordinator {
    NSLog(@"Finish login");
    [self showProfileController];
}

- (void)authCoordinator:(AuthCoordinator *)coordinator didFailLoginWithError:(NSError *)error {
    NSLog(@"Login error: %@", error.localizedDescription);
}

- (void)authCoordinatorDidAskForCurrentPIN:(AuthCoordinator *)coordinator {
    NSLog(@"Ask for current PIN");
    [self showPINController];
}

- (void)authCoordinator:(AuthCoordinator *)coordinator presentCreatePINWithMaxCountOfNumbers:(NSInteger)countNumbers {
    NSLog(@"Present view to enter pin");
    [self.loginViewController dismissViewControllerAnimated:YES completion:NULL];
    [self showPINController];
}

- (void)authCoordinator:(AuthCoordinator *)coordinator didFailPINEnrollmentWithError:(NSError *)error {
    NSLog(@"PIN enrollment error: %@)", error.localizedDescription);
    [self.pinViewController showError:error];
}

- (void)authCoordinatorDidEnterWrongPIN:(AuthCoordinator *)coordinator remainingAttempts:(NSUInteger)remaining {
    [self.pinViewController wrongPINRemainigAttempts:remaining];
}

#pragma mark - WelcomeViewControllerDelegate

- (void)welcomeViewControllerDidTapLogin:(WelcomeViewController *)viewController {
    [self.authCoordinator login];
}

#pragma mark - PINViewControllerDelegate

- (void)pinViewController:(PINViewController *)viewController didEnterPIN:(NSString *)pin {
    if (self.authCoordinator.isRegistered) {
        [self.authCoordinator enterCurrentPIN:pin];
    } else {
        [self.authCoordinator setNewPin:pin];
    }
}

@end
