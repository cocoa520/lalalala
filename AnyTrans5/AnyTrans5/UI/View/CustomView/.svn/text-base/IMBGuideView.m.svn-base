//
//  IMBGuideView.m
//  AnyTrans
//
//  Created by long on 16-10-24.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBGuideView.h"

@implementation IMBGuideView
@synthesize backgroudColor = _backgroundColor;
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
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:4 yRadius:4];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    if (_backgroundColor) {
        [_backgroundColor set];
    }else{
        [[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:0.75] set];
    }
    [clipPath fill];
    
//    NSRect rect = NSMakeRect(50, 400, 400, 200);
//    NSBezierPath *clipPath1 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:4 yRadius:4];
//    [clipPath1 setWindingRule:NSEvenOddWindingRule];
//    [clipPath1 addClip];
//    if (_backgroundColor) {
//        [_backgroundColor set];
//    }else{
//        [[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.5] set];
//    }
//    [clipPath1 fill];

    // Drawing code here.
}

@end
