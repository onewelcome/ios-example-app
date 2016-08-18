//  Copyright © 2016 Onegini. All rights reserved.

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "MobileAuthenticationController.h"

@implementation AppDelegate

+ (AppDelegate *)sharedInstance
{
    return [UIApplication sharedApplication].delegate;
}

+ (UINavigationController *)sharedNavigationController
{
    static UINavigationController *sharedNavigationController;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNavigationController = [[UINavigationController alloc] initWithRootViewController:[WelcomeViewController new]];
        sharedNavigationController.navigationBarHidden = YES;
    });
    return sharedNavigationController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = [AppDelegate sharedNavigationController];
    [self.window makeKeyAndVisible];

    [[[[ONGClientBuilder new] setUseEmbeddedWebView:YES] setStoreCookies:YES] build];

    [[ONGClientBuilder new] build];
    [[ONGClient sharedInstance] start:^(BOOL result, NSError *error) {
        if (error != nil) {
            if (ONGGenericErrorOutdatedApplication == error.code) {
                [self showAlertWithTitle:@"Application disabled" message:@"The application version is no longer valid, please visit the app store to update your application"];
            }

            if (ONGGenericErrorOutdatedOS == error.code) {
                [self showAlertWithTitle:@"OS outdated" message:@"The operating system that you use is no longer valid, please update your OS."];
            }
        }
    }];

    UIUserNotificationType supportedTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:supportedTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    [[UIApplication sharedApplication] registerForRemoteNotifications];

    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction
        actionWithTitle:@"Ok"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                }];
    [alert addAction:okButton];
    [[AppDelegate sharedNavigationController] presentViewController:alert animated:YES completion:nil];
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
    [[ONGUserClient sharedInstance] handlePushNotification:userInfo delegate:[MobileAuthenticationController sharedInstance]];
}

@end
