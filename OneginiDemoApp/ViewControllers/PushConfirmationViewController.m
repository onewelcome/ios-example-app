//
//  PushConfirmationViewController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 15/06/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "PushConfirmationViewController.h"

@interface PushConfirmationViewController()

@property (weak, nonatomic) IBOutlet UIButton *pushConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *pushDenyButton;

@end

@implementation PushConfirmationViewController

- (IBAction)confirmPush:(id)sender {
    self.pushConfirmed(YES);
}

- (IBAction)denyPush:(id)sender {
    self.pushConfirmed(NO);
}

@end
