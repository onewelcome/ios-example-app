//  Copyright © 2016 Onegini. All rights reserved.

#import "ResourceController.h"
#import "Profile.h"
#import "OneginiSDK.h"

@interface ResourceController ()
@end

@implementation ResourceController

+ (instancetype)sharedInstance
{
    static ResourceController *singleton;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });

    return singleton;
}

- (void)getProfile:(void (^)(Profile *profile, NSError *error))completion
{
    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"/client/resource/token" method:@"GET"];
    [[ONGUserClient sharedInstance] fetchResource:request completion:^(ONGResourceResponse * _Nullable response, NSError * _Nullable error) {
        if (response.data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:NULL];
            Profile *profile = [Profile profileFromJSON:json];
            
            if (completion) {
                completion(profile, nil);
            }
        } else if (completion) {
            completion(nil, error);
        }
    }];
}

@end
