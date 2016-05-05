//
//  PINEntryCell.m
//  OneginiDemoAppiOS
//
//  Created by Pawel Kozielecki on 21/08/14.
//  Copyright (c) 2014 Onegini. All rights reserved.
//

#import "PINEntryCell.h"

@interface PINEntryCell()

@property (nonatomic) NSString *currentEntry;
@property (nonatomic) NSString *initialEntry;
@property (nonatomic) UIImageView *imgFull;
@property (nonatomic) UIImageView *imgEmpty;
@property (nonatomic) UIImageView *imgActive;

@property (nonatomic) UIView *dotView;

@end

@implementation PINEntryCell

- (id)initWithInitialEntry:(NSString*)entry {
    self = [super init];
    if (self) {
        self.currentEntry = self.initialEntry = entry;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = CELL_HEIGHT/2;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}

- (void)didMoveToSuperview {
    [self createDotView];
    [self refresh];
}

- (void)createDotView {
    int dotWidth = CELL_WIDTH;
    int dotHeight = CELL_HEIGHT;
    self.dotView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-dotWidth/2,(self.frame.size.height/2)-dotHeight/2,CELL_WIDTH,CELL_HEIGHT)];
    self.dotView.layer.cornerRadius = CELL_HEIGHT/2;
    self.dotView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.dotView];
}

- (void)refresh {
    if (!self.imgEmpty) {
        [self addSubview:self.imgEmpty];
    }
    if (!self.dotView) {
        [self addSubview:self.dotView];
    }
    if (!self.imgActive) {
        self.imgActive.hidden = YES;
        [self addSubview:self.imgActive];
    }

    [self refreshBg];
}

- (void)refreshBg {
    self.imgEmpty.hidden = self.currentEntry!=nil;
    self.dotView.hidden = self.currentEntry==nil;
}

- (void)setX:(int)x andY:(int)y {
    self.frame = CGRectMake(x, y, CELL_WIDTH, CELL_HEIGHT);
}

- (UIImageView *)generateBgImageFromFileNamed:(NSString *)imgName {
    UIImage *img = [UIImage imageNamed:imgName];
    return [[UIImageView alloc] initWithImage:img];
}

- (NSString *)getEntry {
    return self.currentEntry;
}

 -(void)setEntry:(NSString *)entry {
    self.currentEntry = entry;
    [self refresh];
}

- (void)reset {
    [self dropFocus];
    self.currentEntry = self.initialEntry;
    self.isEdited = NO;
    [self refresh];
}

- (void)dropFocus {
    for (UIView* view in self.subviews) {
        [view resignFirstResponder];
    }
}

- (void)setIsEdited:(bool)isEdited {
    _isEdited = isEdited;
    if (isEdited){
        self.layer.borderColor = [UIColor blackColor].CGColor;
    } else if (self.isFilled){
        self.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

- (void)setIsFilled:(bool)isFilled{
    _isFilled = isFilled;
    if (isFilled) {
        self.dotView.hidden = NO;
    } else {
        self.dotView.hidden = YES;
    }
}

@end
