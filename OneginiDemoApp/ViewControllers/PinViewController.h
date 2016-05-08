//
//  PinViewController.h
//  Onegini
//
//  Created by Stanisław Brzeski on 19/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PINCheckMode,					// Ask current PIN
    PINRegistrationMode,			// Ask new PIN first entry
    PINRegistrationVerififyMode,	// Ask new PIN second entry (verification)
} PINEntryMode;

@interface PinViewController : UIViewController

@property (nonatomic) PINEntryMode mode;
@property (nonatomic, copy) void (^pinEntered)(NSString* pin);
@property (nonatomic) NSInteger pinLength;

- (void)invalidPinWithReason:(NSString *)message;

- (void)showError:(NSString*)error;
- (void)wrongPINRemainigAttempts:(NSUInteger)remaining;
- (void)reset;

@end
