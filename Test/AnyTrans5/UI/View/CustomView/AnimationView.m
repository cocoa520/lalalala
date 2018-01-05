//
//  AnimationView.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/25.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "AnimationView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
@implementation AnimationView

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
    NSBezierPath *path =[NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)] set];
    [path fill];
}



@end
