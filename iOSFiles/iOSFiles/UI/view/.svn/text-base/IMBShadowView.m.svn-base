//
//  IMBShadowView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBShadowView.h"
#import "IMBCommonDefine.h"
#import "IMBCommonTool.h"


@implementation IMBShadowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGFloat blurRadius = 6.0f;
    [IMBCommonTool setViewBgWithView:self color:COLOR_MAIN_WINDOW_VIEW_SHADOW delta:5.0 radius:blurRadius dirtyRect:dirtyRect];
    
    //投影效果
//    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
//    [shadow setShadowColor:COLOR_ALERT_SHADOWCOLOR];
//    [shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
//    [shadow setShadowBlurRadius:blurRadius];
//    [shadow set];
    
//    NSRect newRect = NSMakeRect(dirtyRect.origin.x+5, dirtyRect.origin.y+5, self.frame.size.width-10, self.frame.size.height -10);
//    NSBezierPath *text = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
//    [text fill];
//    [[NSColor clearColor] setStroke];
//    [text addClip];
//    [COLOR_MAIN_WINDOW_VIEW_SHADOW setStroke];
//    [text stroke];
}



@end
