//
//  UIImage+VVebo.h
//  Moments
//
//  Created by Johnil on 15/7/9.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface UIImage (VVebo)

+ (UIImage *)gifWithData:(NSData *)data;
- (UIImage *)initGifWithData:(NSData *)data;
@property (nonatomic, strong) NSData *gifData;
@property (nonatomic) NSInteger gifIndex;
@property (nonatomic) CGImageSourceRef gifSource;
@property (nonatomic) size_t gifCount;
- (BOOL)isGif;
- (UIImage *)nextImage;
- (float)frameDuration;
- (void)resumeIndex;
- (void)clearGif;

@end
