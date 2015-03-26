//
//  ChangePinViewController.h
//  oneginisdkiostestapp
//
//  Created by Eduard on 23-01-15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol PinEntryViewControllerDelegate <NSObject>

- (void)confirmPin:(NSString *)pin;
- (void)confirmNewPin:(NSString *)pin;
- (void)validateNewPin:(NSString *)pin;

- (void)confirmPinForChangeRequest:(NSString *)pin;
- (void)validateNewPinForChangeRequest:(NSString *)pin;
- (void)confirmNewPinForChangeRequest:(NSString *)pin;

@end

typedef enum : NSUInteger {
	PINCheckMode,
	PINRegistrationMode,
	PINRegistrationVerififyMode,
	PINChangeCheckMode,
	PINChangeNewPinMode,
	PINChangeNewPinVerifyMode
} PINEntryModes;

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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keys;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *pins;

- (void)setKeyBackgroundImage:(NSString *)imageName forState:(UIControlState)state;

/**
 Set the initial PIN entry mode.
 
 @param mode
 */
- (void)setMode:(PINEntryModes)mode;

/**
 Reset the PIN entry
 
 @param message
 @param subMessage
 */
- (void)invalidPin;

@end
