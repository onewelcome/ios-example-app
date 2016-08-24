//  Copyright © 2016 Onegini. All rights reserved.

#import "ProfileViewController.h"
#import "DeregistrationController.h"
#import "FingerprintController.h"
#import "ChangePinController.h"

@interface ProfileViewController ()

@property (nonatomic) ChangePinController *changePinController;
@property (nonatomic) FingerprintController *fingerprintController;

@property (weak, nonatomic) IBOutlet UILabel *tokenStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *getTokenSpinner;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tokenStatusLabel.hidden = YES;
    self.getTokenSpinner.hidden = YES;

    [self updateViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateViews];
}

- (void)updateViews
{
    if ([self isFingerprintEnrolled]) {
        [self.fingerprintButton setTitle:@"Disable fingerprint authentication" forState:UIControlStateNormal];
    } else {
        [self.fingerprintButton setTitle:@"Enroll for fingerprint authentication" forState:UIControlStateNormal];
    }
}

- (IBAction)logout:(id)sender
{
    [[ONGUserClient sharedInstance] logoutUser:^(ONGUserProfile * _Nonnull userProfile, NSError * _Nullable error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)disconnect:(id)sender
{
    [[DeregistrationController sharedInstance] deregister];
}

- (IBAction)getToken:(id)sender
{
    self.tokenStatusLabel.hidden = YES;
    self.getTokenSpinner.hidden = NO;

    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"/client/resource/token" method:@"GET"];
    [[ONGUserClient sharedInstance] fetchResource:request completion:^(ONGResourceResponse * _Nullable response, NSError * _Nullable error) {
        self.getTokenSpinner.hidden = YES;
        if (response && response.statusCode < 300) {
            self.tokenStatusLabel.hidden = NO;
        } else {
            [self showError:@"Token retrieval failed"];
        }
    }];
}

- (IBAction)enrollForMobileAuthentication:(id)sender
{
    [[ONGUserClient sharedInstance] enrollForMobileAuthentication:^(BOOL enrolled, NSError * _Nullable error) {
        NSString *alertTitle = nil;
        if (enrolled) {
            alertTitle = @"Enrolled successfully";
        } else {
            alertTitle = @"Enrollment failure";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okButton];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)changePin:(id)sender
{
    self.changePinController = [ChangePinController changePinControllerWithNavigationController:self.navigationController];
    [[ONGUserClient sharedInstance] changePin:self.changePinController];
}

- (IBAction)enrollForFingerprintAuthentication:(id)sender
{
    if ([self isFingerprintEnrolled]) {
        [self deregisterFingerprint];
    } else {
        [self registerFingerprint];
    }
    [self updateViews];
}

- (void)registerFingerprint
{
    [[ONGUserClient sharedInstance] fetchNonRegisteredAuthenticators:^(NSSet<ONGAuthenticator *> * _Nullable authenticators, NSError * _Nullable error) {
        ONGAuthenticator *fingerprintAuthenticator = [self fingerprintAuthenticatorFromSet:authenticators];
        self.fingerprintController = [FingerprintController fingerprintControllerWithNavigationController:self.navigationController];
        [[ONGUserClient sharedInstance] registerAuthenticator:fingerprintAuthenticator delegate:self.fingerprintController];
    }];
}

-(void)deregisterFingerprint
{
    NSSet *registeredAuthenticators = [[ONGUserClient sharedInstance] registeredAuthenticators];
    ONGAuthenticator *fingerprintAuthenticator = [self fingerprintAuthenticatorFromSet:registeredAuthenticators];
    [[ONGUserClient sharedInstance] deregisterAuthenticator:fingerprintAuthenticator completion:nil];
}

- (BOOL)isFingerprintEnrolled
{
    NSSet *registeredAuthenticators = [[ONGUserClient sharedInstance] registeredAuthenticators];
    ONGAuthenticator *fingerprintAuthenticator = [self fingerprintAuthenticatorFromSet:registeredAuthenticators];
    return fingerprintAuthenticator != nil;
}

- (ONGAuthenticator *)fingerprintAuthenticatorFromSet:(NSSet<ONGAuthenticator *> *)authenticators{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d", ONGAuthenticatorTouchID];
    return [authenticators filteredSetUsingPredicate:predicate].anyObject;
}

- (void)showError:(NSString *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Resource error"
                                                                   message:error
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
