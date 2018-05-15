//
//  IMBCustomView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCustomView.h"
#import "StringHelper.h"

@implementation IMBCustomView

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
}

@end
