//
//  CarAnimationView.h
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CALayer+Animation.h"
@interface CarAnimationView : NSView
{
    CALayer *_bgLayer;
    CALayer *_bgimageLayer1; //背景图层
    CALayer *_bgimageLayer2; //背景图层
    CALayer *_carLayer;
    CALayer *_backwheelLayer;
    CALayer *_frontwheelLayer;
    CALayer *_groundLayer;
    CALayer *_lineLayer1;
    CALayer *_lineLayer2;
    CALayer *_maskLayer;
    CALayer *_envelopeBackground;
    CALayer *_envelopeLayer1;
    CALayer *_envelopeLayer2;
    CALayer *_categoryLayer;

}
/**
 设置类别图片
 */
- (void)setCategoryImage:(NSImage *)image;
- (void)startAnimation;
/**
 传输完成之后 到结果页面是调用此方法
 */
- (void)stopAnimation;
@end
