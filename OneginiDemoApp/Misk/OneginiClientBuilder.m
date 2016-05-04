//
//  OneginiClientBuilder.m
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 4/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "OneginiClientBuilder.h"

#import "Constants.h"

#import "OneginiSDK.h"
#import <UIKit/UIKit.h>

@implementation OneginiClientBuilder

+ (OGOneginiClient *)buildClient {
    OGConfigModel *configModel = [[OGConfigModel alloc] initWithDictionary:self.configFile];
    OGOneginiClient *client = [[OGOneginiClient alloc] initWithConfig:configModel delegate:nil];
    [client setX509PEMCertificates:@[OneginiCertificate, OneginiCertificate]];
    
    return client;
}

+ (NSDictionary *)configFile {
    NSString *configurationFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"OGConfigurationFile"];
    NSString *configurationFilePath = [[NSBundle mainBundle] pathForResource:configurationFilename ofType:nil];
    
    NSMutableDictionary *config = [[NSDictionary dictionaryWithContentsOfFile:configurationFilePath] mutableCopy];
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *name = [NSString stringWithFormat:@"%@_%@_%@", dev.name, dev.systemName, dev.systemVersion];
    [config setValue:[[name componentsSeparatedByString:@" "] componentsJoinedByString:@"_"] forKey:@"kOGDeviceName"];
    
    return [config copy];
}

@end
