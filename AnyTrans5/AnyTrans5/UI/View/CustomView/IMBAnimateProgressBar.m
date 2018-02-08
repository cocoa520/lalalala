
//
//  IMBAnimateProgressBar.m
//  TestMyOwn
//
//  Created by iMobie on 7/7/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBAnimateProgressBar.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
#define AnimationInterval 2

@implementation IMBAnimateProgressBar
@synthesize progress = _progress;
@synthesize isFastDrive = _isFastDrive;
@synthesize delegate = _delegate;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setup];
        // Initialization code here.
        _progressStop = YES;

    }
    return self;
}

- (void)dealloc{
    if (_bgImg) {
        [_bgImg release];
        _bgImg = nil;
    }
    [_backGroundImage release],_backGroundImage = nil;
    [super dealloc];
}

- (void)killTimer
{
    [self performSelector:@selector(setProgressStop) onThread:_runloopThread withObject:nil waitUntilDone:NO];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (_progress == 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        _currentProgress = _progress;
        _beforeProgress = _currentProgress;
        [self setNeedsDisplay:YES];
        return;
    }
    if (_progress < _beforeProgress) {
        _beforeProgress = _progress;
        _currentProgress = _progress;
    }else{
        _beforeProgress = _currentProgress;
    }
    _progressStop = NO;
    _currentProgress = _beforeProgress;
    _counter = 0;
    [_timer setFireDate:[NSDate date]];
    [self setNeedsDisplay:YES];
}


- (void)setProgressWithOutAnimation:(CGFloat)progress{
    _progress = progress;
    [_timer setFireDate:[NSDate distantFuture]];
    _currentProgress = _progress;
    _beforeProgress = _currentProgress;
    [self setNeedsDisplay:YES];
}

- (void)notifyWhenProgressChanged{
    _counter ++;
    float gap = _progress - _beforeProgress;
    _currentProgress = _beforeProgress + gap*_counter/(60.0*AnimationInterval);
    if (_currentProgress >= 100) {
        _currentProgress = 100;
    }
    if (_counter == 60*AnimationInterval) {
        _beforeProgress = _currentProgress;
        [_timer setFireDate:[NSDate distantFuture]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay:YES];
    });
}

- (void)progressAnimation:(NSTimer *)timer
{
    CGFloat xOrigin = (self.frame.size.width - _bgImg.size.width)/2;
    CGFloat yOrigin = (self.frame.size.height - _bgImg.size.height)/2;
    
    if (leftImageView.frame.origin.x>= xOrigin+self.frame.size.width) {
        
        [leftImageView setFrameOrigin:NSMakePoint(xOrigin-self.frame.size.width, yOrigin)];
    }
    if (rightImageView.frame.origin.x>= xOrigin+self.frame.size.width) {
        
        [rightImageView setFrameOrigin:NSMakePoint(xOrigin-self.frame.size.width, yOrigin)];
    }
    
    [rightImageView setFrameOrigin:NSMakePoint(rightImageView.frame.origin.x+1, yOrigin)];
    [leftImageView setFrameOrigin:NSMakePoint(leftImageView.frame.origin.x+1, yOrigin)];
    [rightImageView setNeedsDisplay:YES];
    [leftImageView setNeedsDisplay:YES];
    [self setNeedsDisplay:YES];

}

- (void)reInit {
    [rightImageView setFrameOrigin:NSMakePoint(-self.frame.size.width, 0)];
    [leftImageView setFrameOrigin:NSMakePoint(0, 0)];
    [rightImageView setNeedsDisplay:YES];
    [leftImageView setNeedsDisplay:YES];
    [backGView setFrameSize:NSMakeSize(1, backGView.frame.size.height)];
    _progress = 0;
    _beforeProgress = 0;
    _currentProgress = 0;
    [self setProgress:0];
}

- (void)awakeFromNib{
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [backGView setHidden:NO];
    }else {
        [backGView setHidden:YES];
    }
    [self setup];
}

- (void)setup
{
    _progressStop = NO;
    if (progressQueue == nil) {
        progressQueue = dispatch_queue_create("timerProgress", NULL);
    }
    dispatch_async(progressQueue, ^{
        _timer = [NSTimer timerWithTimeInterval:1.0/60 target:self selector:@selector(notifyWhenProgressChanged) userInfo:nil repeats:YES];
        if (_timer != nil) {
            _runloopThread = [[NSThread currentThread] retain];
            loop = [NSRunLoop currentRunLoop];
            [loop addTimer:_timer forMode:NSDefaultRunLoopMode];
            [_timer setFireDate:[NSDate distantFuture]];
            while (!_progressStop && _timer) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
        }
    });
    _backGroundImage = [[StringHelper imageNamed:@"scanning_bar_bg"] retain];
    _progress = 0;
    _beforeProgress = 0;
    _currentProgress = 0;
    [self setProgress:0];
    [self setNeedsDisplay:YES];
    [self setLoadAnimation];

}


-(void)setLoadAnimation {
    [_animationImgView setHidden:NO];
    [self setProgressWithOutAnimation:100];
    [_animationImgView setImage:[StringHelper imageNamed:@"transfer_light"]];
    [_animationImgView setWantsLayer:YES];
    //    [imageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = 4; // 持续时间
    animation1.repeatCount = NSIntegerMax; // 重复次数
    animation1.autoreverses = NO;
    animation1.fromValue = [NSValue valueWithPoint:NSMakePoint(-self.frame.size.width, 0)]; // 起始帧
    animation1.toValue = [NSValue valueWithPoint:NSMakePoint(self.frame.size.width +100 , 0)];
    [_animationImgView.layer addAnimation:animation1 forKey:@"move-layer"];
}

