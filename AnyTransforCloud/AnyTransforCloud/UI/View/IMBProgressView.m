//
//  IMBProgressView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBProgressView.h"
#import "StringHelper.h"

@implementation IMBProgressView
@synthesize progress = _progress;

- (void)dealloc {
    [super dealloc];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
    [path addClip];
    [[StringHelper getColorFromString:CustomColor(@"progress_bgColor", nil)] setFill];
    [path closePath];
    [path fill];
    
    NSRect rect = self.bounds;
    CGFloat drawWidth = rect.size.width * (_progress/100.0);
    CGFloat drawHeight = rect.size.height;
    
    NSBezierPath *bezierpath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(rect.origin.x, rect.origin.y,drawWidth, drawHeight) xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"progress_fill_Color", nil)] setFill];
    [bezierpath fill];
    [bezierpath closePath];
}

@end
