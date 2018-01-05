//
//  CloneAnimationView.h
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-12.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "IMBMergeOrCloneViewController.h"

@interface CloneAnimationView : NSView
{
    CALayer *_bglayer;
    CALayer *_backupDeviceLayer;
    CALayer *_backupClipBgLayer;
    CALayer *_circleLayer;
    CALayer *_sourceCloneDeviceLayer;
    CALayer *_targetCloneDeviceLayer;
    CATextLayer *_textLayer1;
    CATextLayer *_textLayer2;
    CATextLayer *_textLayer3;
    CATextLayer *_textLayer4;
    CATextLayer *_textLayer5;
    CATextLayer *_textLayer6;
    CALayer *_dataLayer1;
    CALayer *_dataLayer2;
    CALayer *_dataLayer3;
    BOOL _reset;
    BOOL _isAndroid;
    TransferType _transferType;
}
@property (nonatomic,assign) TransferType transfertype;
@property (nonatomic,assign) BOOL isAndroid;
- (void)reLayerSize;
- (void)setBackupImage:(NSImage *)backupImage sourceImage:(NSImage *)sourceImage targetImage:(NSImage *)targetImage;
/*
 开始准备备份动画
 **/
- (void)startPrepareBackupAnimation;
/*
 开始备份动画
 **/
- (void)startBackupAnimation;
/*
 开始clone数据
 **/
- (void)startCloneDataAnimation;

/**
 停止动画
 */
- (void)stopAnimation;
@end
