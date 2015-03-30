//
//  PinEntryContainerViewController.h
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinEntryViewController.h"

@class PinEntryContainerViewController;

@protocol PinEntryContainerViewControllerDelegate <NSObject>
- (void)pinEntered:(PinEntryContainerViewController *)controller pin:(NSString *)pin;
@end

/*
 Customization keys
 */

/** Full size backgound image */
extern NSString *kBackgoundImage;
extern NSString *kKeyColor;

@interface PinEntryContainerViewController : UIViewController <PinEntryViewControllerDelegate>

@property (assign, nonatomic) id <PinEntryContainerViewControllerDelegate> delegate;
@property (strong, nonatomic) PinEntryViewController *pinEntryViewController;
@property (weak, nonatomic) IBOutlet UIView *pinViewPlaceholder;
@property (weak, nonatomic) IBOutlet UIImageView *containerBackgroundImage;

/**
 Apply custom style 
 
 @param config
 */
- (void)applyConfig:(NSDictionary *)config;

@end
