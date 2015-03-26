//
//  ViewController.m
//  CustomPINEntry
//
//  Created by Eduard on 26/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import "ViewController.h"
#import "PinEntryViewController.h"

@implementation ViewController

@synthesize changePinViewController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	changePinViewController = [[PinEntryViewController alloc] initWithNibName:@"PinEntryViewController" bundle:nil];
	
	[self.view addSubview:changePinViewController.view];
	changePinViewController.view.center = self.view.center;
}

- (IBAction)invalidPinAction:(id)sender {
	[changePinViewController invalidPin];
}

@end
