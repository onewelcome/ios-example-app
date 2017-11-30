//  Copyright © 2017 Onegini. All rights reserved.

#import "PendingTransactionsViewController.h"
#import "PendingTransactionTableViewCell.h"
#import "ONGUserClient.h"
#import "AlertPresenter.h"
#import "MobileAuthenticationOperation.h"

@interface PendingTransactionsViewController ()

@property (nonatomic, copy) NSArray<ONGPendingMobileAuthRequest *> *pendingTransactions;
@property (nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PendingTransactionsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Pending transactions";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *reuseID = NSStringFromClass([PendingTransactionTableViewCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:reuseID bundle:nil] forCellReuseIdentifier:reuseID];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(invokeDataReload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void)reloadData
{
    [[ONGUserClient sharedInstance] pendingPushMobileAuthRequests:^(NSArray<ONGPendingMobileAuthRequest *> * _Nullable pendingTransactions, NSError * _Nullable error) {
        if (!error){
            self.pendingTransactions = [self sortPendingTransactionsByTime:pendingTransactions];
            NSInteger pendingTransactionsCount = [pendingTransactions count];
            [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%ld", (long)pendingTransactionsCount]];
            [self.tableView reloadData];
        }
        else {
            [self showError:error];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pendingTransactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([PendingTransactionTableViewCell class]);
    PendingTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setupCell:self.pendingTransactions[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MobileAuthenticationOperation *operation = [[MobileAuthenticationOperation alloc] initWithPendingMobileAuthRequest:self.pendingTransactions[indexPath.row]
                                                                                                            userClient:[ONGUserClient sharedInstance]
                                                                                                  navigationController:self.navigationController
                                                                                                      tabBarController:self.tabBarController];
    
    [[ONGUserClient sharedInstance] handlePendingPushMobileAuthRequest:self.pendingTransactions[indexPath.row] delegate:operation];
}

#pragma mark - Actions

- (void)invokeDataReload:(UIRefreshControl *)sender
{
    [sender endRefreshing];
    [self reloadData];
}

- (NSArray<ONGPendingMobileAuthRequest *> *)sortPendingTransactionsByTime:(NSArray<ONGPendingMobileAuthRequest *> *)pendingTransactions
{
    NSArray *sortDescriptors = @[
                                 [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(date)) ascending:NO]
                                 ];
    return [pendingTransactions sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)showError:(NSError *)error
{
    AlertPresenter *errorPresenter = [AlertPresenter createAlertPresenterWithTabBarController:self.tabBarController];
    [errorPresenter showErrorAlert:error title:@"Pending transactions error"];
}

@end
