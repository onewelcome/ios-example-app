//
//  PINEntryCell.h
//  OneginiDemoAppiOS
//
//  Created by Pawel Kozielecki on 21/08/14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_WIDTH 16
#define CELL_HEIGHT 16

#define ENTRY_CHANGED @"ENTRY_CHANGED"
#define FOCUS_IN @"FOCUS_IN"
#define FOCUS_OUT @"FOCUS_OUT"

@interface PINEntryCell : UIView

@property (nonatomic) int index;
@property (nonatomic) bool isEdited;
@property (nonatomic) bool isFilled;

- (id)initWithInitialEntry:(NSString*)entry;
- (NSString *)getEntry;
- (void)setEntry:(NSString*)entry;
- (void)reset;
- (void)refresh;
- (void)setX:(int)x andY:(int)y;

@end
