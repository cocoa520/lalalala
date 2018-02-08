//
//  ArrowButtonCell.m
//  PhoneClean3.0
//
//  Created by apple on 13-9-18.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "ProgressCell.h"
@implementation ProgressCell
@synthesize arrowBtn = _arrowBtn;
@synthesize closeBtn = _closeBtn;
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSRect rect = cellFrame;
    rect.origin.x += ceilf(((cellFrame.size.width - _arrowBtn.frame.size.width)/2.0));
    rect.origin.y += ceilf((cellFrame.size.height - _arrowBtn.frame.size.height)/2.0);
    [self.arrowBtn setFrameOrigin:NSMakePoint(rect.origin.x,  rect.origin.y)];
    NSRect closeRect = cellFrame;
    closeRect.origin.x += ceilf(((cellFrame.size.width - _closeBtn.frame.size.width)/2.0))  + 40;
    closeRect.origin.y += ceilf((cellFrame.size.height - _closeBtn.frame.size.height)/2.0);
    [_closeBtn setFrameOrigin:NSMakePoint(closeRect.origin.x, closeRect.origin.y)];
    [controlView addSubview:self.arrowBtn];
    [controlView addSubview:self.closeBtn];
    [super drawWithFrame:cellFrame inView:controlView];
}

@end