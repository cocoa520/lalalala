//
//  AnnoyAnimationView.h
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-9-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CALayer+Animation.h"
@interface AnnoyAnimationViewOne : NSView
{
    CALayer *_bglayer;
    CALayer *_freecarLayer;
    CALayer *_backfreecarwheelLayer;
    CALayer *_frontfreecarwheelLayer;
    CALayer *_vipcarLayer;
    CALayer *_vipcarwheelLayer1;
    CALayer *_vipcarwheelLayer2;
    CALayer *_vipcarwheelLayer3;
    CALayer *_vipcarwheelLayer4;
    CALayer *_vipcarwheelLayer5;
    CALayer *_maskLayer;
    CATextLayer *_countTextLayer;
    CATextLayer *_dayTextLayer;
}

- (void)startAnimation;
/**
 传输完成之后 到结果页面是调用此方法
 */
- (void)stopAnimation;
/**
 remainderCount 剩余个数 Unit个数的单位
 */
- (void)setRemainderCount:(int)remainderCount Unit:(NSString *)unit;
/**
 remainderdays 剩余天数 Unit 天数的单位
 */
- (void)setRemainderDays:(int)remainderDays Unit:(NSString *)unit;

@end
