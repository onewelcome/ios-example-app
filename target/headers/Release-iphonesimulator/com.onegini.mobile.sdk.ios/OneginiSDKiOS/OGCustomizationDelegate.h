//
//  OGCustomizationDelegate.h
//  OneginiSDKiOS
//
//  Created by Stanisław Brzeski on 08/01/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Delegate responsible for providing customizable values used within the SDK.
 */
@protocol OGCustomizationDelegate <NSObject>

@optional

/**
 *  Default prompt displays when asking user to provide fingerprint. Default prompt is used when no specific prompt is found. If no defaultFingerprintPrompt is provided or is equal to nil then prompt is provied by SDK itself.
 *
 *  @return Prompt to be displayed in fingerprint dialog.
 */
- (NSString*)defaultFingerprintPrompt;

/**
 *  Specific fingerprint prompt used in authorization flow.
 *
 *  @return Prompt to be displayed in fingerprint dialog.
 */
- (NSString*)fingerprintAuthorizePrompt;

/**
 *  Specific fingerprint prompt used in reauthorization flow.
 *
 *  @return Prompt to be displayed in fingerprint dialog.
 */
- (NSString*)fingerprintReauthorizePrompt;

/**
 *  Specific fingerprint prompt used in push message flow.
 *
 *  @param message          Message received from push notification.
 *  @param notificationType Type of the received push notification.
 *
 *  @return Prompt to be displayed in fingerprint dialog.
 */
- (NSString*)fingerprintPromptForPushWithMessage:(NSString*)message notificationType:(NSString*)notificationType;

@end
