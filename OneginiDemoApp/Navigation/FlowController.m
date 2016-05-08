//
//  FlowController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 07/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "FlowController.h"
#import <SafariServices/SafariServices.h>
#import "WelcomeViewController.h"
#import "ProfileViewController.h"
#import "OGPublicCommons.h"
#import "WebBrowserViewController.h"
#import "PinViewController.h"

@interface FlowController()

@end

@implementation FlowController

+ (FlowController *)sharedInstance {
    static FlowController *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
        singleton.navigationCOntroller = [[UINavigationController alloc]initWithRootViewController:[WelcomeViewController new]];
        singleton.navigationCOntroller.navigationBarHidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(closeSafari) name:OGCloseWebViewNotification object:nil];
    });
    return singleton;
}

-(void)closeSafari{
    if ([self.navigationCOntroller.presentedViewController isKindOfClass:WebBrowserViewController.class]){
        [self.navigationCOntroller dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)authorizationSucceded{
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationCOntroller pushViewController:viewController animated:YES];
}

-(void)logout{
    [self.navigationCOntroller popToRootViewControllerAnimated:YES];
}

-(void)wrongPinEnteredRemaining:(NSInteger)remaining{
    if ([self.navigationCOntroller.topViewController isKindOfClass:PinViewController.class]){
        PinViewController *pinViewController = (PinViewController*)self.navigationCOntroller.topViewController;
        [pinViewController reset];
        [pinViewController showError:[NSString stringWithFormat:@"Wrong Pin. Remaining attempts: %ld",remaining]];
    }
}

-(void)createPinWithSize:(NSInteger)size completion:(void (^)(NSString *))completion{
    PinViewController *viewController = [PinViewController new];
    viewController.pinEntered = completion;
    viewController.pinLength = size;
    viewController.mode = PINRegistrationMode;
    [self.navigationCOntroller pushViewController:viewController animated:YES];
}

-(void)disconnect{
    [self.navigationCOntroller popToRootViewControllerAnimated:YES ];
}

-(void)authenticationFailedWithError{
    [self.navigationCOntroller popToRootViewControllerAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authorization Error" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action){}];
    [alert addAction:okButton];
    [self.navigationCOntroller presentViewController:alert animated:YES completion:nil];
}

-(void)pinPolicyValidationFailed{
    if ([self.navigationCOntroller.topViewController isKindOfClass:PinViewController.class]){
        PinViewController *pinViewController = (PinViewController*)self.navigationCOntroller.topViewController;
        pinViewController.mode = PINRegistrationMode;
        [pinViewController reset];
        [pinViewController showError:[NSString stringWithFormat:@"Pin doesn't conform to pin policy."]];
    }
}

-(void)askForCurrentPinCompletion:(void (^)(NSString *))completion{
    PinViewController *viewController = [PinViewController new];
    viewController.pinEntered = completion;
    viewController.pinLength = 5;
    viewController.mode = PINCheckMode;
    [self.navigationCOntroller pushViewController:viewController animated:YES];
}


-(void)openURL:(NSURL *)url{
    WebBrowserViewController *webBrowserViewController = [WebBrowserViewController new];
    webBrowserViewController.url = url;
    [self.navigationCOntroller presentViewController:webBrowserViewController animated:YES completion:nil];
}

@end
