//  Copyright © 2016 Onegini. All rights reserved.

#import "ResourceController.h"
#import "Profile.h"
#import "OneginiSDK.h"

@interface ResourceController ()

@property (nonatomic, copy) void(^callback)(Profile *profile, NSError *error);

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
    self.callback = completion;
    
    ONGResourceRequest *request = [[[[[ONGRequestBuilder new] setMethod:@"GET"] setPath:@"/api/persons"] setParametersEncoding:ONGParametersEncodingJSON] build];

    [[ONGUserClient sharedInstance] fetchResource:request completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            Profile *profile = [Profile profileFromJSON:json];
            completion(profile, nil);
        } else {
            completion(nil, error);
        }
        
        
        
//        if (self.callback) {
//            self.callback(profile, nil);
//            self.callback = nil;
//        }
    }];
    
//    [[ONGNetworkClient sharedInstance] fetchResource:@"/api/persons" requestMethod:@"GET" params:nil paramsEncoding:ONGJSONParameterEncoding headers:nil delegate:self];
}

- (void)handleResponse:(NSData *)response
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:0 error:NULL];

    Profile *profile = [Profile profileFromJSON:json];
    if (self.callback) {
        self.callback(profile, nil);
        self.callback = nil;
    }
}

- (void)handleError:(NSError *)error
{
    if (self.callback) {
        self.callback(nil, error);
        self.callback = nil;
    }
}

#pragma mark - OGResourceHandlerDelegate

- (void)resourceResponse:(NSHTTPURLResponse *)response body:(NSData *)body requestId:(NSString *)requestId
{
    [self handleResponse:body];
}

- (void)resourceError:(NSError *)error requestId:(NSString *)requestId
{
    [self handleError:error];
}

@end
