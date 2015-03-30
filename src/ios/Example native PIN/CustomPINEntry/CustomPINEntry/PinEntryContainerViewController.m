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
	return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)reset {
	[self.pinEntryViewController reset];
}

- (void)invalidPin {
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
	NSDictionary *orientationConfig = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? idiomConfig[@"landscape"] : idiomConfig[@"portrait"];
	
	NSString *value = orientationConfig[kBackgoundImage];
	if (value != nil) {
		UIImage *image = [UIImage imageNamed:value];
		if (image == nil) {
			image = [UIImage imageWithContentsOfFile:value];
		}
		
		self.containerBackgroundImage.image = image;
	}
	
	value = config[kKeyColor];
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