//
//  ViewController.m
//  CustomPINEntry
//
//  Created by Eduard on 26/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import "ViewController.h"
#import "PinEntryViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize changePinViewController;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	changePinViewController = [[PinEntryViewController alloc] initWithNibName:@"ChangePinViewController" bundle:nil];
	
	[self.view addSubview:changePinViewController.view];
	changePinViewController.view.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)invalidPinAction:(id)sender {
	[changePinViewController invalidPin];
}

@end
