//
//  VVeboImageTicker.h
//  VVeboImageView
//
//  Created by Johnil on 14-3-18.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//
#import <Foundation/Foundation.h>
@class VVeboImageView;
#define tickStep 0.03f
@interface VVeboImageTicker : NSObject

+ (VVeboImageTicker *)sharedInstance;
- (void)tickView:(VVeboImageView *)imageView;
- (void)unTickView:(VVeboImageView *)imageView;

@end
