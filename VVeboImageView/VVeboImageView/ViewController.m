//
//  ViewController.m
//  VVeboImageView
//
//  Created by Johnil on 14-3-7.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import "ViewController.h"
#import "VVeboImageView.h"
@interface ViewController ()

@end

@implementation ViewController {
	UIScrollView *scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	scrollView.contentSize = CGSizeMake(320*2, 0);
	scrollView.pagingEnabled = YES;
	scrollView.clipsToBounds = NO;
	scrollView.center = CGPointMake(scrollView.center.x+35, scrollView.center.y+10);
	[self.view addSubview:scrollView];

	NSData *data = [NSData dataWithContentsOfFile:
					[[NSBundle mainBundle] pathForResource:@"1.gif" ofType:nil]];
	for (int i=0; i<10; i++) {
		VVeboImageView *gif = [[VVeboImageView alloc] initWithImage:[VVeboImage gifWithData:data]];
		gif.tag = 1;
		gif.frame = CGRectMake(i%2*130, i/2*100+20, 122, 89);
		[scrollView addSubview:gif];
	}

	NSData *bigData = [NSData dataWithContentsOfFile:
					   [[NSBundle mainBundle] pathForResource:@"2.gif" ofType:nil]];
	VVeboImageView *gif = [[VVeboImageView alloc] initWithImage:[VVeboImage gifWithData:bigData]];
	gif.tag = 1;
	CGRect frame = gif.frame;
	frame.origin.x = 320;
	gif.frame = frame;
	[scrollView addSubview:gif];

	UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(0, gif.frame.size.height-60, 320, 50)];
	description.text = @"这是十张1.4M的gif图";
	[scrollView addSubview:description];

	UILabel *description2 = [[UILabel alloc] initWithFrame:CGRectMake(0, gif.frame.size.height-60, 320, 50)];
	description2.text = @"这是一张23.1M的gif图";
	[gif addSubview:description2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	for (VVeboImageView *temp in scrollView.subviews) {
		if ([temp isKindOfClass:[VVeboImageView class]]) {
			if (temp.tag==1) {
				[temp pauseGif];
				temp.tag = -1;
			} else {
				[temp playGif];
				temp.tag = 1;
			}
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
