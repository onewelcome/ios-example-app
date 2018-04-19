//
// Copyright (c) 2017 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ProfileModel.h"
#import "OneginiSDK.h"

NSString *const profilesKey = @"profiles";

@interface ProfileModel ()

@end

@implementation ProfileModel

+ (instancetype)sharedInstance
{
    static ProfileModel *sharedInstance;
    if (!sharedInstance) {
        sharedInstance = [ProfileModel new];
    }
    return sharedInstance;
}

- (NSArray *)profileNames
{
    return [[[NSUserDefaults standardUserDefaults] dictionaryForKey:profilesKey] allValues];
}

- (void)registerProfileName:(NSString *)profileName forUserProfile:(ONGUserProfile *)userProfile
{
    NSDictionary *profiles = [[NSUserDefaults standardUserDefaults] dictionaryForKey:profilesKey];
    if (profiles == nil) {
        profiles = @{};
    }
    NSMutableDictionary *mutableProfiles = profiles.mutableCopy;
    [mutableProfiles setValue:profileName forKey:userProfile.profileId];
    NSDictionary *updatedProfiles = mutableProfiles.copy;
    [[NSUserDefaults standardUserDefaults] setObject:updatedProfiles forKey:profilesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)profileNameForUserProfile:(ONGUserProfile *)userProfile
{
    if ([userProfile.profileId isEqualToString:@"static"]) {
        [self registerProfileName:@"static" forUserProfile:userProfile];
    }
    NSString *storedName = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:profilesKey] objectForKey:userProfile.profileId];
    if (!storedName)
        storedName = @"ExampleName";
    return storedName;

}

- (void)deleteProfileNameForUserProfile:(ONGUserProfile *)userProfile
{
    NSDictionary *profiles = [[NSUserDefaults standardUserDefaults] dictionaryForKey:profilesKey];
    if (profiles == nil) {
        profiles = @{};
    }
    NSMutableDictionary *mutableProfiles = profiles.mutableCopy;
    [mutableProfiles removeObjectForKey:userProfile.profileId];
    NSDictionary *updatedProfiles = mutableProfiles.copy;
    [[NSUserDefaults standardUserDefaults] setObject:updatedProfiles forKey:profilesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteProfileNames
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:profilesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
