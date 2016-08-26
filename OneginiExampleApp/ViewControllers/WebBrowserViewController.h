//  Copyright © 2016 Onegini. All rights reserved.

#import <UIKit/UIKit.h>

@interface WebBrowserViewController : UIViewController

@property (nonatomic) NSURL *url;
@property (nonatomic) void (^completionBlock)(NSURL *url);

@end
