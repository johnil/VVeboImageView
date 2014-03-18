//
//  VVeboImageTicker.m
//  VVeboImageView
//
//  Created by Johnil on 14-3-18.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import "VVeboImageTicker.h"
#import "VVeboImageView.h"

@implementation VVeboImageTicker {
	NSTimer *timer;
	NSMutableArray *gifsView;
}

+ (void)load
{
    [self performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
}

+ (VVeboImageTicker *)sharedInstance
{
    static VVeboImageTicker *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[VVeboImageTicker alloc] init];
    }
    return sharedInstance;
}

- (id)init{
	self = [super init];
	if (self) {
		gifsView = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)startTimer{
	[self stopTimer];
	timer = [NSTimer scheduledTimerWithTimeInterval:tickStep target:self selector:@selector(tick) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
	if (timer) {
		[timer invalidate];
		timer = nil;
	}
}

- (void)tickView:(VVeboImageView *)imageView{
	if ([gifsView indexOfObject:imageView]==NSNotFound) {
		[gifsView addObject:imageView];
	}
	if (gifsView.count>0&&timer==nil) {
		[self startTimer];
	}
}

- (void)unTickView:(VVeboImageView *)imageView{
	[gifsView removeObject:imageView];
	if (gifsView.count<=0&&timer!=nil) {
		[self stopTimer];
	}
}

- (void)tick{
	[gifsView makeObjectsPerformSelector:@selector(playNext)];
}

@end
