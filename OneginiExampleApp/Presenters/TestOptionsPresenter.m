//  Copyright © 2016 Onegini. All rights reserved.

#import "TestOptionsPresenter.h"

@implementation TestOptionsPresenter

+ (void)showSecretOptionsOnViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Testing Options"
                                                                   message:@"These options are intended for testing purposes only."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *clearKeychainButton = [UIAlertAction actionWithTitle:@"Clear Keychain Data"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   NSArray *secItemClasses = @[(__bridge id)kSecClassGenericPassword,
                                                                                               (__bridge id)kSecClassInternetPassword,
                                                                                               (__bridge id)kSecClassCertificate,
                                                                                               (__bridge id)kSecClassKey,
                                                                                               (__bridge id)kSecClassIdentity];
                                                                   for (id secItemClass in secItemClasses) {
                                                                       NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
                                                                       SecItemDelete((__bridge CFDictionaryRef)spec);
                                                                   }
                                                               }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:clearKeychainButton];
    [alert addAction:cancelButton];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
