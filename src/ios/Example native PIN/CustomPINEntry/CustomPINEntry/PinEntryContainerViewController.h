//
//  PinEntryContainerViewController.h
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinEntryViewController.h"

/*
 Customization keys
 */

/** Full size backgound image */
extern NSString *kBackgoundImage;
extern NSString *kKeyColor;

/**
 This view provides the container for the PIN entry component. The PIN entry component will only be capturing 
 the user input. This container maintains state and provides other user interaction components like result message dialogs and
 help screens. The visual representation has limited customization properties.
 */
 
@interface PinEntryContainerViewController : UIViewController <PinEntryViewControllerDelegate>

@property (strong, nonatomic) PinEntryViewController *pinEntryViewController;
@property (weak, nonatomic) IBOutlet UIView *pinViewPlaceholder;
@property (weak, nonatomic) IBOutlet UIImageView *containerBackgroundImage;

/**
 Apply custom style 
 
 @param config
 */
- (void)applyConfig:(NSDictionary *)config;
@end
