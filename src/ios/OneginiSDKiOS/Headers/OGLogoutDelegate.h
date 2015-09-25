//
//  OGLogoutDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 22/09/15.
//  Copyright © 2015 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGLogoutDelegate <NSObject>

-(void)logoutSuccessful;
-(void)logoutFailureWithError:(NSError*)error;

@end
