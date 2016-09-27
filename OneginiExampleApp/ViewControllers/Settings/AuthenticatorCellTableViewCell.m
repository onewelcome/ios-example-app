

#import "AuthenticatorCellTableViewCell.h"
#import "ONGAuthenticator.h"

@interface AuthenticatorCellTableViewCell ()

@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UILabel *preferredLabel;
@property (nonatomic) IBOutlet UISwitch *stateSwitch;

@end

@implementation AuthenticatorCellTableViewCell

- (void)apply:(ONGAuthenticator *)authenticator
{
    self.nameLabel.text = authenticator.name;
    self.preferredLabel.hidden = !authenticator.preferred;

    self.stateSwitch.on = authenticator.registered;
    self.stateSwitch.enabled = authenticator.type != ONGAuthenticatorPIN;
}

#pragma mark - IBActions

- (IBAction)switchAuthenticatorRegistration:(id)sender
{
    if (self.didChangeAuthenticatorSelectionState) {
        self.didChangeAuthenticatorSelectionState(self, self.stateSwitch.on);
    }
}

@end
