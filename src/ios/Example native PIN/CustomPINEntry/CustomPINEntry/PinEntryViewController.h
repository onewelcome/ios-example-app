//
//  ChangePinViewController.h
//  oneginisdkiostestapp
//
//  Created by Eduard on 23-01-15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PinEntryViewController;

@protocol PinEntryViewControllerDelegate <NSObject>
/**
 Informs the delegate that the required number of digits is entered by the user.
 It is the responsibility of the delegate to dismiss the controller
 
 @param controller
 @param pin
 */
- (void)pinEntered:(PinEntryViewController *)controller pin:(NSString *)pin;
@end

/**
 Simple PIN entry dialog with 5 positions and custom numeric input pad.
 */
@interface PinEntryViewController : UIViewController

@property (weak, nonatomic) id <PinEntryViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *pinsView;

@property (weak, nonatomic) IBOutlet UIButton *key1;
@property (weak, nonatomic) IBOutlet UIButton *key2;
@property (weak, nonatomic) IBOutlet UIButton *key3;
@property (weak, nonatomic) IBOutlet UIButton *key4;
@property (weak, nonatomic) IBOutlet UIButton *key5;
@property (weak, nonatomic) IBOutlet UIButton *key6;
@property (weak, nonatomic) IBOutlet UIButton *key7;
@property (weak, nonatomic) IBOutlet UIButton *key8;
@property (weak, nonatomic) IBOutlet UIButton *key9;
@property (weak, nonatomic) IBOutlet UIButton *key0;
@property (weak, nonatomic) IBOutlet UIButton *backKey;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keys;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *pins;

- (void)setKeyBackgroundImage:(NSString *)imageName forState:(UIControlState)state;
- (void)setKeyColor:(UIColor *)color forState:(UIControlState)state;

/**
 Reset the PIN entry
 
 @param message
 @param subMessage
 */
- (void)invalidPin;

@end
