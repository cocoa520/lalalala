//
//  IMBShadowView.m
//  AnyTransforCloud
//
//  Created by hym on 17/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBShadowView.h"
#import "StringHelper.h"
@implementation IMBShadowView

- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    //投影效果
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    _shadow = [[NSShadow alloc] init];
    [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
    [_shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
    [_shadow setShadowBlurRadius:4.0];
    [_shadow set];
    
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+5, dirtyRect.origin.y+3, self.frame.size.width-10, self.frame.size.height -5);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
    
}

@end
