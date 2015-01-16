//
//  OneginiCordovaClient.h
//  OneginiCordovaPlugin
//
//  Created by Eduard on 13-01-15.
//
//

#import <Cordova/CDV.h>
#import <OneginiSDKiOS/OneginiSDK.h>

@interface OneginiCordovaClient : CDVPlugin <OGAuthorizationDelegate>

@property (strong, nonatomic) OGOneginiClient *oneginiClient;
@property (strong, nonatomic) OGConfigModel *configModel;

@property (copy, nonatomic) NSString *authorizeCommandTxId;
@property (copy, nonatomic) NSString *confirmPinCommandTxId;

- (void)clearTokens:(CDVInvokedUrlCommand *)command;
- (void)clearCredentials:(CDVInvokedUrlCommand *)command;
- (void)initWithConfig:(CDVInvokedUrlCommand *)command;
- (void)authorize:(CDVInvokedUrlCommand *)command;
- (void)confirmPinWithVerification:(CDVInvokedUrlCommand *)command;
- (void)confirmPin:(CDVInvokedUrlCommand *)command;

@end
