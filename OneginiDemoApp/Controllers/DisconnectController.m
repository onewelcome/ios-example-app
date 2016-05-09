//
//  DisconnectController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 09/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "DisconnectController.h"
#import "AppDelegate.h"

@implementation DisconnectController

+ (DisconnectController *)sharedInstance {
    static DisconnectController *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (void)disconnect {
    [[OGOneginiClient sharedInstance] disconnectWithDelegate:self];
}

- (void)disconnectSuccessful {
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES ];
}

- (void)disconnectFailureWithError:(NSError *)error {
    [[AppDelegate sharedNavigationController] popToRootViewControllerAnimated:YES ];
}

@end
