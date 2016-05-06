//
//  PINEntryView.m
//  OneginiDemoAppiOS
//
//  Created by Pawel Kozielecki on 21/08/14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import "PINEntryView.h"
#import "PINEntryCell.h"

@interface PINEntryView()

@property (nonatomic) int pinLength;
@property (nonatomic) NSMutableArray *cells;
@property (nonatomic) int insertedPinLength;

@end

@implementation PINEntryView

- (void)dealloc {
	self.cells = nil;
}

- (id)initWithPINlength:(int)pinLength andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pinLength = pinLength;
        [self generateCells];
        
        self.selectedCellIndex = 0;
    }
    return self;
}

- (void)generateCells {
    self.cells = [NSMutableArray array];
    PINEntryCell *cell;
    int freeSpace = self.frame.size.width - self.pinLength*CELL_WIDTH;
    int margin = freeSpace / (self.pinLength+1);
    for (int i=0; i<self.pinLength; i++) {
        cell = [[PINEntryCell alloc] initWithInitialEntry:nil];
        cell.index = i+1;
        [self.cells addObject:cell];
        [cell setX:(i+1)*margin+i*CELL_WIDTH andY:0];
        [self addSubview:cell];
    }
}

- (NSString*)getPIN {
    NSString *pin = @"";
    for (PINEntryCell *cell in self.cells) {
        pin = [NSString stringWithFormat:@"%@%ld", pin, (long)[[cell getEntry] integerValue]];
    }
    return pin;
}

- (void)reset {
    [self updateWithCurrentPinLength:0];
}

- (int)insertedPinLength {
    int result = 0;
    for (PINEntryCell *cell in self.cells) {
        if ([cell getEntry])
            result++;
    }
    return result;
}

- (void)updateWithCurrentPinLength:(NSUInteger)currentPinLenght {
    for (int i = 0; i<self.cells.count; i++) {
        PINEntryCell* cell = [self.cells objectAtIndex:i];
        if (i<currentPinLenght){
            cell.isFilled = YES;
            cell.isEdited = NO;
        } else if (i==currentPinLenght){
            cell.isFilled = NO;
            cell.isEdited = YES;
        } else {
            cell.isFilled = NO;
            cell.isEdited = NO;
        }
    }
}

- (void)selectCellWithIndex:(int)index {
    PINEntryCell* cellToSelect = [self.cells objectAtIndex:index];
    cellToSelect.isEdited = YES;
    
    self.selectedCellIndex = index;
}

- (void)deselectCellWithIndex:(int)index {
    PINEntryCell* cellToDeselect = [self.cells objectAtIndex:index];
    cellToDeselect.isEdited = NO;
}

- (void)fillCellWithIndex:(int)index {
    PINEntryCell* cellToSelect = [self.cells objectAtIndex:index];
    cellToSelect.isFilled = YES;
    
    self.selectedCellIndex = index;
}

- (void)emptyCellWithIndex:(int)index {
    PINEntryCell* cellToDeselect = [self.cells objectAtIndex:index];
    cellToDeselect.isFilled = NO;
}

@end
