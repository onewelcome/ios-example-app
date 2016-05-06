//
//  PINViewController.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "PINViewController.h"
#import "PINEntryView.h"

@interface PINViewController ()



@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@property (nonatomic, weak) IBOutlet UIView *pinEntryPlaceholder;
@property (nonatomic, strong) PINEntryView *pinEntryView;
@property (nonatomic, weak) IBOutlet UIButton *removeDigitButton;

@property (nonatomic, strong) NSString *currentPIN;

@end

@implementation PINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPIN = @"";
    if (self.title.length > 0) {
        self.headerLabel.text = self.title;
    }
    
    self.pinEntryView = [[PINEntryView alloc] initWithPINlength:5 andFrame:CGRectMake(0, 0, self.pinEntryPlaceholder.frame.size.width, self.pinEntryPlaceholder.frame.size.height)];
    [self.pinEntryPlaceholder addSubview:self.pinEntryView];

}

- (void)showError:(NSError *)error {
    NSLog(@"Show error: %@", error.localizedDescription);
}

- (void)wrongPINRemainigAttempts:(NSUInteger)remaining {
    self.messageLabel.text = [NSString stringWithFormat:@"Wrong PIN. Attempt(s) left: %@", @(remaining)];
    self.currentPIN = @"";
}

#pragma mark -

- (IBAction)didTapOnNumber:(UIButton *)sender {
    NSInteger enteredDigit = sender.tag;
    [self proceedEnteredDigit:enteredDigit];
}

- (IBAction)didTapOnBackButton:(id)sender {
    [self proceedRemovedDigit];
}

#pragma mark -

- (void)proceedEnteredDigit:(NSInteger)digit {
    BOOL shouldProceedEnteredDigit = self.currentPIN.length < self.maxCountOfNumbers;
    if (!shouldProceedEnteredDigit) {
        return;
    }
    
    self.currentPIN = [self.currentPIN stringByAppendingString:@(digit).description];
    
    if (self.currentPIN.length == self.maxCountOfNumbers) {
        [self.delegate pinViewController:self didEnterPIN:self.currentPIN];
    }
}

- (void)proceedRemovedDigit {
    BOOL shouldProceedRemovedDigit = self.currentPIN.length > 0;
    if (!shouldProceedRemovedDigit) {
        return;
    }
    
    self.currentPIN = [self.currentPIN substringToIndex:self.currentPIN.length - 1];
}

- (void)setCurrentPIN:(NSString *)currentPIN {
    _currentPIN = currentPIN;
    
    [self didChangePIN];
}

- (void)didChangePIN {
    BOOL shouldHide = self.currentPIN.length == 0;
    self.removeDigitButton.hidden = shouldHide;
    
    [self.pinEntryView updateWithCurrentPinLength:self.currentPIN.length];
}

@end
