//
//  IMBDrawRectView.m
//  AnyTrans
//
//  Created by long on 16-8-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDrawRectView.h"
#import "StringHelper.h"

@implementation IMBDrawRectView

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
//    NSBezierPath *clipPath1 = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [clipPath1 setWindingRule:NSEvenOddWindingRule];
//    [clipPath1 addClip];
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//    [clipPath1 fill];
    
    // Drawing code here.
    
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)] set];
    [clipPath fill];
    [clipPath setLineWidth:1];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [clipPath stroke];
    // Drawing code here.
}

@end
