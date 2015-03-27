//
//  PinEntryContainerViewController.m
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import "PinEntryContainerViewController.h"

@interface PinEntryContainerViewController ()
@end

@implementation PinEntryContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.pinEntryViewController = [[PinEntryViewController alloc] initWithNibName:@"PinEntryViewController" bundle:nil];
	[self.pinViewPlaceholder addSubview:self.pinEntryViewController.view];
}

- (void)pinEntered:(PinEntryViewController *)controller pin:(NSString *)pin {
	
}

@end
