//  Copyright © 2017 Onegini. All rights reserved.


#import "PendingTransactionTableViewCell.h"
#import "ONGPendingMobileAuthRequest.h"
#import "ONGUserProfile.h"

@interface PendingTransactionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation PendingTransactionTableViewCell

- (void)setupCell:(ONGPendingMobileAuthRequest *)pendingTransaction
{
    self.profileNameLabel.text = pendingTransaction.userProfile.profileId;
    self.timeLabel.text = [self convertDateToString:pendingTransaction.date];
    self.messageLabel.text = pendingTransaction.message;
}

- (NSString *)convertDateToString:(NSDate *)date
{
    return [NSDateFormatter localizedStringFromDate:date
                                        dateStyle:NSDateFormatterNoStyle
                                        timeStyle:NSDateFormatterMediumStyle];
}

@end
