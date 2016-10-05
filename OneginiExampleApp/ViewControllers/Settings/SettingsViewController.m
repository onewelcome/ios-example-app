//
// Copyright (c) 2016 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "SettingsViewController.h"

#import "OneginiSDK.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "AuthenticationController.h"
#import "AuthenticatorCellTableViewCell.h"
#import "UIAlertController+Shortcut.h"
#import "AuthenticatorRegistrationController.h"

@interface SettingsViewController ()

@property (nonatomic) ONGUserClient *userClient;
@property (nonatomic) ONGUserProfile *userProfile;
@property (nonatomic, copy) NSArray<ONGAuthenticator *> *authenticators;
@property (nonatomic) AuthenticatorRegistrationController *authenticatorRegistrationController;

@end

@implementation SettingsViewController

#pragma mark - View Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        
        UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithTitle:@"Select preferred"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(selectPreferredAuthenticator:)];
        self.toolbarItems = @[selectItem];
        
        self.userClient = [ONGUserClient sharedInstance];
        self.userProfile = [self.userClient authenticatedUserProfile];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *reuseID = NSStringFromClass([AuthenticatorCellTableViewCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:reuseID bundle:nil] forCellReuseIdentifier:reuseID];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(invokeDataReload:) forControlEvents:UIControlEventValueChanged];
                           
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - Logic

- (void)reloadData
{
    NSSet<ONGAuthenticator *> *allAuthenticators = [self.userClient allAuthenticatorsForUser:self.userProfile];
    self.authenticators = [self sortedAuthentictors:allAuthenticators];
    [self.tableView reloadData];
}

- (NSArray<ONGAuthenticator *> *)sortedAuthentictors:(NSSet<ONGAuthenticator *> *)authenticators
{
    NSArray *sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(type)) ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES]
    ];

    return [authenticators sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)registerAuthenticator:(ONGAuthenticator *)authenticator
{
    self.authenticatorRegistrationController = [AuthenticatorRegistrationController controllerWithNavigationController:self.navigationController completion:^{
        self.authenticatorRegistrationController = nil;
        
        [self reloadData];
    }];
    [self.userClient registerAuthenticator:authenticator delegate:self.authenticatorRegistrationController];
}

- (void)deregisterAuthenticator:(ONGAuthenticator *)authenticator
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.userClient deregisterAuthenticator:authenticator completion:^(BOOL deregistered, NSError *error) {
        [hud hideAnimated:YES];

        [self reloadData];

        if (error != nil) {
            UIAlertController *controller = [UIAlertController controllerWithTitle:@"Failed to deregistered" message:error.localizedDescription completion:nil];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.authenticators.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([AuthenticatorCellTableViewCell class]);
    AuthenticatorCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell apply:self.authenticators[indexPath.row]];

    __weak typeof(self) weakSelf = self;
    [cell setDidChangeAuthenticatorSelectionState:^(AuthenticatorCellTableViewCell *sender, BOOL selected) {
        __strong typeof(self) self = weakSelf;
        if (!self) {
            return;
        }

        ONGAuthenticator *authenticator = self.authenticators[[self.tableView indexPathForCell:sender].row];
        if (selected && !authenticator.registered) {
            [self registerAuthenticator:authenticator];
        } else if (!selected && authenticator.registered) {
            [self deregisterAuthenticator:authenticator];
        }
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ONGAuthenticator *authenticator = self.authenticators[indexPath.row];
    if (!authenticator.preferred && authenticator.registered) {
        [self.userClient setPreferredAuthenticator:authenticator];
        [self reloadData];
    }
}

#pragma mark - Actions

- (void)invokeDataReload:(UIRefreshControl *)sender
{
    [sender endRefreshing];
    [self reloadData];
}

- (IBAction)selectPreferredAuthenticator:(id)sender
{
    NSArray<ONGAuthenticator *> *authenticators = [self sortedAuthentictors:[self.userClient registeredAuthenticatorsForUser:self.userProfile]];
    UIAlertController *controller = [UIAlertController authenticatorSelectionController:authenticators completion:^(NSInteger index, BOOL cancelled) {
        if (!cancelled) {
            [self.userClient setPreferredAuthenticator:authenticators[index]];
            [self reloadData];
        }
    }];

    [self presentViewController:controller animated:YES completion:nil];
}

@end
