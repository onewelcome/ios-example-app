//
//  PinEntryContainerViewController.m
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import "PinEntryContainerViewController.h"

NSString *kBackgoundImage					= @"backgoundImage";
NSString *kKeyColor							= @"pinKeyColor";
NSString *kKeyNormalStateImage				= @"pinKeyNormalStateImage";
NSString *kKeyHighlightedStateImage			= @"pinKeyHighlightedStateImage";
NSString *kDeleteKeyNormalStateImage		= @"pinDeleteKeyNormalStateImage";
NSString *kDeleteKeyHighlightedStateImage	= @"pinDeleteKeyHighlightedStateImage";
NSString *kPinKeyFontName					= @"pinKeyFontName";
NSString *kPinKeyFontSize					= @"pinKeyFontSize";

@implementation PinEntryContainerViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.pinEntryViewController = [[PinEntryViewController alloc] initWithNibName:@"PinEntryViewController" bundle:nil];
	[self.pinViewPlaceholder addSubview:self.pinEntryViewController.view];
	self.pinEntryViewController.delegate = self;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self applyBackgroundImage];
	[self adjustMessageLabel];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self applyBackgroundImage];
	[self adjustMessageLabel];
}

- (void)applyBackgroundImage {
	NSDictionary *config = [self orientationBasedConfig];
	
	if (config == nil) {
		return;
	}
	
	NSString *backgroundImageName = config[@"backgroundImage"];
	if (backgroundImageName != nil) {
		UIImage *image = [UIImage imageNamed:backgroundImageName];
		if (image == nil) {
			image = [UIImage imageWithContentsOfFile:backgroundImageName];
		}
		
		self.containerBackgroundImage.image = image;
	}
}

- (void)adjustMessageLabel {
	NSDictionary *config = [self orientationBasedConfig];
	
	if (config == nil) {
		return;
	}
	
	NSDictionary *validationMessageConfig = config[@"validationMessage"];
	NSArray *frameArray = validationMessageConfig[@"frame"];
	if (frameArray != nil && frameArray.count == 4) {
		self.messageLabelLeftConstraint.constant = [(NSNumber *)frameArray[0] floatValue];
		self.messageLabelTopConstraint.constant = [(NSNumber *)frameArray[1] floatValue];
		self.messageLabelWidthConstraint.constant = [(NSNumber *)frameArray[2] floatValue];
		self.messageLabelHeightConstraint.constant = [(NSNumber *)frameArray[3] floatValue];
	}
	
	NSNumber *fontSize = validationMessageConfig[@"fontSize"];
	if (fontSize != nil) {
		NSString *fontName = validationMessageConfig[@"fontName"];
		UIFont *font = fontName == nil ? [UIFont systemFontOfSize:fontSize.floatValue] : [UIFont fontWithName:fontName size:fontSize.floatValue];
		if (font != nil) {
			self.messageLabel.font = font;
		}
	}
	
	self.messageLabel.textColor = [self colorWithHexString:validationMessageConfig[@"textColor"]];
	self.messageLabel.backgroundColor =[UIColor colorWithWhite:0.9 alpha:1.0];
}

- (NSDictionary *)orientationBasedConfig {
	BOOL isLandscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
	return isLandscape ? self.landscapeConfig : self.portraitConfig;
}

- (void)reset {
	[self.pinEntryViewController reset];
}

- (void)invalidPin {
	[self.pinEntryViewController invalidPin];
}

- (void)invalidPinWithReason:(NSString *)message subMessage:(NSString *)subMessage {
	self.messageLabel.text = message;
	
	[self.pinEntryViewController invalidPin];
}

#pragma mark -
#pragma mark PinEntryViewControllerDelegate

- (void)pinEntered:(PinEntryViewController *)controller pin:(NSString *)pin {
	[self.delegate pinEntered:self pin:pin];
}

#pragma mark -
#pragma mark Customization

- (void)applyConfig:(NSDictionary *)config {
	NSDictionary *idiomConfig = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [config valueForKeyPath:@"ios.ipad"] : [config valueForKeyPath:@"ios.iphone"];
	
	self.landscapeConfig = idiomConfig[@"landscape"];
	self.portraitConfig = idiomConfig[@"portrait"];
	
	NSString *value = config[kKeyColor];
	if (value != nil) {
		UIColor *color = [self colorWithHexString:value];
		[self.pinEntryViewController setKeyColor:color forState:UIControlStateNormal];
	}
	
	value = config[kKeyNormalStateImage];
	if (value != nil) {
		[self.pinEntryViewController setKeyBackgroundImage:value forState:UIControlStateNormal];
	}
	
	value = config[kKeyHighlightedStateImage];
	if (value != nil) {
		[self.pinEntryViewController setKeyBackgroundImage:value forState:UIControlStateHighlighted];
	}
	
	value = config[kDeleteKeyNormalStateImage];
	if (value != nil) {
		[self.pinEntryViewController setDeleteKeyBackgroundImage:value forState:UIControlStateNormal];
	}
	
	value = config[kDeleteKeyHighlightedStateImage];
	if (value != nil) {
		[self.pinEntryViewController setDeleteKeyBackgroundImage:value forState:UIControlStateHighlighted];
	}
	
	NSNumber *numberValue = config[kPinKeyFontSize];
	if (numberValue != nil) {
		NSString *fontName = config[kPinKeyFontName];
		UIFont *font = fontName == nil ? [UIFont systemFontOfSize:numberValue.floatValue] : [UIFont fontWithName:fontName size:numberValue.floatValue];
		[self.pinEntryViewController setKeyFont:font];
	}
	
	[self applyBackgroundImage];
	[self adjustMessageLabel];
}

#pragma mark -
#pragma mark Util
// TODO move category on UIColor
- (UIColor *) colorWithHexString: (NSString *)stringToConvert {
	if (stringToConvert == nil || stringToConvert.length == 0) {
		return [UIColor blackColor];
	}
	
	NSString *string = stringToConvert;
	if ([string hasPrefix:@"#"]) {
		string = [string substringFromIndex:1];
	}
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	unsigned hexNum;
	if (![scanner scanHexInt: &hexNum]) {
		return nil;
	}
	
	int r = (hexNum >> 16) & 0xFF;
	int g = (hexNum >> 8) & 0xFF;
	int b = (hexNum) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

@end