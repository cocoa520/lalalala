//
//  IMBBoxView.m
//  AnyTrans
//
//  Created by long on 16-7-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBoxView.h"

@implementation IMBBoxView
@synthesize hastopBoder = _hastopBoder;
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
	if (_hastopBoder) {
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path moveToPoint:NSMakePoint(0, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
        [[NSColor colorWithDeviceRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
        [path stroke];
    }
}

- (void)setHastopBoder:(BOOL)hastopBoder
{
    if (_hastopBoder != hastopBoder) {
        _hastopBoder = hastopBoder;
        [self setNeedsDisplay:YES];
    }
}
- (void)viewWillDraw
{
    [super viewWillDraw];
    //[self setNeedLayout:YES];
}


@end
