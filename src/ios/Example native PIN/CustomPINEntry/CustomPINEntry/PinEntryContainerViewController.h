//
//  PinEntryContainerViewController.h
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinEntryViewController.h"

/**
 This view provides the container for the PIN entry component. The PIN entry component will only be capturing 
 the user input. This container provides other user interaction components like result message dialogs and 
 help screens.
 */
 
@interface PinEntryContainerViewController : UIViewController <PinEntryViewControllerDelegate>

@property (strong, nonatomic) PinEntryViewController *pinEntryViewController;
@property (weak, nonatomic) IBOutlet UIView *pinViewPlaceholder;

@end
