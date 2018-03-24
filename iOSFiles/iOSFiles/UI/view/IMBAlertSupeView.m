//
//  IMBAlertSupeView.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-2.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBAlertSupeView.h"

@implementation IMBAlertSupeView

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
    
//    NSRectFill(dirtyRect);
    // Drawing code here.
//    [[NSColor cyanColor] set];
//    NSRectFill(dirtyRect);
}


- (void)awakeFromNib {
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:0];
}

#pragma mark - 鼠标响应事件
- (void)mouseUp:(NSEvent *)theEvent {
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    
}

@end
