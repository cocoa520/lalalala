//
//  AnnoyAnimationViewTwo.h
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-9-22.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CALayer+Animation.h"
@interface AnnoyAnimationViewTwo : NSView
{
    CALayer *_bglayer;
    CALayer *_freecarLayer;
    CALayer *_backfreecarwheelLayer;
    CALayer *_frontfreecarwheelLayer;
    CALayer *_maskLayer;
    CATextLayer *_countTextLayer;
}
- (void)startAnimation;
/**
 传输完成之后 到结果页面是调用此方法
 */
- (void)stopAnimation;
- (void)setRemainderCount:(int)remainderCount Unit:(NSString *)unit;
@end
