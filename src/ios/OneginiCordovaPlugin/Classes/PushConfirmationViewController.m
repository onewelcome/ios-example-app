//
//  PushConfirmationViewController.m
//  OneginiCordovaPlugin
//
//  Created by Stanisław Brzeski on 27/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "PushConfirmationViewController.h"
#import "MessagesModel.h"

@interface PushConfirmationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, copy) PushAuthenticationConfirmation confirmationBlock;
@property (nonatomic) NSString *message;

@end

@implementation PushConfirmationViewController

-(instancetype)initWithMessage:(NSString*)message confirmationBlock:(PushAuthenticationConfirmation)confirmationBlock NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.confirmationBlock = confirmationBlock;
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [MessagesModel messageForKey:@"PUSH_CONFIRMATION_TITLE"];
    self.messageLabel.text = self.message;
    [self.confirmButton setTitle:[MessagesModel messageForKey:@"PUSH_CONFIRMATION_CONFIRM_BUTTON"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[MessagesModel messageForKey:@"PUSH_CONFIRMATION_CANCEL_BUTTON"] forState:UIControlStateNormal];
}

-(IBAction)confirmButton:(id)sender{
    self.confirmationBlock(YES);
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)cancelButton:(id)sender {
    self.confirmationBlock(NO);
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
