// Copyright (c) 2016 Onegini. All rights reserved.

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)keyImageBarButtonItem
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"key"]];
    [imageView sizeToFit];

    return [[UIBarButtonItem alloc] initWithCustomView:imageView];
}

@end