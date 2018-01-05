//
//  IMBAirBackupAnimationView.h
//  AnyTrans
//
//  Created by m on 17/10/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "IMBCanClickText.h"
@class IMBBaseInfo;
@interface IMBAirBackupAnimationView : NSView <NSTextViewDelegate> { 
    CALayer *_wifiBgLayer;
    CALayer *_wifiLayer;
    CALayer *_wifiBackupCircle;
    CALayer *_completeLayer;
    CALayer *_wifiCompleteCircle;
    CAShapeLayer *_staticWaterLayer1;//静止的水波1
    CAShapeLayer *_staticWaterLayer2;//静止的水波2
    CAGradientLayer *_gradientLayer;//完成备份的外圈
    CAShapeLayer *_waterLayer1;//向外扩散的水波
    CAShapeLayer *_waterLayer2;

    BOOL _haveAirBackup;//是否存在AirBackup
    NSTimer *_timer;
    int _count;
    NSTextField *_titleLabel;
    NSTextField *_sizeLabel;
    NSTextField *_dateLabel;
    NSTextView *_moreBackup;
    NSTextField *_backinglabel;
    IMBCanClickText *_stopBackupText;
    
    BOOL _isRunning;
    IMBBaseInfo *_baseInfo;
    id _delegate;
}

@property (nonatomic, assign) BOOL haveAirBackup;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) id delegate;

- (void)setBackupSize:(NSString *)sizeStr WithBcakupDate:(NSString *)dateStr WithRecordAry:(NSMutableArray *)records;

- (void)setBackupProgress:(float)progress;

- (void)setBackupStart;

- (void)startAnimationWithBaseInfo:(IMBBaseInfo *)baseInfo;

- (void)endAnimation;

//回到最开始的状态（没有备份时候）
- (void)recoverBeginState;

@end
