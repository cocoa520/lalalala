//
//  IMBDrawTextFiledView.m
//  PhoneRescue
//
//  Created by long on 16-6-24.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBDrawTextFiledView.h"
#import "StringHelper.h"
#define LINE 5
@implementation IMBDrawTextFiledView

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
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds))];
    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds) - LINE)];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(self.bounds) - LINE , NSMaxY(self.bounds) - LINE) radius:LINE startAngle:0 endAngle:90];
    [path lineToPoint:NSMakePoint(NSMinX(self.bounds) + LINE, NSMaxY(self.bounds))];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(self.bounds) + LINE, NSMaxY(self.bounds)-LINE) radius:LINE startAngle:90 endAngle:180];
    [path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds))];
    [path setLineWidth:2];
    [path addClip];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [path stroke];
    // Drawing code here.
  }

@end
