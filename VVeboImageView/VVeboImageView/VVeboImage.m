//
//  VVeboImage.m
//  vvebo
//
//  Created by Johnil on 14-3-6.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import "VVeboImage.h"

#import <ImageIO/ImageIO.h>

@implementation VVeboImage {
	NSData *data;
	int index;
	CGImageSourceRef source;
	size_t count;
	CGSize size;
}

+ (VVeboImage *)gifWithData:(NSData *)data{
	VVeboImage *image = [[VVeboImage alloc] initGifWithData:data];
	return image;
}

- (VVeboImage *)initGifWithData:(NSData *)data1{
	index = 0;
	data = data1;
	source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
	count = CGImageSourceGetCount(source);
	CGImageRef image = CGImageSourceCreateImageAtIndex(source, index, NULL);
	self = [super initWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
	CGImageRelease(image);
	if (self) {
		if (count<=1) {
			CFRelease(source);
			data = nil;
		}
		NSLog(@"init with gif count %zu %@", count, self);
	}
	return self;
}

- (void)resumeIndex{
	index-=20;
	if (index<0) {
		index = 0;
	}
}

//每侦的时间
- (float)frameDuration {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];

    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }

    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }

	if (cfFrameProperties) {
		CFRelease(cfFrameProperties);
	}
    return frameDuration;
}

- (int)count{
	return count;
}

- (UIImage *)nextImage{
	CGImageRef image = CGImageSourceCreateImageAtIndex(source, index, NULL);
	UIImage *result = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
	CGImageRelease(image);
	index++;
	if (index>count-1) {
		index=0;
	}
	return result;
}

- (void)dealloc{
	if (data) {
		CFRelease(source);
		data = nil;
	}
	NSLog(@"gif release %@", self);
}

@end
