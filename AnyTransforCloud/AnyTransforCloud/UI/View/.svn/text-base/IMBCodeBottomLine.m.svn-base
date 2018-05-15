//
//  IMBCodeBottomLine.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/19.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCodeBottomLine.h"
#import "StringHelper.h"

@implementation IMBCodeBottomLine

- (void)drawRect:(NSRect)dirtyRect {
    NSRect lineRect = NSMakeRect(0, 0, dirtyRect.size.width, 1);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:lineRect];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
    [path fill];
    [path closePath];
}

@end
