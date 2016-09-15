// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 In future when we implement incremental migration strict versions may be needed. Idea is quite simple:
 struct ONGSDKVersion { (so for 4.09.01-SNAPSHOT)
    NSInteger major; // 4
    NSInteger minor; // 9
    NSInteger revision; // 1 //
 };
 
 NSScanner allows us easily parse string into such struct. 
 Structs in turn can be used by incremental migration to identify next "migration policy" to run. 
 Also we're throwing away extras such as "SNAPSHOT" or "BETA". This also can be easily added as a char *type; or char type[].
 Enum in this case is not very useful, because future maintaner might have no idea about ONGSDKVersion and use 
 undefined type identifier (RELEASE or SPECIFIC_COMPANY_ID for example).
 */

@interface ONGVersioning : NSObject

@property (nonatomic, readonly) NSString *currentVersion;
@property (nonatomic, readonly, nullable) NSString *storedVersion;

@property (nonatomic, readonly) BOOL isCurrentVersionStored;
- (void)storeCurrentVersion;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END