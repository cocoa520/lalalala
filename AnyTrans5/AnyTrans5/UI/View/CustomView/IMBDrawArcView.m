//
//  IMBDrawArcView.m
//  ArcDemo
//
//  Created by Pallas on 8/28/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import "IMBDrawArcView.h"
#import "StringHelper.h"
@implementation IMBDrawArcView
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        centerPoint = NSZeroPoint;
        _startAngle = 0;
        _endAngle = 0;
        _clockwise = YES;
    }
    return self;
}

- (void)initialTimerAndQueue {
    if (_countdownQueue == nil) {
        _countdownQueue = dispatch_queue_create("countdownQueue", NULL);
    }
    _countdownStop = NO;
    dispatch_async(_countdownQueue, ^{
        if(timer == nil){
            timer = [[NSTimer timerWithTimeInterval:12/360.f target:self selector:@selector(arcShow) userInfo:nil repeats:YES] retain];
        }
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        while (!_countdownStop && timer) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
    });
    [timer setFireDate:[NSDate date]];
}


- (void)stopAnimation {
    _countdownStop = YES;
    if (timer != nil){
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    if (_countdownQueue != nil) {
        dispatch_release(_countdownQueue);
        _countdownQueue = nil;
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    radius = 0;
    if (dirtyRect.size.width > dirtyRect.size.height) {
        radius = floor(dirtyRect.size.height / 2);
    } else {
        radius = floor(dirtyRect.size.width / 2);
    }
    
    int edgeWight = 2;
    radius -= (edgeWight + 2) / 2;
    centerPoint = NSMakePoint(floor(dirtyRect.size.width/2), floor(dirtyRect.size.height/2));
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:edgeWight];
    [path moveToPoint:NSMakePoint(centerPoint.x, centerPoint.y + radius)];
    [path appendBezierPathWithArcWithCenter:centerPoint radius:radius startAngle:90 endAngle:-270 clockwise:YES];
    [[StringHelper getColorFromString:CustomColor(@"annoy_view_drawarc_buttom_color", nil)] set];
    [path stroke];
    
    if (_startAngle == 0 && _endAngle == 0) {
        return;
    }
    path = [NSBezierPath bezierPath];
    [path setLineWidth:edgeWight];
    [path moveToPoint:NSMakePoint(centerPoint.x, centerPoint.y + radius)];
    [path appendBezierPathWithArcWithCenter:centerPoint radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:_clockwise];
    [[StringHelper getColorFromString:CustomColor(@"annoy_view_drawarc_top_color", nil)] set];
    [path stroke];
    
    // 绘制文字
    NSSize size;
    int maxWidth = 0;
    if (radius * 2 - 10 < 0) {
        maxWidth = 20;
    } else {
        maxWidth = radius * 2 - 10;
    }
    NSMutableAttributedString *attrStr = [StringHelper measureForStringDrawing:[NSString stringWithFormat:@"%d", _seconds] withFont:[NSFont fontWithName:@"Arial" size:48.0]  withLineSpacing:0 withMaxWidth:maxWidth withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"annoy_view_drawarc_top_color", nil)]];
    NSRect textRect = NSMakeRect(centerPoint.x - floor(size.width / 2.f) + 1, centerPoint.y - floor(size.height / 2.f) - 2, size.width, size.height);
    [attrStr drawInRect:textRect];
}

- (void)startWithStartAngle:(float)startAngle withSeconds:(int)seconds {
    _startAngle = _endAngle = startAngle;
    if (seconds >= 0) {
        _seconds = seconds;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(remainCountdown:)]) {
        [self.delegate remainCountdown:_seconds];
    }
}

- (void)arcShow {
    if (_endAngle == (_startAngle - 360)) {
        _endAngle = _startAngle;
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [self setNeedsDisplay:YES];
        });
        _seconds--;
        if (_seconds >= 0) {
            [self startWithStartAngle:_startAngle withSeconds:_seconds];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(remainCountdown:)]) {
                [self.delegate remainCountdown:_seconds];
            }
        } else {
            if (_seconds < 0) {
                _seconds = 0;
            }
            if (!_countdownStop) {
                [self stopAnimation];
            }
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(countdownComplete)]) {
                [self.delegate countdownComplete];
            }
        }
    } else {
        _endAngle -= 12;
        _clockwise = YES;
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [self setNeedsDisplay:YES];
        });
    }
}

@end
