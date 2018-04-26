//
//  IMBSelectConntedDeviceView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/15.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBSelectConntedDeviceView.h"
#import "IMBCommonDefine.h"
#import "IMBViewAnimation.h"
#import "IMBDevViewController.h"

static CGFloat const viewBorderW = 4.f;
static CGFloat const IMBSelectConnetctedDeviceAnimInterval = 0.2f;

@interface IMBSelectConntedDeviceView()
{
    NSRect _originalF;
}

@end

@implementation IMBSelectConntedDeviceView

#pragma mark - 属性的实现
@synthesize contentView = _contentView;
@synthesize isShowing = _isShowing;

#pragma mark - 初始化方法

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (_originalF.size.height) {
        CGFloat height = _originalF.size.height;
        NSRect upperRect = dirtyRect;
        upperRect.origin.y += height;
        upperRect.size.height -= height;
        NSBezierPath *upperBezierPath = [NSBezierPath bezierPathWithRoundedRect:upperRect xRadius:viewBorderW yRadius:viewBorderW];
        [[COLOR_MAIN_WINDOW_SELECTE_DEVICE_BG colorWithAlphaComponent:0.95] set];
        [upperBezierPath fill];
        
        NSRect restRect = dirtyRect;
        restRect.size.height = height;
        NSBezierPath *restBezierPath = [NSBezierPath bezierPathWithRoundedRect:upperRect xRadius:viewBorderW yRadius:viewBorderW];
        [[NSColor clearColor] set];
        [restBezierPath fill];
    }
    
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:viewBorderW yRadius:viewBorderW];
//    [path moveToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds) + viewBorderW)];
//    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(self.bounds) + viewBorderW , NSMinY(self.bounds) + viewBorderW) radius:viewBorderW startAngle:180 endAngle:270];
//    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds) - viewBorderW, NSMinY(self.bounds))];
//    
//    
//    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(self.bounds) - viewBorderW , NSMinY(self.bounds) + viewBorderW) radius:viewBorderW startAngle:270 endAngle:0];
//    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds) - viewBorderW)];
//    
//    
//    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(self.bounds) - viewBorderW , NSMaxY(self.bounds) - viewBorderW) radius:viewBorderW startAngle:0 endAngle:90];
//    [path lineToPoint:NSMakePoint(NSMinX(self.bounds) + viewBorderW, NSMaxY(self.bounds))];
//    
//    
//    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(self.bounds) + viewBorderW, NSMaxY(self.bounds)-viewBorderW) radius:viewBorderW startAngle:90 endAngle:180];
//    [path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds) + viewBorderW)];
    
    
    [path setLineWidth:2];
    [path addClip];
    [COLOR_MAIN_WINDOW_VIEW_SHADOW setStroke];
    [path stroke];
    
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
    }
    return self;
}



#pragma mark - 显示隐藏view

- (void)showWithOriginalFrame:(NSRect)originalF finalF:(NSRect)finalF {
    _isShowing = YES;
    _originalF = originalF;
    self.frame = finalF;
    
    if (_contentView) {
        [_contentView setFrame:NSMakeRect(0, originalF.size.height, finalF.size.width, finalF.size.height - originalF.size.height)];
        [self addSubview:_contentView];
        [self addTrackingRect:NSMakeRect(0, 0, finalF.size.width, finalF.size.height) owner:self userData:nil assumeInside:0];
    }
    self.frame = originalF;
    
    
    [IMBViewAnimation animationMouseMovedAnimWithView:self frame:finalF timeInterval:IMBSelectConnetctedDeviceAnimInterval disable:YES isHidden:NO completion:nil];
}

- (void)hide {
    [self hideWithTimeInterval:IMBSelectConnetctedDeviceAnimInterval];
}

- (void)hideWithTimeInterval:(CGFloat)timeInterval {
    NSRect finalF = self.frame;
    finalF.size.height = 10.0f;
    
    [IMBViewAnimation animationMouseMovedAnimWithView:self frame:_originalF timeInterval:timeInterval disable:YES isHidden:YES completion:^{
        if (self) {
            _isShowing = NO;
            if (_contentView) {
                [_contentView removeFromSuperview];
            }
            [self removeFromSuperview];
        }
        
        
    }];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self hide];
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

@end
