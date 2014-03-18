//
//  VVeboImageView.h
//  vvebo
//
//  Created by Johnil on 14-3-6.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVeboImage.h"

@interface VVeboImageView : UIImageView

@property (nonatomic) float frameDuration;
@property (nonatomic) float currentDuration;
- (void)playNext;
- (void)playGif;
- (void)pauseGif;

@end
