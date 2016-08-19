//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 * Object representing the user profile.
 */
@interface OGUserProfile : NSObject<NSCoding>

/**
 * Unique user profile identifier.
 */
@property (nonatomic, strong) NSString *profileId;

/**
 * Convenience initializer for OGUserProfile.
 */
+ (OGUserProfile *)profileWithId:(NSString *)profileId;

@end
