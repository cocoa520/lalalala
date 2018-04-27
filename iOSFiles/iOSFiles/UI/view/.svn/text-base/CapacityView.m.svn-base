//
//  CapacityView.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "CapacityView.h"

@implementation CapacityView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSRect rect = dirtyRect;
    rect.size.width -= 2;
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:3 yRadius:3];
    [_color set];
    [path fill];
    
    if (_percent != 1.0) {
        NSRect rect2 = rect;
        rect2.origin.x += rect.size.width-4;
        rect2.size.width = 4;
        NSBezierPath *path1 = [NSBezierPath bezierPathWithRect:rect2];
        [_color set];
        [path1 fill];
    }

}

- (id)initWithFrame:(NSRect)frame WithFillColor:(NSColor *)fillcolor withPercent:(float)percent{
    if (self = [super initWithFrame:frame]) {
        _rect = frame;
        _color = [fillcolor retain];
        _percent = percent;
    }
    return self;
}

- (void)dealloc {
    if (_color != nil) {
        [_color release];
        _color = nil;
    }
    [super dealloc];
}
@end
