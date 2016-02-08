//
//  PushWithPinConfirmationViewController.m
//  OneginiCordovaPlugin
//
//  Created by Stanisław Brzeski on 27/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "PushWithPinConfirmationViewController.h"
#import "MessagesModel.h"

@interface PushWithPinConfirmationViewController ()

@property (nonatomic, copy) PushAuthenticationWithPinConfirmation confirmationBlock;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic) NSString* message;
@property (nonatomic) NSUInteger retryAttempts;
@property (nonatomic) NSUInteger maxAttempts;

@property (nonatomic) NSArray *pins;
@property (nonatomic) NSArray *pinSlots;
@property (nonatomic) NSMutableArray *pinEntry;

@property (weak, nonatomic) IBOutlet UIButton *key1;
@property (weak, nonatomic) IBOutlet UIButton *key2;
@property (weak, nonatomic) IBOutlet UIButton *key3;
@property (weak, nonatomic) IBOutlet UIButton *key4;
@property (weak, nonatomic) IBOutlet UIButton *key5;
@property (weak, nonatomic) IBOutlet UIButton *key6;
@property (weak, nonatomic) IBOutlet UIButton *key7;
@property (weak, nonatomic) IBOutlet UIButton *key8;
@property (weak, nonatomic) IBOutlet UIButton *key9;
@property (weak, nonatomic) IBOutlet UIButton *key0;
@property (weak, nonatomic) IBOutlet UIButton *backKey;

@property (weak, nonatomic) IBOutlet UIImageView *pinSlot1;
@property (weak, nonatomic) IBOutlet UIImageView *pinSlot2;
@property (weak, nonatomic) IBOutlet UIImageView *pinSlot3;
@property (weak, nonatomic) IBOutlet UIImageView *pinSlot4;
@property (weak, nonatomic) IBOutlet UIImageView *pinSlot5;
@property (weak, nonatomic) IBOutlet UIImageView *pin1;
@property (weak, nonatomic) IBOutlet UIImageView *pin2;
@property (weak, nonatomic) IBOutlet UIImageView *pin3;
@property (weak, nonatomic) IBOutlet UIImageView *pin4;
@property (weak, nonatomic) IBOutlet UIImageView *pin5;

@end

@implementation PushWithPinConfirmationViewController

-(instancetype)initWithMessage:(NSString *)message retryAttempts:(NSUInteger)retryAttempts maxAttempts:(NSUInteger)maxAttempts confirmationBlock:(PushAuthenticationWithPinConfirmation)confirmationBlock NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.confirmationBlock = confirmationBlock;
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [MessagesModel messageForKey:@"PUSH_CONFIRMATION_WITHPIN_TITLE"];
    self.messageLabel.text = self.message;
    [self.cancelButton setTitle:[MessagesModel messageForKey:@"PUSH_CONFIRMATION_CANCEL_BUTTON"] forState:UIControlStateNormal];
    
    NSString *errorMessage = [MessagesModel messageForKey:@"PUSH_CONFIRMATION_WITHPIN_INVALID_PIN"];
    errorMessage = [NSString stringWithFormat:@"%@ %lu", self.message, self.maxAttempts-self.retryAttempts];
    self.errorLabel.text = errorMessage;
    self.errorLabel.hidden = self.retryAttempts==0;
}

- (IBAction)cancelButton:(id)sender {
    self.confirmationBlock(nil,NO,NO);
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(NSArray *)pins {
    if (_pins ==nil)
        _pins = @[self.pin1, self.pin2, self.pin3, self.pin4, self.pin5];
    return _pins;
}

-(NSArray *)pinSlots {
    if (_pinSlots == nil)
        _pinSlots = @[self.pinSlot1, self.pinSlot2, self.pinSlot3, self.pinSlot4, self.pinSlot5];
    return _pinSlots;
}

- (IBAction)keyPressed:(UIButton *)key {
    if (self.pinEntry == nil) {
        self.pinEntry = [NSMutableArray new];
    }
    
    if (self.pinEntry.count >= self.pins.count) {
#ifdef DEBUG
        NSLog(@"max entries PIN reached");
#endif
        return;
    }
    
    [self.pinEntry addObject:[NSString stringWithFormat:@"%ld",(long)key.tag]];
    
    [self evaluatePinState];
}

- (IBAction)backKeyPressed:(id)sender {
    [self.pinEntry removeLastObject];
    [self updatePinStateRepresentation];
}

- (void)evaluatePinState {
    [self updatePinStateRepresentation];
    
    if (self.pinEntry.count == self.pins.count) {
        NSString* pin = [self.pinEntry componentsJoinedByString:@""];
        self.confirmationBlock(pin,YES,YES);
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)reset {
    for (int i = 0; i < self.pinEntry.count; i++) {
        self.pinEntry[i] = @"#";
    }
    self.pinEntry = [NSMutableArray new];
   	[self updatePinStateRepresentation];
}

-(void)updatePinStateRepresentation {
    for (int i = 0; i < self.pins.count; i++) {
        UIView *pin = self.pins[i];
        [UIView animateWithDuration:0.2 animations:^{
            pin.alpha = i < self.pinEntry.count ? 1.0 : 0.0;
        }];
    }
    for (UIImageView* pinslot in self.pinSlots) {
        pinslot.image = [UIImage imageNamed:@"iphone-pinslot"];
    }
    if (self.pinEntry.count<self.pinSlots.count){
        ((UIImageView*)[self.pinSlots objectAtIndex:self.pinEntry.count]).image = [UIImage imageNamed:@"iphone-pinslot-selected"];
    }
    
    if (self.pinEntry.count == 0){
        self.backKey.alpha = 0;
        self.backKey.enabled = NO;
    }
    else{
        self.backKey.alpha = 1;
        self.backKey.enabled = YES;
    }
}

@end
