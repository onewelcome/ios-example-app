//
//  MessagesModel.m
//  OneginiCordovaPlugin
//
//  Created by Stanisław Brzeski on 27/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "MessagesModel.h"

@implementation MessagesModel

+ (MessagesModel *)sharedInstance {
    static id singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
        [singleton loadMessagesFromFile:@"messages.properties"];
    });
    
    return singleton;
}

+(NSString *)messageForKey:(NSString *)key{
    return [[MessagesModel sharedInstance].messages objectForKey:key];
}

-(void)loadMessagesFromFile:(NSString*)fileName{
    NSString *properties = [self loadFileToString:fileName];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{.*\\}" options:NSRegularExpressionCaseInsensitive error:&error];
    properties = [regex stringByReplacingMatchesInString:properties options:0 range:NSMakeRange(0, [properties length]) withTemplate:@"%@"];
    NSMutableArray *lines = [[properties componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
    NSMutableDictionary* mutablemessages = [NSMutableDictionary dictionary];
    for (NSString* line in lines) {
        if ([line rangeOfString:@"="].location==NSNotFound)//  ![line containsString:@"="])
            continue;
        NSArray* keyValue = [line componentsSeparatedByString:@"="];
        if (keyValue.count==2)
            [mutablemessages setObject:keyValue[1] forKey:keyValue[0]];
        else if (keyValue.count==1)
            [mutablemessages setObject:@"" forKey:keyValue[0]];
        else
            NSLog(@"Error reading messages.properties file");
    }
    self.messages = mutablemessages;
}

- (NSString *)loadFileToString:(NSString*)path {
    NSError *error;
    NSString *fileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:nil] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error reading %@ file", path);
        return @"";
    }
    return fileContent;
}

@end
