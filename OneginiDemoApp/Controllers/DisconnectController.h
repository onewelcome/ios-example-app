//
//  DisconnectController.h
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 09/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisconnectController : NSObject

+ (DisconnectController *)sharedInstance;
- (void)disconnect;

@end
