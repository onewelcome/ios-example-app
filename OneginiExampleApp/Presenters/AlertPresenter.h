//  Copyright © 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertPresenter : NSObject

+ (instancetype)createAlertPresenterWithNavigationController:(UINavigationController *)navigationController;

- (void)showErrorAlert:(NSError *)error title:(NSString *)title;
- (void)showErrorAlertWithMessage:(NSString *)message title:(NSString *)title;

@end
