//
//  PinEntryContainerViewController.h
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinEntryViewController.h"
#import "Commons.h"

@class PinEntryContainerViewController;

@protocol PinEntryContainerViewControllerDelegate <NSObject>
- (void)pinEntered:(PinEntryContainerViewController *)controller pin:(NSString *)pin;
@end

/*
 Customization keys
 */

/** Full size backgound image */
extern NSString *kBackgoundImage;

/** PIN key text color */
extern NSString *kKeyColor;

/** PIN key background image for the normal (untouched) state */
extern NSString *kKeyNormalStateImage;

/** PIN key background image for the highlighted (touched) state */
extern NSString *kKeyHighlightedStateImage;

/** Delete PIN key background image for the normal (untouched) state */
extern NSString *kDeleteKeyNormalStateImage;

/** Delete PIN key background image for the highlighted (touched) state */
extern NSString *kDeleteKeyHighlightedStateImage;

@interface PinEntryContainerViewController : UIViewController <PinEntryViewControllerDelegate>

@property (assign, nonatomic) id <PinEntryContainerViewControllerDelegate> delegate;
@property (strong, nonatomic) PinEntryViewController *pinEntryViewController;
@property (weak, nonatomic) IBOutlet UIView *pinViewPlaceholder;
@property (weak, nonatomic) IBOutlet UIImageView *containerBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) NSDictionary *landscapeConfig;
@property (strong, nonatomic) NSDictionary *portraitConfig;

@property (nonatomic) NSUInteger supportedOrientations;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelHeightConstraint;

@property (nonatomic) PINEntryModes mode;
@property (nonatomic) NSDictionary* messages;

/**
 Apply custom style 
 
 @param config
 */
- (void)applyConfig:(NSDictionary *)config;

/**
 Reset the PIN value and representation
 */
- (void)reset;

/**
 Performs a reset and a custom animation similar to the iOS lock screen PIN entry
 */
- (void)invalidPin;

- (void)invalidPinWithReason:(NSString *)message;

- (void)setMessage:(NSString *)message;

- (void)setSupportedInterfaceOrientations;

@end
