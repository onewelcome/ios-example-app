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
#import "MobileAuthenticationController.h"

@interface AppDelegate ()

@property (nonatomic) MobileAuthenticationController *mobileAuthenticationController;

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

    UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];

    UIImage *background = [UIImage imageNamed:@"background"];
    [controller.navigationBar setBackgroundImage:background forBarMetrics:UIBarMetricsDefault];
    [controller.navigationBar setTintColor:[UIColor whiteColor]];
    [controller.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [controller.toolbar setBackgroundImage:background forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [controller.toolbar setTintColor:[UIColor whiteColor]];
    
    self.window.rootViewController = controller;
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
}

- (void)registerForPushMessages
{
    UIUserNotificationType supportedTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:supportedTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[ONGUserClient sharedInstance] storeDevicePushTokenInSession:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[ONGUserClient sharedInstance] storeDevicePushTokenInSession:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (self.mobileAuthenticationController)
        return;

    self.mobileAuthenticationController = [MobileAuthenticationController
        mobileAuthentiactionControllerWithNaviationController:(UINavigationController *)self.window.rootViewController
                                                   completion:^{
                                                       self.mobileAuthenticationController = nil;
                                                   }];

    // todo: anyway code above will be rewritten. Do not delete comment below :)

    // Developer needs to be aware that push notifications sometime can be delivered nearly simultaneously.
    // Therefore it is not recommended to share single delegate for all of the incoming mobile authentication requests,
    // since previous request may be in the middle of authentication process (i.e. not finished).
    [[ONGUserClient sharedInstance] handleMobileAuthenticationRequest:userInfo delegate:self.mobileAuthenticationController];
}

@end
