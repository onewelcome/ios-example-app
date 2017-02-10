//  Copyright © 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

@interface ProfileModel : NSObject

- (NSArray *)profileNames;
- (void)registerProfileName:(NSString *)profileName forUserProfile:(ONGUserProfile *)userProfile;
- (NSString *)profileNameForUserProfile:(ONGUserProfile *)userProfile;
- (void)deleteProfileNameForUserProfile:(ONGUserProfile *)userProfile;
- (void)deleteProfileNames;

@end
