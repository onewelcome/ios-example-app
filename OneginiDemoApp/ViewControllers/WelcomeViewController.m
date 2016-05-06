//
//  WelcomeViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 3/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "WelcomeViewController.h"

@implementation WelcomeViewController

- (IBAction)login:(id)sender {
    [self.delegate welcomeViewControllerDidTapLogin:self];
}

@end
