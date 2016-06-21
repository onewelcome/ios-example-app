//
//  ChangePinController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 17/06/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneginiSDK.h"

@interface ChangePinController : NSObject <OGChangePinDelegate>

+ (instancetype)sharedInstance;

-(void)changePin;

@end
