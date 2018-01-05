//
//  TransferAnimationView.h
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-6.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TransferAnimationView : NSView
{
    CALayer *_bglayer;  /**<背景layer */
    CALayer *_windmillbody;  /**<风车柱 */
    CALayer *_windmillheader;  /**<风车头 */
    CALayer *_compeleteCD;
    CALayer *_cdBackground;
    CALayer *_categoryLayer;
}
/**
 开始传输时 调用此方法
 */
- (void)startAnimation;
- (void)setCategoryImage:(NSImage *)image;
/**
 传输完成之后 到结果页面是调用此方法
 */
- (void)stopAnimation;
@end
