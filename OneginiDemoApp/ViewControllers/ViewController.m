//
//  ViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "ViewController.h"

#import "OneginiClientBuilder.h"
#import "AuthorizationService.h"

@interface ViewController ()

@property (nonatomic, strong) AuthorizationService *authService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    OGOneginiClient *client = [OneginiClientBuilder buildClient];
    self.authService = [[AuthorizationService alloc] initWithClient:client];
}

- (IBAction)login:(id)sender {
    [self.authService login];
}

@end
