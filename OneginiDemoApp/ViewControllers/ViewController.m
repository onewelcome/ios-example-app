//
//  ViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ViewController.h"

#import <SafariServices/SafariServices.h>

#import "AuthCoordinator.h"

@interface ViewController () <AuthCoordinatorDelegate>

@property (nonatomic, strong) AuthCoordinator *authCoordinator;

@property (nonatomic, weak) UIViewController *loginViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.authCoordinator = [AuthCoordinator new];
    self.authCoordinator.delegate = self;
}

#pragma mark - 

- (IBAction)login:(id)sender {
    [self.authCoordinator login];
}

#pragma mark - AuthCoordinatorDelegate

- (void)authCoordinator:(AuthCoordinator *)coordinator didStartLoginWithURL:(NSURL *)url {
    NSLog(@"Start login");
    
    UIViewController *viewController = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:viewController animated:YES completion:NULL];
    
    self.loginViewController = viewController;
}

- (void)authCoordinatorDidFinishLogin:(AuthCoordinator *)coordinator {
    NSLog(@"Finish login");
    
    [self.loginViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)authCoordinator:(AuthCoordinator *)coordinator didFailLoginWithError:(NSError *)error {
    NSLog(@"Login error: %@", error.localizedDescription);
}

- (void)authCoordinatorDidAskForCurrentPIN:(AuthCoordinator *)coordinator {
    [self.authCoordinator enterCurrentPIN:@"11111"];
}

- (void)authCoordinator:(AuthCoordinator *)coordinator presentCreatePINWithMaxCountOfNumbers:(NSInteger)countNumbers {
    NSLog(@"Present view to enter pin");
    [self.authCoordinator setNewPin:@"11111"];
}

- (void)authCoordinatorDidFinishPINEnrollment:(AuthCoordinator *)coordinator {
    NSLog(@"Finish PIN enrollment");
}

- (void)authCoordinator:(AuthCoordinator *)coordinator didFailPINEnrollmentWithError:(NSError *)error {
    NSLog(@"PIN enrollment error: %@)", error.localizedDescription);
}

@end
