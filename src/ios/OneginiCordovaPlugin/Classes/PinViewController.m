//
//  PinViewController.m
//  OneginiCordovaPlugin
//
//  Created by Stanisław Brzeski on 19/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "PinViewController.h"

@interface PinViewController()

@property (nonatomic) NSInteger currentPin;
@property (nonatomic) NSArray *pins;
@property (nonatomic) NSArray *pinSlots;
@property (nonatomic) NSMutableArray *pinEntry;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

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

@implementation PinViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.pinEntry = [NSMutableArray new];
}

-(void)invalidPin {
    
}

-(void)invalidPinWithReason:(NSString *)message {
    self.errorLabel.text = message;
}

-(NSArray *)pins {
    if (_pins==nil)
        _pins = @[self.pin1, self.pin2, self.pin3, self.pin4, self.pin5];
    return _pins;
}

-(NSArray *)pinSlots {
    if (_pinSlots == nil)
        _pinSlots = @[self.pinSlot1, self.pinSlot2, self.pinSlot3, self.pinSlot4, self.pinSlot5];
    return _pinSlots;
}

-(void)setMode:(PINEntryModes)mode {
    _mode = mode;
    switch (mode) {
        case PINCheckMode:
            self.titleLabel.text = [self.messages objectForKey:@"LOGIN_PIN_KEYBOARD_TITLE"];
            break;
        case PINRegistrationMode:
            self.titleLabel.text = [self.messages objectForKey:@"CREATE_PIN_SCREEN_TITLE"];
            break;
        case PINRegistrationVerififyMode:
            self.titleLabel.text = [self.messages objectForKey:@"CONFIRM_PIN_SCREEN_TITLE"];
            break;
        case PINChangeCheckMode:
            self.titleLabel.text = [self.messages objectForKey:@"LOGIN_BEFORE_CHANGE_PIN_SCREEN_TITLE"];
            break;
        case PINChangeNewPinMode:
            self.titleLabel.text = [self.messages objectForKey:@"CHANGE_PIN_SCREEN_TITLE"];
            break;
        case PINChangeNewPinVerifyMode:
            self.titleLabel.text = [self.messages objectForKey:@"CONFIRM_CHANGE_PIN_SCREEN_TITLE"];
            break;
        default:
            break;
    }
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
        [self.delegate pinEntered:[self.pinEntry componentsJoinedByString:@""]];
    }
}

-(void)reset{
    for (int i = 0; i < self.pinEntry.count; i++) {
        self.pinEntry[i] = @"#";
    }
    self.pinEntry = [NSMutableArray new];
    self.currentPin = 0;
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

- (void)resetPin {
    for (int i = 0; i < self.pinEntry.count; i++) {
        self.pinEntry[i] = @"#";
    }
    self.pinEntry = [NSMutableArray new];
    self.currentPin = 0;
}

@end
