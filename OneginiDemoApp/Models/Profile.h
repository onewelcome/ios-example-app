//
//  Profile.h
//  OneginiDemoApp
//
//  Created by Sergey Butenko on 5/5/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

+ (instancetype)profileFromJSON:(NSDictionary *)json;

@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong, readonly) NSString *firstName;
@property (nonatomic, strong, readonly) NSString *lastName;

@end
