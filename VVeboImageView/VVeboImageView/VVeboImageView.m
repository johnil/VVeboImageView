//
//  VVeboImageView.m
//  vvebo
//
//  Created by Johnil on 14-3-6.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import "VVeboImageView.h"
#import "VVeboImageTicker.h"
@implementation VVeboImageView {
	VVeboImage *gifImage;
}

- (void)setImage:(UIImage *)image{
	if (image==nil) {
		[super setImage:nil];
		return;
	}
	if ([image isKindOfClass:[VVeboImage class]]) {
		gifImage = (VVeboImage *)image;
		if ([(VVeboImage *)image count]>1) {
			_frameDuration = [gifImage frameDuration];
			[(VVeboImage *)image resumeIndex];
			[super setImage:[(VVeboImage *)image nextImage]];
			[[VVeboImageTicker sharedInstance] tickView:self];
		} else {
			[super setImage:image];
		}
	} else {
		[super setImage:image];
	}
}

- (void)playNext{
	if (_currentDuration<_frameDuration) {
		_currentDuration+=tickStep;
		return;
	}
	_frameDuration = [gifImage frameDuration];
	[super setImage:[gifImage nextImage]];
	_currentDuration = 0;
}

- (void)playGif{
	[[VVeboImageTicker sharedInstance] tickView:self];
}

- (void)pauseGif{
	[[VVeboImageTicker sharedInstance] unTickView:self];
}

- (void)removeFromSuperview{
	[[VVeboImageTicker sharedInstance] unTickView:self];
	self.image = nil;
	[super removeFromSuperview];
}

- (void)dealloc{
	NSLog(@"imageview dealloc");
}

@end
