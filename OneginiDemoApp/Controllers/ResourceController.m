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

- (void)getToken:(void (^)(BOOL received, NSError *error))completion
{
    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"/client/resource/token" method:@"GET"];
    [[ONGUserClient sharedInstance] fetchResource:request completion:^(ONGResourceResponse * _Nullable response, NSError * _Nullable error) {
        if (response && response.statusCode < 300) {
            if (completion) {
                completion(YES, nil);
            }
        } else if (completion) {
            completion(NO, error);
        }
    }];
}

@end
