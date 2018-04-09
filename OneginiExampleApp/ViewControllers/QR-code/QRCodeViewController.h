//  Copyright © 2018 Onegini. All rights reserved.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "OneginiSDK.h"

@interface QRCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) ONGCustomRegistrationChallenge *challenge;
@property (nonatomic) void (^completionBlock)(NSString *code, BOOL cancelled);

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end
