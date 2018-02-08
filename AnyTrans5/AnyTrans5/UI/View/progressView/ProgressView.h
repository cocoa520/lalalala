//
//  ProgressView.h
//  ProgressIndicator
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressView : NSProgressIndicator
{
    NSColor *_backgroundColor;//进度条背景颜色;
    NSColor *_leftFillColor;//进度条左边填充渐变色
    NSColor *_rightFillColor;//进度条右边填充渐变色
    CGFloat _height;
    NSImage *_fillimage;
    CALayer *_lightLayer;
    CALayer *_tansferFinishlightLayer;

    BOOL _iswait;
    BOOL _isTansferFinishWait;
}
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,retain)NSColor *backgroundColor;
@property (nonatomic,retain)NSColor *leftFillColor;
@property (nonatomic,retain)NSColor *rightFillColor;
@property (nonatomic,retain)NSImage *fillimage;

- (void)startWati;
- (void)endWait;
- (void)startFinishWait;
- (void)endFinishWait;
@end
