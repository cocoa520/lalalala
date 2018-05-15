//
//  IMBToolTipShadowsView.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/20.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBToolTipShadowsView.h"
#import "StringHelper.h"
@implementation IMBToolTipShadowsView

- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    [super dealloc];
}

- (instancetype)initWithFrame:(NSRect)frameRect WithString:(NSString *)string{
    if ([super initWithFrame:frameRect]) {
        _textString = [string retain];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    _shadow = [[NSShadow alloc] init];
    [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_deepColor", nil)]];
    [_shadow setShadowOffset:NSMakeSize(0.0, -0.2)];
    [_shadow setShadowBlurRadius:2.0];
    [_shadow set];
    NSRect newRect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 5, self.frame.size.width-10, self.frame.size.height - 10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:newRect];
    [path moveToPoint: CGPointMake(5 +1, dirtyRect.size.height/2-10/2)];
    [path lineToPoint: CGPointMake(5 +1, dirtyRect.size.height/2+10/2)];
    [path lineToPoint: CGPointMake(0 +1, dirtyRect.size.height/2)];
    [path setLineWidth:1.f];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
    [path stroke];
    [path closePath];

    
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
}


@end
