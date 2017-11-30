//  Copyright © 2017 Onegini. All rights reserved.


#import "PendingTransactionTableViewCell.h"
#import "ONGPendingMobileAuthRequest.h"
#import "ONGUserProfile.h"
#import "ProfileModel.h"

@interface PendingTransactionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireTime;

@end

@implementation PendingTransactionTableViewCell

- (void)setupCell:(ONGPendingMobileAuthRequest *)pendingTransaction
{
    self.profileNameLabel.text = [[ProfileModel new] profileNameForUserProfile:pendingTransaction.userProfile];
    self.timeLabel.text = [NSDateFormatter localizedStringFromDate:pendingTransaction.date
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterMediumStyle];
    self.expireTime.text = [NSString stringWithFormat:@"Will expire at: %@", [NSDateFormatter localizedStringFromDate:[pendingTransaction.date dateByAddingTimeInterval:([pendingTransaction.timeToLive doubleValue])]
                                                                                                            dateStyle:NSDateFormatterNoStyle
                                                                                                            timeStyle:NSDateFormatterMediumStyle]];
    self.messageLabel.text = pendingTransaction.message;
}

@end
