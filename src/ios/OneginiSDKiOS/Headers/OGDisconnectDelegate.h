//
//  OGDisconnectDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 20/05/15.
//  Copyright (c) 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGDisconnectDelegate <NSObject>

-(void)disconnectSuccessful;
-(void)disconnectFailureWithError:(NSError*)error;

@end
