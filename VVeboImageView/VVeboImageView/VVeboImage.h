//
//  VVeboImage.h
//  vvebo
//
//  Created by Johnil on 14-3-6.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVeboImage : UIImage

+ (VVeboImage *)gifWithData:(NSData *)data;
- (UIImage *)nextImage;
- (int)count;
- (float)frameDuration;
- (void)resumeIndex;

@end
