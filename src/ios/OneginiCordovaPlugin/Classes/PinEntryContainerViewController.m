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
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self applyBackgroundImage];
}

- (void)applyBackgroundImage {
	self.containerBackgroundImage.image = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.landscapeBackgroundImage : self.portraitBackgroundImage;
}

- (void)reset {
	[self.pinEntryViewController reset];
}

- (void)invalidPin {
	[self.pinEntryViewController invalidPin];
}

- (void)invalidPinWithReason:(NSString *)message subMessage:(NSString *)subMessage {
	self.messageLabel.text = message;
	self.subMessageLabel.text = subMessage;
	
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
	
	NSDictionary *orientationConfig = idiomConfig[@"landscape"];
	if (orientationConfig != nil) {
		NSString *backgroundImageName = orientationConfig[@"backgroundImage"];
		if (backgroundImageName != nil) {
			self.landscapeBackgroundImage = [UIImage imageNamed:backgroundImageName];
			if (self.landscapeBackgroundImage == nil) {
				self.landscapeBackgroundImage = [UIImage imageWithContentsOfFile:backgroundImageName];
			}
		}
	}
	
	orientationConfig = idiomConfig[@"portrait"];
	if (orientationConfig != nil) {
		NSString *backgroundImageName = orientationConfig[@"backgroundImage"];
		if (backgroundImageName != nil) {
			self.portraitBackgroundImage = [UIImage imageNamed:backgroundImageName];
			if (self.portraitBackgroundImage == nil) {
				self.portraitBackgroundImage = [UIImage imageWithContentsOfFile:backgroundImageName];
			}
		}
	}
	
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
	
	[self applyBackgroundImage];
}

#pragma mark -
#pragma mark Util
// TODO move category on UIColor
- (UIColor *) colorWithHexString: (NSString *)stringToConvert {
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