//
//  PopoverRootView.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/3.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "PopoverRootView.h"
#import "MyPopoverBackgroundView.h"
#import "SystemHelper.h"
#import "NSString+Category.h"
#import "StringHelper.h"
@implementation PopoverRootView

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
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)] set];
    [path fill];
}

- (void)viewDidMoveToWindow {
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        NSView * aFrameView = [[self.window contentView] superview];
        MyPopoverBackgroundView * aBGView  =[[MyPopoverBackgroundView alloc] initWithFrame:aFrameView.bounds];
        aBGView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [aFrameView addSubview:aBGView positioned:NSWindowBelow relativeTo:aFrameView];
        [super viewDidMoveToWindow];
    }
}

@end
