//
//  ChangePinViewController.m
//  oneginisdkiostestapp
//

#import "PinEntryViewController.h"
#import "Util.h"

@interface PinEntryViewController ()
@end

// TODO implement dynamic pin size.
// TODO implement PIN change modes.

@implementation PinEntryViewController {
	NSInteger currentPin;
	NSMutableArray *pinEntry;
	PINEntryModes pinEntryMode;
}

@synthesize keys, pins, delegate, pinsView;

- (void)viewDidLoad {
    [super viewDidLoad];

	pinEntryMode = PINCheckMode;
	
	currentPin = 0;
	pinEntry = [NSMutableArray new];
	
	[self initView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self updatePinStateRepresentation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self reset];
}

- (void)setMode:(PINEntryModes)mode {
	[self reset];
	
	pinEntryMode = mode;
	[self evaluatePinState];
}

- (void)setKeyBackgroundImage:(NSString *)imageName forState:(UIControlState)state {
	UIImage *image = [UIImage imageNamed:imageName];
	for (UIButton *button in keys) {
		[button setBackgroundImage:image forState:state];
	}
}

- (void)initView {
	for (UIButton *key in keys) {
		[key addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (IBAction)onBackKeyClicked:(id)sender {
	[pinEntry removeLastObject];
	
	[self updatePinStateRepresentation];
}
		 
- (void)keyPressed:(UIButton *)key {
	if (pinEntry == nil) {
		pinEntry = [NSMutableArray new];
	}
	
	if (pinEntry.count >= pins.count) {
#ifdef DEBUG
		NSLog(@"max entries PIN reached");
#endif
		return;
	}
	
	[pinEntry addObject:key.titleLabel.text];

	[self evaluatePinState];
}

- (void)invalidPin {
	[self resetPin];
	
	[self updatePinStateRepresentation];
	
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
	/*
	 When the PIN is forwarded to the delegate, the PIN in this view controller is wiped. 
	 */
	NSString *pin = [pinEntry componentsJoinedByString:@""];
	BOOL forwardToNextStep = pinEntry.count == pins.count;

	if (pinEntryMode == PINCheckMode) {
		if (forwardToNextStep) {
			[delegate confirmPin:pin];
		}
	} else if (pinEntryMode == PINRegistrationMode) {
		if (forwardToNextStep) {
			[delegate validateNewPin:pin];
		}
	} else if (pinEntryMode == PINRegistrationVerififyMode) {
		if (forwardToNextStep) {
			[delegate confirmNewPin:pin];
		}
	}
	
#warning PIN Change modes not implemented
	
	[self updatePinStateRepresentation];
}

- (void)updatePinStateRepresentation {
	for (int i = 0; i < pins.count; i++) {
		UIView *pin = pins[i];
		[UIView animateWithDuration:0.2 animations:^{
			pin.alpha = i < pinEntry.count ? 1.0 : 0.0;
		}];
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
	
	pinEntryMode = PINCheckMode;
}

@end
