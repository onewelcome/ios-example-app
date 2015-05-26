//
//  PopupViewController.m
//  Onegini VL Test
//
//  Created by Stanisław Brzeski on 19/05/15.
//
//

#import "PopupViewController.h"

@interface PopupViewController ()
@property (weak, nonatomic) IBOutlet UIView *labelView;

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTextView.contentInset = UIEdgeInsetsMake(-4,-4,0,0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPopupMessage:(NSString*)message{
    float textHeight = self.contentTextView.frame.size.height;
    self.contentTextView.text = message;
    CGRect labrect = [message boundingRectWithSize:self.contentTextView.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentTextView.font} context:Nil];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-(textHeight-labrect.size.height-25));`
}

- (IBAction)buttonProceedClick:(id)sender {
    self.proceedBlock();
}
- (IBAction)buttonCancelClick:(id)sender {
    self.cancelBlock();
}
- (IBAction)buttonCloseClick:(id)sender {
    self.closeBlock();
}

@end
