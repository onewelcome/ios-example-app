//
//  WebBrowserViewController.m
//  OneginiDemoApp
//
//  Created by Stanisław Brzeski on 08/05/16.
//  Copyright © 2016 Onegini. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebBrowserViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.url){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

@end
