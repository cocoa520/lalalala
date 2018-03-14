//
//  IMBCommonTool.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBCommonTool.h"

@implementation IMBCommonTool

+ (void)setViewBgWithView:(NSView *)view color:(NSColor *)bgColor delta:(CGFloat)delta radius:(CGFloat)radius dirtyRect:(NSRect)dirtyRect {
    dirtyRect.origin.x = 0;
    dirtyRect.origin.y = 0;
    dirtyRect.size.width = view.frame.size.width;
    dirtyRect.size.height = view.frame.size.height;
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+delta, dirtyRect.origin.y+delta, dirtyRect.size.width-delta*2, dirtyRect.size.height - delta*2);
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:radius yRadius:radius];
    [bgColor set];
    [bgPath fill];
}

@end
