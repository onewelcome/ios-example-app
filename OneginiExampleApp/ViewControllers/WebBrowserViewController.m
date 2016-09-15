//  Copyright © 2016 Onegini. All rights reserved.

#import "WebBrowserViewController.h"
#import "OneginiSDK.h"

@interface WebBrowserViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWebBrowser) name:ONGCloseWebViewNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.url) {
        [self clearWebViewCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

- (void)clearWebViewCache
{
    // In order to prevent interference of the previous registration we have to drop cookies.
    // Since UIWebView doesn't expose its internal dependencies we're using `sharedURLCache` and `sharedHTTPCookieStorage` for
    // cleaning up network cache and cookies correspondingly.
    
    // In case you'll disable cookies on the registration request itself (`[NSURLRequest requestWithURL:self.url]`) the Token Server
    // won't be able to process registration correctly, because it relies on the cookies.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)closeWebBrowser
{
    self.completionBlock(self.webView.request.URL);
}

@end
