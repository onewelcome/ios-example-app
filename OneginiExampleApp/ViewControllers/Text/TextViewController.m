//
// Copyright (c) 2016 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
        self.animator.direction = ZFModalTransitonDirectionBottom;
        self.animator.dragable = YES;
        [self.animator setContentScrollView:self.textView];
        
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
    
    [self.textView scrollRectToVisible:CGRectZero animated:NO];
    [self.textView flashScrollIndicators];
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
