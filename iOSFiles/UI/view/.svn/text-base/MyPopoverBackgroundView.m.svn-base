//
//  MyPopoverBackgroundView.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/3.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "MyPopoverBackgroundView.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"
@implementation MyPopoverBackgroundView

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
//    [[NSColor whiteColor] set]; // 此处设置背景颜色
//    NSRectFill(self.bounds);
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width/2.0, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width/2.0 - 13, 11)];
        [path lineToPoint:NSMakePoint(3, 11)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(3, 3+11) radius:3 startAngle:270 endAngle:180 clockwise:YES];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height - 3 )];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(3, dirtyRect.size.height  - 3) radius:3 startAngle:180 endAngle:90 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width - 3, dirtyRect.size.height)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 3,  dirtyRect.size.height - 3) radius:3 startAngle:90 endAngle:0 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width , 3 + 11)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 3, 3+11) radius:3 startAngle:0 endAngle:270 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width/2.0 + 13, 11)];
        [path closePath];
        [path addClip];
        [COLOR_DEVICE_Popover_Btn_Bg_COLOR setFill];
        [path fill];
}

@end
