//
//  IMBAnimateProgressBar.h
//  TestMyOwn
//
//  Created by iMobie on 7/7/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBAnimateProgressBar : NSView{
    NSImage *_bgImg;
    CGFloat _beforeProgress;
    CGFloat _currentProgress;
    CGFloat _progress;
    NSTimer *_timer;
    NSInteger _counter;
    BOOL _progressStop;
    dispatch_queue_t progressQueue;
    IBOutlet  NSImageView *leftImageView;
    IBOutlet NSImageView *rightImageView;
    IBOutlet NSView *backGView;
    NSRunLoop *loop;
    NSImage *_backGroundImage;
    IBOutlet NSImageView *_animationImgView;
    int redColor;
    int greedColor;
    int blueColor;
    float oldWidth;
    NSThread *_runloopThread;
    BOOL _isFastDrive;
    
    id _delegate;
}

@property (assign,nonatomic) id delegate;
@property (assign,nonatomic) CGFloat progress;
@property (nonatomic, assign) BOOL isFastDrive;
- (void)reInit;
- (void)startAnimation;
- (void)stopAnimation;
- (void)pauseTimer;
- (void)setProgressWithOutAnimation:(CGFloat)progress;
-(void)removeAnimationImgView;

-(void)setLoadAnimation;

@end
