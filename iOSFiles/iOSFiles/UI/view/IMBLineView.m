//
//  IMBLineView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBLineView.h"
#import "IMBCommonDefine.h"


@interface IMBLineView()
{
    NSColor *_bgColor;
}

@end

@implementation IMBLineView

- (void)awakeFromNib {
    _bgColor = nil;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (_bgColor) {
        [_bgColor set];
        NSRectFill(dirtyRect);
    }
}

- (void)setLineColor:(NSColor *)color {
    _bgColor = [color retain];
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    if (_bgColor) {
        [_bgColor release];
        _bgColor = nil;
    }
    [super dealloc];
}
@end
