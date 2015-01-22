//
//  OneginiCordovaClient.h
//  OneginiCordovaPlugin
//
//  Created by Eduard on 13-01-15.
//
//

#import <Cordova/CDV.h>
#import <OneginiSDKiOS/OneginiSDK.h>

@interface OneginiCordovaClient : CDVPlugin <OGAuthorizationDelegate, OGResourceHandlerDelegate>

@property (strong, nonatomic) OGOneginiClient *oneginiClient;
@property (strong, nonatomic) OGConfigModel *configModel;

@property (copy, nonatomic) NSString *authorizeCommandTxId;
@property (copy, nonatomic) NSString *confirmPinCommandTxId;
@property (copy, nonatomic) NSString *fetchResourceCommandTxId;

- (void)clearTokens:(CDVInvokedUrlCommand *)command;
- (void)clearCredentials:(CDVInvokedUrlCommand *)command;
- (void)initWithConfig:(CDVInvokedUrlCommand *)command;
- (void)authorize:(CDVInvokedUrlCommand *)command;
- (void)confirmPinWithVerification:(CDVInvokedUrlCommand *)command;
- (void)confirmPin:(CDVInvokedUrlCommand *)command;
- (void)changePin:(CDVInvokedUrlCommand *)command;
- (void)confirmChangePinWithVerification:(CDVInvokedUrlCommand *)command;
- (void)cancelPinChange:(CDVInvokedUrlCommand *)command;
- (void)logout:(CDVInvokedUrlCommand *)command;
- (void)disconnect:(CDVInvokedUrlCommand *)command;

@end
