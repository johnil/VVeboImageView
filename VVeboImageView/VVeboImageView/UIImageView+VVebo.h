//
//  UIImageView+VVebo.h
//  Moments
//
//  Created by Johnil on 15/7/9.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (VVebo)

@property (nonatomic) BOOL autoPlay;
@property (nonatomic) float frameDuration;
@property (nonatomic) float currentDuration;
@property (nonatomic) UIImage *gifImage;

- (void)setVVeboImage:(UIImage *)image;
- (void)playNext;
- (void)playGif;
- (void)pauseGif;

@end
