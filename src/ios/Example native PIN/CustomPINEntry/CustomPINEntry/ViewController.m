//
//  ViewController.m
//  CustomPINEntry
//
//  Created by Eduard on 26/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import "ViewController.h"
#import "PinEntryContainerViewController.h"

@implementation ViewController

@synthesize pinViewController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	pinViewController = [[PinEntryContainerViewController alloc] initWithNibName:@"PinEntryContainerViewController" bundle:nil];
	[self.view addSubview:pinViewController.view];
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

- (IBAction)invalidPinAction:(id)sender {
	//[pinViewController invalidPin];
}

@end
