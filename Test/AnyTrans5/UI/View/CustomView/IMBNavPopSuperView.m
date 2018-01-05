//
//  IMBNavPopSuperView.m
//  AnyTrans
//
//  Created by m on 17/8/17.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBNavPopSuperView.h"

@implementation IMBNavPopSuperView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[NSColor grayColor] setFill];
    [path fill];
}

@end