-(void)removeAnimationImgView{
    [_animationImgView.layer removeAllAnimations];
    [_animationImgView setHidden:YES];
}

- (void)startAnimation {
    [_timer setFireDate:[NSDate date]];
}

- (void)stopAnimation{
    [_timer setFireDate:[NSDate distantFuture]];
    [self killTimer];
}

- (void)pauseTimer {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)setProgressStop
{
    _progressStop = YES;
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

- (void)drawRect:(NSRect)dirtyRect {
//    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [[NSColor clearColor] setFill];
//    [clipPath fill];
//    
//    [clipPath setWindingRule:NSEvenOddWindingRule];
//    [clipPath addClip];/Volumes/iTools 2.9.1
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//    [clipPath fill];
//    [clipPath closePath];
    
//    if (_backGroundImage) {
//        [_backGroundImage drawInRect:NSMakeRect(0, 0, _backGroundImage.size.width, _backGroundImage.size.height) fromRect:NSMakeRect(0, 0, _backGroundImage.size.width, _backGroundImage.size.height) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
//    }
    
    if (_isFastDrive) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        [path addClip];
        [[StringHelper getColorFromString:CustomColor(@"fastdrive_progress_bgColor", nil)] setFill];
        [path closePath];
        [path fill];
        [path setLineWidth:2];
        [[StringHelper getColorFromString:CustomColor(@"fastdrive_progress_strokeColor", nil)] setStroke];
        [path stroke];
        
        NSRect rect = self.bounds;
        CGFloat drawWidth = rect.size.width * (_currentProgress/100.0);
        CGFloat drawHeight = rect.size.height-1;
        [backGView setFrameSize:NSMakeSize(drawWidth, backGView.frame.size.height)];
        //    CGFloat drawWidth1 = drawWidth- oldWidth;
        int width = drawWidth;
        
        NSBezierPath *bezierpath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(rect.origin.x, rect.origin.y+0.5,width, drawHeight) xRadius:3 yRadius:3];
        [[StringHelper getColorFromString:CustomColor(@"fastdrive_progress_color", nil)] setFill];
        [bezierpath fill];
        [bezierpath closePath];
        
        oldWidth = drawWidth;
    }else {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        [path addClip];
        [[StringHelper getColorFromString:CustomColor(@"progress_bgColor", nil)] setFill];
        [path closePath];
        [path fill];
        
        NSRect rect = self.bounds;
        CGFloat drawWidth = rect.size.width * (_currentProgress/100.0);
        CGFloat drawHeight = rect.size.height;
        [backGView setFrameSize:NSMakeSize(drawWidth, backGView.frame.size.height)];
        //    CGFloat drawWidth1 = drawWidth- oldWidth;
        int width = drawWidth;
        
        NSBezierPath *bezierpath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(rect.origin.x, rect.origin.y,width, drawHeight) xRadius:3 yRadius:3];
        [[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)] setFill];
        [bezierpath fill];
        [bezierpath closePath];
        oldWidth = drawWidth;
        
        if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
            if (_delegate != nil && [_delegate respondsToSelector:@selector(moveBellImageView:)]) {
                [_delegate moveBellImageView:width];
            }
        }
    }
    
    
  /*  for (int i = 0; i<width;i++ ) {
        if (i<=6) {
            if (i == 6)
            {
                NSBezierPath *bezierpath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(rect.origin.x, rect.origin.y,6, drawHeight) xRadius:3 yRadius:3];
                float red = i/drawWidth * 22 + 83;
                float green = 217- i/drawWidth * 39 ;
                float blue = i/drawWidth * 39 + 197;
                
                [[NSColor colorWithDeviceRed:red/255 green:green/255 blue:blue/255 alpha:1.0] setFill];
                [bezierpath fill];
                [bezierpath closePath];
                
            }
            
        }else if (width >12){
            if (i>12) {
                NSBezierPath *bezierpath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(rect.origin.x+i - 6, rect.origin.y,1, drawHeight) xRadius:3 yRadius:3];
                float red = i/drawWidth * 22 + 83;
                float green = 217- i/drawWidth * 39 ;
                float blue = i/drawWidth * 39 + 197;
                
                
                [[NSColor colorWithDeviceRed:red/255 green:green/255 blue:blue/255 alpha:1.0] setFill];
                [bezierpath fill];
                [bezierpath closePath];
            }
            NSBezierPath *bezierpath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(rect.origin.x+i -6, rect.origin.y,6, drawHeight) xRadius:3 yRadius:3];
            float red = i/drawWidth * 22 + 83;
            float green = 217- i/drawWidth * 39 ;
            float blue = i/drawWidth * 39 + 197;
            
            
            [[NSColor colorWithDeviceRed:red/255 green:green/255 blue:blue/255 alpha:1.0] setFill];
            [bezierpath fill];
            [bezierpath closePath];
        }else {
            
        }
    }*/
    

//    [_animationImgView setWantsLayer:YES];
}

@end
