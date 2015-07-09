//
//  UIImage+VVebo.m
//  Moments
//
//  Created by Johnil on 15/7/9.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import "UIImage+VVebo.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#import "UIImage+MultiFormat.h"
#import "SDWebImageCompat.h"
@implementation UIImage (VVebo)

void SwizzleClassMethod(Class c, SEL orig, SEL new) {
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    
    c = object_getClass((id)c);
    
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

+ (void)load{
    SwizzleClassMethod([UIImage class], @selector(initWithData:), @selector(initGifWithData:));
    SwizzleClassMethod([UIImage class], @selector(sd_imageWithData:), @selector(gifWithData:));
}

- (void)setGifData:(NSData *)gifData{
    objc_setAssociatedObject(self, @"gifData", gifData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)gifData{
    return objc_getAssociatedObject(self, @"gifData");
}

- (void)setGifIndex:(NSInteger)gifIndex{
    objc_setAssociatedObject(self, @"gifIndex", @(gifIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)gifIndex{
    return [objc_getAssociatedObject(self, @"gifIndex") integerValue];
}

- (void)setGifSource:(CGImageSourceRef)gifSource{
    objc_setAssociatedObject(self, @"gifSource", (__bridge id)(gifSource), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGImageSourceRef)gifSource{
    return (__bridge CGImageSourceRef)(objc_getAssociatedObject(self, @"gifSource"));
}

- (void)setGifCount:(size_t)gifCount{
    objc_setAssociatedObject(self, @"gifCount", @(gifCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (size_t)gifCount{
    return [objc_getAssociatedObject(self, @"gifCount") unsignedLongValue];
}

- (BOOL)isGif{
    return self.gifData!=nil;
}

inline UIImage *SDScaledImageForKey(NSString *key, UIImage *image) {
    if (image.isGif) {
        return image;
    }
    if (!image) {
        return nil;
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        CGFloat scale = 1.0;
        if (key.length >= 8) {
            // Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
            NSRange range = [key rangeOfString:@"@2x." options:0 range:NSMakeRange(key.length - 8, 5)];
            if (range.location != NSNotFound) {
                scale = 2.0;
            }
        }
        
        UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
        image = scaledImage;
    }
    return image;
}

- (NSArray *)images{
    if (self.isGif) {
        return @[@"", @""];
    }
    return nil;
}

+ (UIImage *)gifWithData:(NSData *)data{
    return [[UIImage alloc] initGifWithData:data];
}

- (UIImage *)initGifWithData:(NSData *)data{
    NSString *imageContentType = [UIImage contentTypeForData:data];
    if ([imageContentType isEqualToString:@"image/gif"]) {
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        size_t count = CGImageSourceGetCount(source);
        if (count>1) {
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, NULL);
            self = [self initWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            CGImageRelease(cgImage);
            if (self) {
                self.gifIndex = 0;
                self.gifData = data;
                self.gifSource = source;
                self.gifCount = count;
                NSLog(@"init with gif count %zu %@", self.gifCount, self);
            }
        } else {
            self = [self initGifWithData:data];
        }
    } else {
        self = [self initWithData:data scale:[UIScreen mainScreen].scale];
    }
    return self;
}

+ (NSString *)contentTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
}

- (void)resumeIndex{
    self.gifIndex-=20;
    if (self.gifIndex<0) {
        self.gifIndex = 0;
    }
}

//每侦的时间
- (float)frameDuration {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(self.gifSource, self.gifIndex, nil);
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

- (UIImage *)nextImage{
    CGImageRef image = CGImageSourceCreateImageAtIndex(self.gifSource, self.gifIndex, NULL);
    UIImage *result = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    self.gifIndex++;
    if (self.gifIndex>self.gifCount-1) {
        self.gifIndex=0;
    }
    return result;
}

- (void)dealloc{
    if ([self isKindOfClass:[UIImage class]]) {
        [self clearGif];
    }
}

- (void)clearGif{
    if (self.gifData) {
        CFRelease(self.gifSource);
        self.gifData = nil;
    }
}

@end
