//
//  UIImageView+VVebo.m
//  Moments
//
//  Created by Johnil on 15/7/9.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import "UIImageView+VVebo.h"
#import "UIImage+VVebo.h"
#import "VVeboImageTicker.h"
#import <objc/runtime.h>
@implementation UIImageView (VVebo)

void SwizzleClassMethod2(Class c, SEL orig, SEL new) {
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    
    c = object_getClass((id)c);
    
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

+ (void)load{
    {
        Method ori_Method =  class_getInstanceMethod([UIImageView class], @selector(setImage:));
        Method my_Method = class_getInstanceMethod([UIImageView class], @selector(setVVeboImage:));
        method_exchangeImplementations(ori_Method, my_Method);
    }
//
}

- (void)setAutoPlay:(BOOL)autoPlay{
    objc_setAssociatedObject(self, @"autoPlay", @(autoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)autoPlay{
    return [objc_getAssociatedObject(self, @"autoPlay") boolValue];
}

- (void)setFrameDuration:(float)frameDuration{
    objc_setAssociatedObject(self, @"frameDuration", @(frameDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)frameDuration{
    return [objc_getAssociatedObject(self, @"frameDuration") floatValue];
}

- (void)setCurrentDuration:(float)currentDuration{
    objc_setAssociatedObject(self, @"currentDuration", @(currentDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)currentDuration{
    return [objc_getAssociatedObject(self, @"currentDuration") floatValue];
}

- (void)setGifImage:(UIImage *)gifImage{
    objc_setAssociatedObject(self, @"gifImage", gifImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)gifImage{
    return objc_getAssociatedObject(self, @"gifImage");
}

- (void)setVVeboImage:(UIImage *)image{
    if (image==nil) {
        [self setVVeboImage:nil];
        return;
    }
    if (image.isGif) {
        if (image.gifCount>1) {
            self.gifImage = image;
            self.frameDuration = [self.image frameDuration];
            [image resumeIndex];
            [self setVVeboImage:[image nextImage]];
            if (self.autoPlay) {
                [[VVeboImageTicker sharedInstance] tickView:self];
            }
            return;
        }
    }
    [self setVVeboImage:image];
}

- (void)playNext{
    if (self.gifImage.gifCount==2&&self.gifImage.gifIndex==1) {
        [self setVVeboImage:[self.gifImage nextImage]];
        [[VVeboImageTicker sharedInstance] unTickView:self];
        return;
    }
    if (self.currentDuration<self.frameDuration) {
        self.currentDuration+=tickStep;
        return;
    }
    self.frameDuration = [self.gifImage frameDuration];
    CGImageRelease(self.image.CGImage);
    [self setVVeboImage:[self.gifImage nextImage]];
    self.currentDuration = 0;
}

- (void)playGif{
    if (self.gifImage.gifCount>2) {
        [[VVeboImageTicker sharedInstance] tickView:self];
    }
}

- (void)pauseGif{
    [[VVeboImageTicker sharedInstance] unTickView:self];
}

- (void)removeFromSuperview{
    if ([self isKindOfClass:[UIImageView class]]) {
        [[VVeboImageTicker sharedInstance] unTickView:self];
        self.image = nil;
        self.gifImage = nil;
    }
    [super removeFromSuperview];
}


@end
