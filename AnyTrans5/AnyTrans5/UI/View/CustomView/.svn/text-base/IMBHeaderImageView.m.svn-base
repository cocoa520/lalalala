//
//  IMBHeaderImageView.m
//  iMobieTrans
//
//  Created by iMobie on 14-11-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBHeaderImageView.h"

@implementation IMBHeaderImageView
@synthesize headerimage = _headerimage;
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
    if (_headerimage != nil) {
       
        
        NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:dirtyRect];
        [path addClip];
        [_headerimage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
         NSBezierPath *path1 = [NSBezierPath bezierPathWithOvalInRect:dirtyRect];
        [[NSColor grayColor] setStroke];
        [path1 stroke];
    }
    
}

@end
