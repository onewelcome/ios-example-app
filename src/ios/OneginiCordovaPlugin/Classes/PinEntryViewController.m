//
//  PinEntryViewController
//

#import "PinEntryViewController.h"

@implementation PinEntryViewController {
	NSInteger currentPin;
	NSMutableArray *pinEntry;
}

@synthesize keys, pins, delegate, pinsView;

- (void)viewDidLoad {
    [super viewDidLoad];

	currentPin = 0;
	pinEntry = [NSMutableArray new];
	
	[self initView];
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

- (void)setKeyBackgroundImage:(NSString *)imagePath forState:(UIControlState)state {
	UIImage *image = [UIImage imageNamed:imagePath];
	if (image == nil) {
		image = [UIImage imageWithContentsOfFile:imagePath];
	}
	
	for (UIButton *button in keys) {
		[button setBackgroundImage:image forState:state];
	}
}

- (void)setDeleteKeyBackgroundImage:(NSString *)imagePath forState:(UIControlState)state {
	[self.backKey setBackgroundImage:[UIImage imageNamed:imagePath] forState:state];
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
	[self updatePinStateRepresentation];
	
	if (pinEntry.count == pins.count) {
		[delegate pinEntered:self pin:[pinEntry componentsJoinedByString:@""]];
	}
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
	[self updatePinStateRepresentation];
}

@end