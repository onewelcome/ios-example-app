//  Copyright © 2018 Onegini. All rights reserved.

#import "QRCodeViewController.h"
#import "AlertPresenter.h"

@interface QRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIView *qrCodeScanner;

@end

@implementation QRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupQRCodeScanner];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
//    [self.previewLayer removeFromSuperlayer];
}

- (void)setupQRCodeScanner
{
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (input) {
        [self.session addInput:input];
    } else {
        self.completionBlock(nil, NO);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
}

- (IBAction)cancel:(id)sender {
    self.completionBlock(nil, YES);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self configureQRScannerView];
}

- (void)configureQRScannerView
{
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:self.qrCodeScanner.layer.bounds];
    [self.qrCodeScanner.layer addSublayer:self.previewLayer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *QRCode = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            QRCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            self.completionBlock(QRCode, NO);
            break;
        }
    }
}

@end
