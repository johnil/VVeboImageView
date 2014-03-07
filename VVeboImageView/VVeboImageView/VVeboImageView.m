//
//  VVeboImageView.m
//  vvebo
//
//  Created by Johnil on 14-3-6.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import "VVeboImageView.h"

@implementation VVeboImageView {
	NSTimer *timer;
	VVeboImage *gifImage;
}

- (void)setImage:(UIImage *)image{
	if (image==nil) {
		if (timer) {
			[timer invalidate];
			timer = nil;
		}
		[super setImage:nil];
		return;
	}
	if ([image isKindOfClass:[VVeboImage class]]) {
		gifImage = (VVeboImage *)image;
		if ([(VVeboImage *)image count]>1) {
			float duration = [gifImage frameDuration];
			[(VVeboImage *)image resumeIndex];
			[super setImage:[(VVeboImage *)image nextImage]];
			timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(tick) userInfo:nil repeats:NO];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
		} else {
			[super setImage:image];
		}
	} else {
		[super setImage:image];
	}
}

- (void)tick{
	[timer invalidate];
	timer = nil;
	float duration = [gifImage frameDuration];
	[super setImage:[gifImage nextImage]];
	timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(tick) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)removeFromSuperview{
	if (timer) {
		[timer invalidate];
		timer = nil;
	}
	self.image = nil;
	[super removeFromSuperview];
}

- (void)dealloc{
	NSLog(@"imageview dealloc");
}

@end
