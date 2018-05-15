//
//  IMBLineView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBLineView.h"
#import "StringHelper.h"

@implementation IMBLineView

- (void)drawRect:(NSRect)dirtyRect {
    
    NSColor *lineColor = nil;
    if (_isTextLine) {
        lineColor = [StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)];
    } else if (_isTableViewLine) {
        lineColor = [StringHelper getColorFromString:CustomColor(@"tableView_line_color", nil)];
    } else {
        lineColor = [StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)];
    }
    // Drawing code here.
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [lineColor set];
    [path fill];
    [path closePath];
    
}

@end
