//  Copyright © 2016 Onegini. All rights reserved.

#import "Profile.h"

@interface Profile ()

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@end

@implementation Profile

+ (instancetype)profileFromJSON:(NSDictionary *)json
{
    Profile *profile = [Profile new];

    profile.email = json[@"email"];
    profile.firstName = json[@"first_name"];
    profile.lastName = json[@"last_name"];

    return profile;
}

@end
