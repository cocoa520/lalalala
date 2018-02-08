//
//  AnnoyAnimationViewFour.h
//  AnyTrans
//
//  Created by LuoLei on 16-10-25.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CALayer+Animation.h"
@interface AnnoyAnimationViewFour : NSView
{
    CALayer *_bglayer;
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
- (void)setBackgroundImage:(NSImage *)backgroundImage;
@end
