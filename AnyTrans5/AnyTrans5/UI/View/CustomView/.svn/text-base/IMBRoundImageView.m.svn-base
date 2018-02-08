//
//  IMBRoundImageView.m
//  TestMyOwn
//
//  Created by iMobie on 7/24/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBRoundImageView.h"
#import "StringHelper.h"

#define ImageSize NSMakeSize(72,72)

@implementation IMBRoundImageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)viewDidMoveToSuperview{
    [self initConfig];
}

- (void)awakeFromNib{
    [self initConfig];
}

- (void)initConfig{
    NSSize size = ImageSize;
    [self setFrameSize:size];
    [self setNeedsDisplay];
//    [self.window setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//    // Drawing code here.
//    NSSize size = ImageSize;
//    CGFloat height = size.height-2;
//    CGFloat width = size.width-2;
////
//    NSBezierPath *rectBezierPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:0 yRadius:0];
//    dirtyRect.origin.x += 1;
//    dirtyRect.origin.y += 1;
//    dirtyRect.size.width = width;
//    dirtyRect.size.height = height;
////
//    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:width/2.0 yRadius:height/2.0];
//
//    rectBezierPath = [rectBezierPath bezierPathByReversingPath];
//    [bezierPath appendBezierPath:rectBezierPath];
//    [bezierPath fill];
//    NSBezierPath *bezierPath1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:width/2.0 yRadius:height/2.0];
//    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
//    [bezierPath1 stroke];
}

@end
