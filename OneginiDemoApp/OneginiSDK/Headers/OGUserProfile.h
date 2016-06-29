//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface OGUserProfile : NSObject<NSCoding>

@property (nonatomic, strong) NSString *profileId;

+ (OGUserProfile *)profileWithId:(NSString *)profileId;

@end
