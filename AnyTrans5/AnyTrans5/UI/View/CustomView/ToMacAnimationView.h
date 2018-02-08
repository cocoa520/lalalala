//
//  ToMacAnimationView.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-16.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ToMacAnimationView : NSView
{
    CALayer *_bglayer;
    CALayer *_sourceLayer;
    CALayer *_targetLayer;
    CALayer *_dataLayer1;
    CALayer *_dataLayer2;
    CALayer *_dataLayer3;
}

- (void)setSourceImage:(NSImage *)sourceImage targetImage:(NSImage *)targetImage;
- (void)startAnimation;
/**
 传输完成之后 到结果页面是调用此方法
 */
- (void)stopAnimation;

- (void)resetDataLayer;
@end
