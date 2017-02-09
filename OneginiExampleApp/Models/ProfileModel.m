//  Copyright © 2017 Onegini. All rights reserved.

#import "ProfileModel.h"
#import "OneginiSDK.h"

@interface ProfileModel ()

@property (nonatomic) NSString *profilesKey;

@end

@implementation ProfileModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.profilesKey = @"profiles";
    }
    return self;
}

- (NSArray *)profileNames
{
    return [[[NSUserDefaults standardUserDefaults] dictionaryForKey:self.profilesKey] allValues];
}

- (void)registerProfileName:(NSString *)profileName forUserProfile:(ONGUserProfile *)userProfile
{
    NSDictionary *profiles = [[NSUserDefaults standardUserDefaults] dictionaryForKey:self.profilesKey];
    if (profiles == nil) {
        profiles = @{};
    }
    NSMutableDictionary *mutableProfiles = profiles.mutableCopy;
    [mutableProfiles setValue:profileName forKey:userProfile.profileId];
    NSDictionary *updatedProfiles = mutableProfiles.copy;
    [[NSUserDefaults standardUserDefaults] setObject:updatedProfiles forKey:self.profilesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)profileNameForUserProfile:(ONGUserProfile *)userProfile
{
    return [[[NSUserDefaults standardUserDefaults] dictionaryForKey:self.profilesKey] objectForKey:userProfile.profileId];
}

- (void)deleteProfileNameForUserProfile:(ONGUserProfile *)userProfile
{
    NSDictionary *profiles = [[NSUserDefaults standardUserDefaults] dictionaryForKey:self.profilesKey];
    if (profiles == nil) {
        profiles = @{};
    }
    NSMutableDictionary *mutableProfiles = profiles.mutableCopy;
    [mutableProfiles removeObjectForKey:userProfile.profileId];
    NSDictionary *updatedProfiles = mutableProfiles.copy;
    [[NSUserDefaults standardUserDefaults] setObject:updatedProfiles forKey:self.profilesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteProfileNames
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:self.profilesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
