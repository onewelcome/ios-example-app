//
//  TextViewController.m
//  OneginiExampleApp
//
//  Created by Dima Vorona on 9/14/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@property (nonatomic, weak) IBOutlet UINavigationItem *visibleNavigationItem;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateVisibleState];
    
    self.preferredContentSize = CGSizeMake(0, floorf([UIScreen mainScreen].bounds.size.height * 0.75f));
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    if ([self isViewLoaded]) {
        [self updateVisibleState];
    }
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    if ([self isViewLoaded]) {
        [self updateVisibleState];
    }
}

- (void)updateVisibleState
{
    self.visibleNavigationItem.title = self.title;
    self.textView.text = self.text;
}

#pragma mark - IBActions

- (IBAction)dismiss:(id)sender
{
    if (self.completion) {
        self.completion(self);
    }
}


@end
