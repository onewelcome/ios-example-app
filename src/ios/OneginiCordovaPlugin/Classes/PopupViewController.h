//
//  PopupViewController.h
//  Onegini VL Test
//
//  Created by Stanisław Brzeski on 19/05/15.
//
//

#import <UIKit/UIKit.h>

@interface PopupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, copy) void (^proceedBlock)();
@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, copy) void (^closeBlock)();

-(void)setPopupMessage:(NSString*)message;
    
@end
