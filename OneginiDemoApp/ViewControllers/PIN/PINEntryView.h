//
//  PINEntryView.h
//  OneginiDemoAppiOS
//
//  Created by Pawel Kozielecki on 21/08/14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINEntryView : UIView

@property (nonatomic) int selectedCellIndex;

- (id)initWithPINlength:(int)pinLength andFrame:(CGRect)frame;
- (NSString *)getPIN;
- (void)reset;

- (void)updateWithCurrentPinLength:(NSUInteger)currentPinLenght;

@end
