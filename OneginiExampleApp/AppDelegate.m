//
// Copyright (c) 2016 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import <UserNotifications/UserNotifications.h>

#import "MobileAuthenticationController.h"
#import "NavigationControllerAppearance.h"
#import "TestOptionsPresenter.h"
#import "ProfileModel.h"
#import "MobileAuthModel.h"
#import "AlertPresenter.h"
#import "PendingTransactionsViewController.h"

@interface AppDelegate () <UINavigationControllerDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic) UINavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupWindow];

    [self startOneginiClient];

    [self registerForPushMessages];
    
    return YES;
}

- (void)setupWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor lightGrayColor];

    WelcomeViewController *root = [[WelcomeViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:root];
    [NavigationControllerAppearance apply:self.navigationController];
    self.navigationController.delegate = self;
    
    PendingTransactionsViewController *pendingTransactionsVC = [[PendingTransactionsViewController alloc] init];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    NSArray *controllers = [NSArray arrayWithObjects: self.navigationController, pendingTransactionsVC, nil];
    tabBarController.viewControllers = controllers;
    
    [self tabBarStylization:tabBarController];

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)startOneginiClient
{
    // Before we can use SDK it needs to be build first
    [[ONGClientBuilder new] build];

    // After being build it also needs to be initialized. This includes contacting the Token Server in order to get the latest configuration and performing
    // sanity checks.
    // This step is crucial since it may report critical errors such as: Application is outdated, OS is outdated.
    // In case of such errors the user can not use the app anymore and has to update the app / OS.
    // The SDK in turn won't be able to provide any functionality to prevent user's data leakage / corruption.
    [[ONGClient sharedInstance] start:^(BOOL result, NSError *error) {
        if (error != nil) {
            // Catching two important errors that might happen during SDK initialization.
            // The user can not use this version of the App / OS anymore and has to update it.
            // To provide a nice UX you may want to limit application functionality and not to force the user to update App / OS immediately.
            if (error.code == ONGGenericErrorOutdatedApplication) {
                [self showAlertWithTitle:@"Application disabled" message:@"The application version is no longer valid, please visit the app store to update your application"];
            } else if (error.code == ONGGenericErrorOutdatedOS) {
                [self showAlertWithTitle:@"OS outdated" message:@"The operating system that you use is no longer valid, please update your OS."];
            } else if (error.code == ONGGenericErrorDeviceDeregistered) {
                [[ProfileModel new] deleteProfileNames];
                [self showAlertWithTitle:@"Device deregistered" message:@"Your device has been deregistered on the server side. Please register your account again."];
            } else if (error.code == ONGGenericErrorUserDeregistered) {
                [self showAlertWithTitle:@"User deregistered" message:@"Your account has been deregistered on the server side. Please register again."];
            } else {
                NSLog(@"Error code: %zd", error.code);
                // Do nothing. Here we most likely will face with network-related errors that can be ignored. Hence, you can start an app in offline mode and
                // later on connect to the internet when the user wants to login or register for example.
            }
        }
    }];

    ONGUserClient *userClient = [ONGUserClient sharedInstance];
    
    self.mobileAuthenticationController = [[MobileAuthenticationController alloc] initWithUserClient:userClient navigationController:self.navigationController tabBarController:(UITabBarController *)self.window.rootViewController];
}

- (void)registerForPushMessages
{
    UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    
    UNAuthorizationOptions supportedTypes = UNAuthorizationOptionSound | UNAuthorizationOptionBadge | UNAuthorizationOptionAlert;
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:supportedTypes completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    AlertPresenter *alertPresenter = [AlertPresenter createAlertPresenterWithTabBarController:(UITabBarController *)self.window.rootViewController];
    [alertPresenter showErrorAlertWithMessage:message title:title];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [MobileAuthModel sharedInstance].deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [MobileAuthModel sharedInstance].deviceToken = nil;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    [self handleNotification:response.notification.request.content.userInfo];
    completionHandler();
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    [self handleNotification:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self setBadgeOnPendingTransactionIcon:(UITabBarController *)self.window.rootViewController];
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
}

- (void)showSecretOptions
{
    [TestOptionsPresenter showSecretOptionsOnViewController:self.window.rootViewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *testingOptions = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:@selector(showSecretOptions)];
    testingOptions.accessibilityIdentifier = @"TestOptionsBarButtonItem";
    viewController.navigationItem.rightBarButtonItem = testingOptions;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return viewController != tabBarController.selectedViewController;
}

- (void)tabBarStylization:(UITabBarController *)tabBarController
{
    UITabBarItem *tabBarHome = [tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarPendingTransactions = [tabBarController.tabBar.items objectAtIndex:1];
    
    [tabBarHome setImage:[UIImage imageNamed:@"key"]];
    [tabBarHome setTitle:@"Home"];
    
    [tabBarPendingTransactions setImage:[UIImage imageNamed:@"notifications-bell-button"]];
}

- (void)setBadgeOnPendingTransactionIcon:(UITabBarController *)tabBarController
{
    [[ONGUserClient sharedInstance] pendingPushMobileAuthRequests:^(NSArray<ONGPendingMobileAuthRequest *> * _Nullable pendingTransactions, NSError * _Nullable error) {
        if (!error) {
            NSInteger pendingTransactionsCount = [pendingTransactions count];
            [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%ld", (long)pendingTransactionsCount]];
        }
    }];
}

- (void)handleNotification:(NSDictionary *)userInfo
{
    BOOL handled = [self.mobileAuthenticationController handlePushMobileAuthenticationRequest:userInfo];
    if (!handled) {
        // pass it to the next service (FireBase, Facebook, etc).
    }
}

@end
