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
#import "OneginiConfigModel.h"

@interface WebBrowserViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation WebBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.registrationRequestChallenge.url) {
        [self clearWebViewCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.registrationRequestChallenge.url];
        [self.webView loadRequest:request];
    }
}

- (void)clearWebViewCache
{
    // In order to prevent interference of the previous registration we have to drop cookies.
    // Since UIWebView doesn't expose its internal dependencies we're using `sharedURLCache` and `sharedHTTPCookieStorage` for
    // cleaning up network cache and cookies correspondingly.
    
    // In case you'll disable cookies on the registration request itself (`[NSURLRequest requestWithURL:self.url]`) the Token Server
    // won't be able to process registration correctly, because it relies on cookies to maintain state.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:[OneginiConfigModel configuration][@"ONGRedirectURL"]]) {
        self.completionBlock(request.URL);
        return NO;
    }
    return YES;
}

- (IBAction)cancelRegistration:(id)sender {
    self.completionBlock(nil);
}

@end
