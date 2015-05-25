//
//  PinEntryContainerViewController.m
//  CustomPINEntry
//
//  Created by Eduard on 27/03/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import "PinEntryContainerViewController.h"
#import "PopupViewController.h"

NSString *kBackgoundImage					= @"backgoundImage";
NSString *kKeyColor							= @"pinKeyColor";
NSString *kKeyNormalStateImage				= @"pinKeyNormalStateImage";
NSString *kKeyHighlightedStateImage			= @"pinKeyHighlightedStateImage";
NSString *kDeleteKeyNormalStateImage		= @"pinDeleteKeyNormalStateImage";
NSString *kDeleteKeyHighlightedStateImage	= @"pinDeleteKeyHighlightedStateImage";
NSString *kPinKeyFontName					= @"pinKeyFontName";
NSString *kPinKeyFontSize					= @"pinKeyFontSize";

@interface PinEntryContainerViewController()

@property (nonatomic) float titleLabelWidth;
@property (nonatomic) float pinsViewY;
@property (nonatomic) float messageLabelY;
@property (nonatomic) float messageLabelX;
@property (nonatomic) int pinsViewOffset;

@property (nonatomic) PopupViewController* popupViewController;
@property (nonatomic) UIView* whiteOverlay;

@end

@implementation PinEntryContainerViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	self.pinEntryViewController = [[PinEntryViewController alloc] initWithNibName:@"PinEntryViewController" bundle:nil];
	[self.pinViewPlaceholder addSubview:self.pinEntryViewController.view];
    
	self.pinEntryViewController.delegate = self;
    self.messageLabel.textColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];
    self.pinsViewOffset = 0;
}

-(void)viewDidLayoutSubviews{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        self.pinEntryViewController.view.frame = self.view.frame;
        self.mode = self.mode;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        self.pinViewPlaceholder.frame = self.view.frame;
    }
    
    self.popupViewController = [[PopupViewController alloc] initWithNibName:@"PopupViewController" bundle:nil];
    
    self.popupViewController.view.layer.masksToBounds = NO;
    self.popupViewController.view.layer.shadowRadius = 50;
    self.popupViewController.view.layer.shadowColor = [[UIColor colorWithWhite:0 alpha:1]CGColor];
    self.popupViewController.view.layer.shadowOpacity = 0.5;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        self.popupViewController.view.frame = CGRectMake(self.view.frame.size.width/2-740/2, self.view.frame.size.height/2-380/2, 740, 380);
    else
        self.popupViewController.view.frame = CGRectMake(
                self.view.frame.size.width/2-self.popupViewController.view.frame.size.width/2,
                self.view.frame.size.height/2-MIN(self.popupViewController.view.frame.size.height, self.view.frame.size.height)/2,
                self.popupViewController.view.frame.size.width,
                MIN(self.popupViewController.view.frame.size.height, self.view.frame.size.height));
    
    self.whiteOverlay = [[UIView alloc] initWithFrame:self.view.frame];
    self.whiteOverlay.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
}

-(void)viewWillAppear:(BOOL)animated{
    self.titleLabelWidth = self.titleLabel.frame.size.width;
    self.pinsViewY = self.pinEntryViewController.pinsView.frame.origin.y;
    self.messageLabelY = self.messageLabel.frame.origin.y;
    self.mode = self.mode;
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.supportedOrientations;
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (void)reset {
	[self.pinEntryViewController reset];
}

- (void)invalidPin {
	[self.pinEntryViewController invalidPin];
}

- (void)invalidPinWithReason:(NSString *)message {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        if (self.mode == PINRegistrationMode || self.mode == PINRegistrationVerififyMode|| self.mode == PINChangeNewPinMode || self.mode == PINChangeNewPinVerifyMode)
            self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY+(2*self.pinsViewOffset)-5, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY+self.pinsViewOffset, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
    }
    self.messageLabel.frame = CGRectMake(self.messageLabel.frame.origin.x, self.messageLabelY+self.pinsViewOffset+self.pinsViewOffset-5, self.messageLabel.frame.size.width, self.messageLabel.frame.size.height);
	self.messageLabel.text = message;
	[self.pinEntryViewController invalidPin];
}

- (void)setMessage:(NSString *)message {
	self.messageLabel.text = message;
}

