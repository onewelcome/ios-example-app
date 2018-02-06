
//  Copyright © 2018 Onegini. All rights reserved.

#import "InfoViewController.h"
#import "ONGResourceRequest.h"
#import "ONGDeviceClient.h"
#import "AlertPresenter.h"
#import "ONGResourceResponse+JSONResponse.h"
#import "ProfileModel.h"
#import "ONGUserClient.h"

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appId;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UILabel *appPlatform;
@property (weak, nonatomic) IBOutlet UILabel *implicit;
@property (weak, nonatomic) IBOutlet UILabel *profileId;
@property (weak, nonatomic) IBOutlet UILabel *profileName;

@property (nonatomic) AlertPresenter *alertPresenter;
@property (nonatomic) ONGUserProfile *selectedUserProfile;

@end

@implementation InfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Info";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selectedUserProfile = [ProfileModel sharedInstance].selectedUserProfile;
    if (self.selectedUserProfile) {
        self.profileId.text = self.selectedUserProfile.profileId;
        self.profileName.text = [[ProfileModel sharedInstance] profileNameForUserProfile:self.selectedUserProfile];
    }
    [self authenticateUserImplicitlyAndFetchResource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.alertPresenter = [AlertPresenter createAlertPresenterWithTabBarController:self.tabBarController];
    [self authenticateDeviceAndFetchResource];
}

#pragma mark - App details

- (void)authenticateDeviceAndFetchResource
{
    [[ONGDeviceClient sharedInstance] authenticateDevice:@[@"application-details"] completion:^(BOOL success, NSError *_Nullable error) {
        if (success) {
            [self fetchApplicationDetails];
        } else {
            // unwind stack in case we've opened registration
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [self.alertPresenter showErrorAlert:error title:@"Device authentication failed"];
        }
    }];
}

- (void)fetchApplicationDetails
{
    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"resources/application-details" method:@"GET"];
    [[ONGDeviceClient sharedInstance] fetchResource:request completion:^(ONGResourceResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            self.appId.text = [NSString stringWithFormat: @"%ld\nFetching anonymous resource failed", error.code];
            self.appId.hidden = NO;
        } else {
            id jsonResponse = [response JSONResponse];
            if (jsonResponse != nil) {
                self.appId.text = [jsonResponse objectForKey:@"application_identifier"];
                self.appVersion.text = [jsonResponse objectForKey:@"application_version"];
                self.appPlatform.text = [jsonResponse objectForKey:@"application_platform"];
            }
        }
    }];
}

#pragma mark - Implicit authentication

- (void)authenticateUserImplicitlyAndFetchResource
{
    if (self.selectedUserProfile) {
        if ([self selectedProfileIsImplicitlyAuthenticated]) {
            [self fetchResourceImplicitly];
        } else {
            [[ONGUserClient sharedInstance] implicitlyAuthenticateUser:self.selectedUserProfile scopes:nil completion:^(BOOL success, NSError *_Nonnull error) {
                if (success) {
                    [self fetchResourceImplicitly];
                } else {
                    self.implicit.text = [NSString stringWithFormat:@"Implicit authentication failed %ld", error.code];
                }
            }];
        }
    }
}

- (BOOL)selectedProfileIsImplicitlyAuthenticated
{
    ONGUserProfile *authenticatedUserProfile = [[ONGUserClient sharedInstance] implicitlyAuthenticatedUserProfile];
    
    return authenticatedUserProfile && [authenticatedUserProfile isEqual:self.selectedUserProfile];
}

- (void)fetchResourceImplicitly
{
    ONGResourceRequest *request = [[ONGResourceRequest alloc] initWithPath:@"resources/user-id-decorated" method:@"GET"];
    [[ONGUserClient sharedInstance] fetchImplicitResource:request completion:^(ONGResourceResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            self.implicit.text = [NSString stringWithFormat:@"Fetching implicit resource failed %ld", error.code];
        } else {
            id jsonResponse = [response JSONResponse];
            if (jsonResponse != nil) {
                self.implicit.text = [NSString stringWithFormat:@"%@",
                                          [jsonResponse objectForKey:@"decorated_user_id"]];
            }
        }
    }];
}


@end
