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
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSLog(@"cookie domain: %@", cookie.domain);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)closeWebBrowser
{
    self.completionBlock(self.webView.request.URL);
}

@end