-(void)setMode:(PINEntryModes)mode{
    _mode = mode;
    switch (mode) {
        case PINCheckMode:
            self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabelWidth, self.titleLabel.frame.size.height);
            self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            
            self.loginPhoto.hidden = NO;
            self.createPinView.hidden = YES;
            self.titleLabel.text = [self.messages objectForKey:@"LOGIN_PIN_KEYBOARD_TITLE"];
            self.pinEntryViewController.titleLabel.text = [self.messages objectForKey:@"LOGIN_PIN_KEYBOARD_TITLE"];
            self.popupViewController.titleLabel.text = [self.messages objectForKey:@"LOGIN_PIN_HELP_TITLE"];
            self.popupViewController.contentTextView.text = [self.messages objectForKey:@"LOGIN_PIN_HELP_MESSAGE"];
            self.subtitleLabel.text = @"";
            self.messageLabel.text = @"";
            self.pinEntryViewController.stepIndicator.hidden = YES;
            self.pinEntryViewController.pinsFrame.hidden = YES;
            [self.titleLabel sizeToFit];
            self.forgotPinButton.hidden = NO;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                self.pinEntryViewController.pinsBackgroundView.backgroundColor = [UIColor colorWithWhite:.92 alpha:1];
                self.pinViewPlaceholder.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x, 190, self.pinViewPlaceholder.frame.size.width, self.pinViewPlaceholder.frame.size.height);
                self.messageLabel.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x + 22, self.pinViewPlaceholder.frame.origin.y + 60, self.pinViewPlaceholder.frame.size.width-40, self.messageLabel.frame.size.height);
                self.pinsViewOffset = 12;
                self.messageLabel.font = [UIFont systemFontOfSize:10];
            }
            else{
                self.messageLabel.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x+self.pinEntryViewController.pinsView.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.pinEntryViewController.pinsView.frame.size.width, self.messageLabel.frame.size.height);
                self.pinsViewOffset = 0;
            }
            break;
        case PINRegistrationMode:
            self.loginPhoto.hidden = YES;
            self.createPinView.hidden = NO;
            self.pinEntryViewController.pinsBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                self.pinViewPlaceholder.layer.borderColor = [UIColor colorWithWhite:.92 alpha:1].CGColor;
                self.pinViewPlaceholder.layer.borderWidth = 1.0f;
                self.pinViewPlaceholder.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x, 260, self.pinViewPlaceholder.frame.size.width, self.pinViewPlaceholder.frame.size.height);
                self.messageLabel.frame = CGRectMake(50, self.messageLabelY, self.pinEntryViewController.pinsView.frame.size.width, self.messageLabel.frame.size.height);
                self.messageLabel.font = [UIFont systemFontOfSize:16];
                self.pinsViewOffset = 0;
            }
            else{
                self.messageLabel.frame = CGRectMake(self.messageLabel.frame.origin.x, self.messageLabelY+self.pinsViewOffset, self.messageLabel.frame.size.width, self.messageLabel.frame.size.height);
                self.pinsViewOffset = 20;
            }
            self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabelWidth, self.titleLabel.frame.size.height);
            self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY+self.pinsViewOffset, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            self.titleLabel.text = [self.messages objectForKey:@"CREATE_PIN_SCREEN_TITLE"];
            self.pinEntryViewController.titleLabel.text = [self.messages objectForKey:@"CREATE_PIN_KEYBOARD_TITLE"];
            self.subtitleLabel.text = [self.messages objectForKey:@"CREATE_PIN_INFO_LABEL"];
            self.popupViewController.titleLabel.text = [self.messages objectForKey:@"CREATE_PIN_HELP_TITLE"];
            self.popupViewController.contentTextView.text = [self.messages objectForKey:@"CREATE_PIN_HELP_MESSAGE"];
            self.messageLabel.text = @"";
            self.pinEntryViewController.stepIndicator.hidden = NO;
            self.pinEntryViewController.pinsFrame.hidden = NO;
            [self.titleLabel sizeToFit];
            self.forgotPinButton.hidden = YES;
            break;
        case PINRegistrationVerififyMode:
            self.loginPhoto.hidden = YES;
            self.createPinView.hidden = NO;
            self.pinEntryViewController.pinsBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                self.pinViewPlaceholder.layer.borderColor = [UIColor colorWithWhite:.92 alpha:1].CGColor;
                self.pinViewPlaceholder.layer.borderWidth = 1.0f;
                self.pinViewPlaceholder.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x, 260, self.pinViewPlaceholder.frame.size.width, self.pinViewPlaceholder.frame.size.height);
                self.messageLabel.frame = CGRectMake(50, self.messageLabelY, self.pinEntryViewController.pinsView.frame.size.width, self.messageLabel.frame.size.height);
                self.messageLabel.font = [UIFont systemFontOfSize:16];
                self.pinsViewOffset = 0;
            }
            else{
                self.messageLabel.frame = CGRectMake(self.messageLabel.frame.origin.x, self.messageLabelY+self.pinsViewOffset, self.messageLabel.frame.size.width, self.messageLabel.frame.size.height);
                self.pinsViewOffset = 20;
            }
            self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabelWidth, self.titleLabel.frame.size.height);
            self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY+self.pinsViewOffset, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            self.titleLabel.text = [self.messages objectForKey:@"CONFIRM_PIN_SCREEN_TITLE"];
            self.pinEntryViewController.titleLabel.text = [self.messages objectForKey:@"CONFIRM_PIN_KEYBOARD_TITLE"];
            self.subtitleLabel.text = [self.messages objectForKey:@"CONFIRM_PIN_INFO_LABEL"];
            self.popupViewController.titleLabel.text = [self.messages objectForKey:@"CONFIRM_PIN_HELP_TITLE"];
            self.popupViewController.contentTextView.text = [self.messages objectForKey:@"CONFIRM_PIN_HELP_MESSAGE"];
            self.messageLabel.text = @"";
            self.pinEntryViewController.stepIndicator.hidden = NO;
            self.pinEntryViewController.pinsFrame.hidden = NO;
            [self.titleLabel sizeToFit];
            self.forgotPinButton.hidden = YES;
            break;
        case PINChangeCheckMode:
            self.loginPhoto.hidden = NO;
            self.createPinView.hidden = YES;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                self.pinEntryViewController.pinsBackgroundView.backgroundColor = [UIColor colorWithWhite:.92 alpha:1];
                self.pinViewPlaceholder.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x, 190, self.pinViewPlaceholder.frame.size.width, self.pinViewPlaceholder.frame.size.height);
                self.messageLabel.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x + 22, self.pinViewPlaceholder.frame.origin.y + 60, self.pinViewPlaceholder.frame.size.width-40, self.messageLabel.frame.size.height);
                self.pinsViewOffset = 12;
                self.messageLabel.font = [UIFont systemFontOfSize:10];
            }
            else{
                self.messageLabel.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x+self.pinEntryViewController.pinsView.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.pinEntryViewController.pinsView.frame.size.width, self.messageLabel.frame.size.height);
                self.pinsViewOffset = 0;
            }
            self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabelWidth, self.titleLabel.frame.size.height);
            self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            self.titleLabel.text = [self.messages objectForKey:@"LOGIN_PIN_KEYBOARD_TITLE"];
            self.pinEntryViewController.titleLabel.text = [self.messages objectForKey:@"LOGIN_PIN_KEYBOARD_TITLE"];
            self.popupViewController.titleLabel.text = [self.messages objectForKey:@"LOGIN_PIN_HELP_TITLE"];
            self.popupViewController.contentTextView.text = [self.messages objectForKey:@"LOGIN_PIN_HELP_MESSAGE"];
            self.subtitleLabel.text = @"";
            self.messageLabel.text = @"";
            self.pinEntryViewController.stepIndicator.hidden = YES;
            self.pinEntryViewController.pinsFrame.hidden = YES;
            [self.titleLabel sizeToFit];
            self.forgotPinButton.hidden = NO;
            break;
        case PINChangeNewPinMode:
            self.loginPhoto.hidden = YES;
            self.createPinView.hidden = NO;
            self.pinEntryViewController.pinsBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, 300, self.titleLabel.frame.size.height);
            self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            self.titleLabel.text = [self.messages objectForKey:@"CHANGE_PIN_SCREEN_TITLE"];
            self.pinEntryViewController.titleLabel.text = [self.messages objectForKey:@"CREATE_PIN_KEYBOARD_TITLE"];
            self.subtitleLabel.text = [self.messages objectForKey:@"CREATE_PIN_INFO_LABEL"];
            self.popupViewController.titleLabel.text = [self.messages objectForKey:@"CHANGE_PIN_HELP_TITLE"];
            self.popupViewController.contentTextView.text = [self.messages objectForKey:@"CHANGE_PIN_HELP_MESSAGE"];
            self.messageLabel.text = @"";
            self.pinEntryViewController.stepIndicator.hidden = YES;
            self.pinEntryViewController.pinsFrame.hidden = NO;
            [self.titleLabel sizeToFit];
            self.forgotPinButton.hidden = YES;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                self.pinViewPlaceholder.layer.borderColor = [UIColor colorWithWhite:.92 alpha:1].CGColor;
                self.pinViewPlaceholder.layer.borderWidth = 1.0f;
                self.pinViewPlaceholder.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x, 260, self.pinViewPlaceholder.frame.size.width, self.pinViewPlaceholder.frame.size.height);
                self.messageLabel.frame = CGRectMake(50, self.messageLabelY, self.pinEntryViewController.pinsView.frame.size.width, self.messageLabel.frame.size.height);
                self.messageLabel.font = [UIFont systemFontOfSize:16];
                self.pinsViewOffset = 0;
            }
            else{
                self.pinsViewOffset = 20;
                self.messageLabel.frame = CGRectMake(self.subtitleLabel.frame.origin.x, self.messageLabelY+self.pinsViewOffset, self.messageLabel.frame.size.width, self.messageLabel.frame.size.height);
                self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY+self.pinsViewOffset, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            }
            break;
        case PINChangeNewPinVerifyMode:
            self.loginPhoto.hidden = YES;
            self.createPinView.hidden = NO;
            self.pinEntryViewController.pinsBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, 300, self.titleLabel.frame.size.height);
            self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            self.titleLabel.text = [self.messages objectForKey:@"CONFIRM_CHANGE_PIN_SCREEN_TITLE"];
            self.pinEntryViewController.titleLabel.text = [self.messages objectForKey:@"CONFIRM_PIN_KEYBOARD_TITLE"];
            self.subtitleLabel.text = [self.messages objectForKey:@"CONFIRM_PIN_INFO_LABEL"];
            self.popupViewController.titleLabel.text = [self.messages objectForKey:@"CONFIRM_CHANGE_PIN_HELP_TITLE"];
            self.popupViewController.contentTextView.text = [self.messages objectForKey:@"CONFIRM_CHANGE_PIN_HELP_MESSAGE"];
            self.messageLabel.text = @"";
            self.pinEntryViewController.stepIndicator.hidden = YES;
            self.pinEntryViewController.pinsFrame.hidden = NO;
            [self.titleLabel sizeToFit];
            self.forgotPinButton.hidden = YES;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                self.pinViewPlaceholder.layer.borderColor = [UIColor colorWithWhite:.92 alpha:1].CGColor;
                self.pinViewPlaceholder.layer.borderWidth = 1.0f;
                self.pinViewPlaceholder.frame = CGRectMake(self.pinViewPlaceholder.frame.origin.x, 260, self.pinViewPlaceholder.frame.size.width, self.pinViewPlaceholder.frame.size.height);
                self.messageLabel.frame = CGRectMake(50, self.messageLabelY, self.pinEntryViewController.pinsView.frame.size.width, self.messageLabel.frame.size.height);
                self.messageLabel.font = [UIFont systemFontOfSize:16];
                self.pinsViewOffset = 0;
            }
            else{
                self.pinsViewOffset = 20;
                self.messageLabel.frame = CGRectMake(self.subtitleLabel.frame.origin.x, self.messageLabelY+self.pinsViewOffset, self.messageLabel.frame.size.width, self.messageLabel.frame.size.height);
                self.pinEntryViewController.pinsView.frame = CGRectMake(self.pinEntryViewController.pinsView.frame.origin.x, self.pinsViewY+self.pinsViewOffset, self.pinEntryViewController.pinsView.frame.size.width, self.pinEntryViewController.pinsView.frame.size.height);
            }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark PinEntryViewControllerDelegate

- (void)pinEntered:(PinEntryViewController *)controller pin:(NSString *)pin {
	[self.delegate pinEntered:self pin:pin];
}
- (IBAction)helpButtonClicked:(id)sender {
    [self.popupViewController.proceedButton setTitle:[self.messages objectForKey:@"HELP_POPUP_OK"] forState:UIControlStateNormal] ;
    [self.view addSubview:self.whiteOverlay];
    [self.view addSubview:self.popupViewController.view];
}

- (IBAction)closePopupButtonClicked:(id)sender {
    [self.whiteOverlay removeFromSuperview];
    [self.popupViewController.view removeFromSuperview];
}

- (IBAction)proceedPopupButtonClicked:(id)sender {
    [self.whiteOverlay removeFromSuperview];
    [self.popupViewController.view removeFromSuperview];
}
- (IBAction)forgotPinClicked:(id)sender {
    [self.delegate pinForgotten:self];
}

@end