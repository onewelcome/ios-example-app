//
//  PinEntryViewController
//

#import "PinEntryViewController.h"

@implementation PinEntryViewController {
	NSInteger currentPin;
	NSMutableArray *pinEntry;
}

@synthesize keys, delegate, pinsView;

-(NSArray *)pins{
    if (_pins==nil)
        _pins = @[self.pin1, self.pin2, self.pin3, self.pin4, self.pin5];
    return _pins;
}

-(NSArray *)pinSlots{
    if (_pinSlots == nil)
        _pinSlots = @[self.pinSlot1, self.pinSlot2, self.pinSlot3, self.pinSlot4, self.pinSlot5];
    return _pinSlots;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	currentPin = 0;
	pinEntry = [NSMutableArray new];
    
    self.backKey.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:126.0/255.0 blue:60.0/255.0 alpha:1];
	
	[self initView];
    
    ((UIImageView*)self.pinSlots.firstObject).image = [UIImage imageNamed:@"iphone-pinslot-selected"];
}

-(void)viewDidLayoutSubviews{
    if (self.keyboardImageView.frame.size.width >320)
        self.keyboardImageView.image = [UIImage imageNamed:@"iphone-keyboard@3x.png"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self updatePinStateRepresentation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self resetPin];
}

- (IBAction)onBackKeyClicked:(id)sender {
	[pinEntry removeLastObject];
	
	[self updatePinStateRepresentation];
}

- (void)setKeyFont:(UIFont *)font {
	if (font == nil) {
		return;
	}
	
	for (UIButton *button in keys) {
		[button.titleLabel setFont:font];
	}
}

- (void)setKeyColor:(UIColor *)color forState:(UIControlState)state {
	for (UIButton *button in keys) {
		[button setTitleColor:color forState:state];
	}
}

- (void)initView {
	for (UIButton *key in keys) {
		[key addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)keyPressed:(UIButton *)key {
	if (pinEntry == nil) {
		pinEntry = [NSMutableArray new];
	}
	
	if (pinEntry.count >= self.pins.count) {
#ifdef DEBUG
		NSLog(@"max entries PIN reached");
#endif
		return;
	}
	
	[pinEntry addObject:[NSString stringWithFormat:@"%ld",(long)key.tag]];

	[self evaluatePinState];
}

- (void)invalidPin {
	[self reset];
}

-(void)shakePinAnimation{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(CGRectGetMidX(pinsView.frame) - 5.0, CGRectGetMidY(pinsView.frame))]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(CGRectGetMidX(pinsView.frame) + 5.0, CGRectGetMidY(pinsView.frame))]];
    [pinsView.layer addAnimation:shake forKey:@"position"];
}

- (void)evaluatePinState {
	[self updatePinStateRepresentation];
	
	if (pinEntry.count == self.pins.count) {
		[delegate pinEntered:self pin:[pinEntry componentsJoinedByString:@""]];
	}
}

- (void)updatePinStateRepresentation {
	for (int i = 0; i < self.pins.count; i++) {
		UIView *pin = self.pins[i];
		[UIView animateWithDuration:0.2 animations:^{
			pin.alpha = i < pinEntry.count ? 1.0 : 0.0;
		}];
	}
    for (UIImageView* pinslot in self.pinSlots) {
        pinslot.image = [UIImage imageNamed:@"iphone-pinslot"];
    }
    if (pinEntry.count<self.pinSlots.count){
        ((UIImageView*)[self.pinSlots objectAtIndex:pinEntry.count]).image = [UIImage imageNamed:@"iphone-pinslot-selected"];
    }
    
    if (pinEntry.count == 0){
        self.backKey.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:126.0/255.0 blue:60.0/255.0 alpha:1];
        self.backKey.enabled = NO;
    }
    else{
        self.backKey.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:126.0/255.0 blue:60.0/255.0 alpha:0];
        self.backKey.enabled = YES;
    }
}

- (void)resetPin {
	for (int i = 0; i < pinEntry.count; i++) {
		pinEntry[i] = @"#";
	}
	
	pinEntry = [NSMutableArray new];
	currentPin = 0;
}

- (void)reset {
	[self resetPin];
	[self updatePinStateRepresentation];
}

@end