//
//  PinEntryContainerViewController.m
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import "PinEntryContainerViewController.h"

NSString *kBackgoundImage = @"backgoundImage";
NSString *kKeyColor = @"keyColor";

@implementation PinEntryContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.pinEntryViewController = [[PinEntryViewController alloc] initWithNibName:@"PinEntryViewController" bundle:nil];
	[self.pinViewPlaceholder addSubview:self.pinEntryViewController.view];
	self.pinEntryViewController.delegate = self;
}

#pragma mark -
#pragma mark PinEntryViewControllerDelegate

- (void)pinEntered:(PinEntryViewController *)controller pin:(NSString *)pin {
	[self.delegate pinEntered:self pin:pin];
}

#pragma mark -
#pragma mark Customization

- (void)applyConfig:(NSDictionary *)config {
	NSString *value = config[kBackgoundImage];
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