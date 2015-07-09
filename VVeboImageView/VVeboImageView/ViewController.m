//
//  ViewController.m
//  VVeboImageView
//
//  Created by Johnil on 14-3-7.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+VVebo.h"
#import "UIImage+VVebo.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()

@end

@implementation ViewController {
	UIScrollView *scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	for (int i=0; i<2; i++) {
        UIImageView *gif = [[UIImageView alloc] initWithFrame:CGRectMake(49, 20+135*i, 222, 125)];
        gif.tag = 1;
        [gif sd_setImageWithURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/large/68639d14jw1esgkca5hlig20cc06y1l9.gif"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image.isGif) {
                [gif playGif];
            }
        }];
        [self.view addSubview:gif];
        [gif playGif];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
