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
	CADisplayLink *timer;
	NSMutableArray *gifsView;
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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:UIApplicationDidBecomeActiveNotification object:nil];
	}
	return self;
}

- (void)startTimer{
	if (gifsView.count<=0) {
		return;
	}
	[self stopTimer];
	timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
	timer.frameInterval = tickStep;
	[timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
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
