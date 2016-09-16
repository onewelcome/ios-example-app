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
