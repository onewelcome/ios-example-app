//  Copyright © 2016 Onegini. All rights reserved.

#import <UIKit/UIKit.h>

@interface PushConfirmationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pushTitle;
@property (weak, nonatomic) IBOutlet UILabel *pushMessage;
@property (nonatomic, copy) void (^pushConfirmed)(BOOL confirmed);

@end
