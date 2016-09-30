
#import <UIKit/UIKit.h>

@class ONGAuthenticator;

@interface AuthenticatorCellTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^didChangeAuthenticatorSelectionState)(AuthenticatorCellTableViewCell *sender, BOOL selected);

- (void)apply:(ONGAuthenticator *)authenticator;

@end
