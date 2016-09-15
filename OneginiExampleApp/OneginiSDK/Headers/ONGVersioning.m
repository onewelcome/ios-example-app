// Copyright (c) 2016 Onegini. All rights reserved.

#import "ONGVersioning.h"
#import "ONGKeychainManager.h"

@implementation ONGVersioning

+ (instancetype)sharedInstance
{
    static ONGVersioning *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ONGVersioning alloc] init];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentVersion = OG_SDK_VERSION;
    }

    return self;
}

#pragma mark -

- (BOOL)isCurrentVersionStored
{
    return [self.currentVersion isEqualToString:self.storedVersion];
}

- (NSString *)storedVersion
{
    return [ONGKeychainManager fetchSDKDataVersion];
}

- (void)storeCurrentVersion
{
    if (!self.isCurrentVersionStored) {
        [ONGKeychainManager storeSDKDataVersion:self.currentVersion];
    }
}

@end