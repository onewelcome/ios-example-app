//  Copyright © 2016 Onegini. All rights reserved.

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "MobileAuthenticationController.h"
#import "ONGClientBuilder.h"

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

    UIUserNotificationType supportedTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:supportedTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    [[UIApplication sharedApplication] registerForRemoteNotifications];

    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[ONGUserClient sharedInstance] storeDevicePushTokenInSession:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[ONGUserClient sharedInstance] storeDevicePushTokenInSession:nil];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[ONGUserClient sharedInstance] handlePushNotification:userInfo delegate:[MobileAuthenticationController sharedInstance]];
}

@end
