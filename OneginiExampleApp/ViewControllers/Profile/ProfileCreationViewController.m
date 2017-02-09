//  Copyright © 2017 Onegini. All rights reserved.

#import "ProfileCreationViewController.h"
#import "OneginiSDK.h"
#import "ProfileModel.h"
#import "ProfileViewController.h"

@interface ProfileCreationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *profileName;
@property (nonatomic) ONGUserProfile *userProfile;

@end

@implementation ProfileCreationViewController

- (instancetype)initWithUserProfile:(ONGUserProfile *)userProfile
{
    self = [super init];
    if (self) {
        self.userProfile = userProfile;
    }
    return self;
}

- (IBAction)createProfile:(id)sender
{
    if (!self.profileName.text) {
        self.profileName.text = self.userProfile.profileId;
    }
    [[ProfileModel new] registerProfileName:self.profileName.text forUserProfile:self.userProfile];
    
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
