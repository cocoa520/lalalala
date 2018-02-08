//
//  IMBVolumeBarView.m
//  iMobieTrans
//
//  Created by iMobie on 14-4-29.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBVolumeBarView.h"
#import "StringHelper.h"
@implementation IMBVolumeBarView

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
	
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:2.5 yRadius:2.5];
    [[StringHelper getColorFromString:CustomColor(@"progress_bgColor", nil)] setFill];
    [path fill];
}

@end
