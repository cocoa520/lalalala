//
//  MediaTransferAnimationView.h
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-8.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MediaTransferAnimationView : NSView
{
    CALayer *_bglayer;
    CALayer *_cdlayer;
    CALayer *_peoplelayer;
    CALayer *_compeleteCD;
    CALayer *_cdBackground;
    CALayer *_musiclayer1;
    CALayer *_musiclayer2;
    CALayer *_musiclayer3;

}
/**
 开始music传输时 调用此方法
 */
- (void)startAnimation;
/**
 传输完成之后 到结果页面是调用此方法
 */
- (void)stopAnimation;


@end
