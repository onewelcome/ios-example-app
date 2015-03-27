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
	
	// Load customization from a JSON config file and apply it.
	NSString *path = [[NSBundle mainBundle] pathForResource:@"pin-config" ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:path];
	NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	[pinViewController applyConfig:config];
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
