//
//  IMBButtonLoadingView.m
//  iMobieTrans
//
//  Created by iMobie on 14-7-15.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBButtonLoadingView.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBButtonLoadingView
@synthesize isAndroid = _isAndroid;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
  
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect WithAndroid:(BOOL)android{
    if ([self initWithFrame:frameRect]) {
        _isAndroid = android;
        [self initSubView];
        count = 0;
    }
    return self;
}

- (void)initSubView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [self setWantsLayer:YES];
    [self.layer setMasksToBounds:YES];
    _bgLayer = [[CALayer layer] retain];
    [_bgLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_bgLayer setMasksToBounds:YES];
    [_bgLayer setFrame:NSRectToCGRect(self.bounds)];
    if (_isAndroid) {
        [_bgLayer setCornerRadius:5];
        [self.layer setCornerRadius:5];
    }else{
        [_bgLayer setCornerRadius:14];
    }

    _loadLayer = [[CALayer layer] retain];
    [_loadLayer setMasksToBounds:YES];
    [_loadLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_loadLayer setFrame:CGRectMake(20,20,22,22)];
    _loadLayer.contents = [StringHelper imageNamed:@"flowload_loading"];
    [_bgLayer addSublayer:_loadLayer];
    
    [self.layer addSublayer:_bgLayer];
    
    [self startAnimation];
}

- (void)changeSkin:(NSNotification *)notification {
    if ([StringHelper imageNamed:@"flowload_loading"]) {
        _loadLayer.contents = [StringHelper imageNamed:@"flowload_loading"];
    }
}

- (void)startAnimation {
    CABasicAnimation *animation = [IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:1.0];//[IMBAnimation moveY:2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-40] repeatCount:1 beginTime:0 isAutoreverses:NO];
    [_loadLayer addAnimation:animation forKey:@"loadLayer"];
}

- (void)startTwoAnimation {
    CABasicAnimation *animation = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-40] Y:[NSNumber numberWithInt:-60] repeatCount:1 beginTime:0 isAutoreverses:NO];
    [_loadLayer addAnimation:animation forKey:@"twoloadLayer"];
}

- (void)stopAnimation {
    [_loadLayer removeAllAnimations];
}

//- (void)initSubView:(NSRect)frame
//{
//  
//    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(30, 30, frame.size.width, frame.size.height)];
//    imageView.tag = 100;
//    [imageView setImage:[StringHelper imageNamed:@"functionbutton_loading"]];
//    [self addSubview:imageView];
//    [imageView setWantsLayer:YES];
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.5/60 target:self selector:@selector(rotation) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    [imageView release];
//}
//
//- (void)rotation
//{
//    count++;
//    float rotateAngle = - (6*count*M_PI)/180;
//    CALayer *layer = ((NSImageView *)[self viewWithTag:100 ]).layer;
//    [layer setAnchorPoint:CGPointMake(0.5, 0.5)];
//    [layer setAffineTransform:CGAffineTransformMakeRotation(rotateAngle)];
//    if (count == 60) {
//        count = 0;
//    }
//}
//
//- (void)killTimer
//{
//    if (timer != nil) {
//        
//        [timer invalidate]; timer = nil;
//    }
//}
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
//    NSBezierPath *path1 = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [[NSColor whiteColor] setFill];
//    [path1 fill];
//    [path1 closePath];
    NSBezierPath *path = nil;
    if (_isAndroid) {
        path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    } else {
        path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:14 yRadius:14];
    }
    
    [path addClip];
    [[StringHelper getColorFromString:CustomColor(@"functionBtn_down_bgColor", nil)] setFill];
    [path fill];
    [path closePath];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [_loadLayer release],_loadLayer = nil;
    [_bgLayer release],_bgLayer = nil;
    [super dealloc];
}

@end
