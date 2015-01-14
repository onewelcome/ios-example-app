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

//@property (strong, nonatomic) CDVInvokedUrlCommand *authorizeCommand;
@property (copy, nonatomic) NSString *authorizeCommandTxId;

- (void)initWithConfig:(CDVInvokedUrlCommand *)command;

@end
