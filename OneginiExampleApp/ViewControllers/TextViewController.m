//
//  TextViewController.m
//  OneginiExampleApp
//
//  Created by Dima Vorona on 9/14/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "TextViewController.h"

#import <ZFDragableModalTransition/ZFModalTransitionAnimator.h>

@interface TextViewController ()

@property (nonatomic, weak) IBOutlet UINavigationItem *visibleNavigationItem;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic) ZFModalTransitionAnimator *animator;

@end

@implementation TextViewController

#pragma mark - Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // ZF has a weak reference to the modal view controller. Therefore it is not a retain cycle.
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:self];
        self.animator.dragable = YES;
        self.animator.direction = ZFModalTransitonDirectionBottom;
        self.animator.bounces = NO;

        self.transitioningDelegate = self.animator;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateVisibleState];
}

#pragma mark - Properties

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
    } else if (self.presentationController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
