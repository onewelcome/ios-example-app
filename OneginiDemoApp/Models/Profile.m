//
//  Profile.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "Profile.h"

@interface Profile ()

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@end

@implementation Profile

+ (instancetype)profileFromJSON:(NSDictionary *)json {
    Profile *profile = [Profile new];
    
    profile.email = json[@"email"];
    profile.firstName = json[@"email"];
    profile.lastName = json[@"email"];
    
    return profile;
}

@end
