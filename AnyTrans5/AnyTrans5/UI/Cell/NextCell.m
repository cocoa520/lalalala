//
//  NextCell.m
//  AnyTrans
//
//  Created by m on 16/12/14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "NextCell.h"
@implementation NextCell
@synthesize nextBtn = _nextBtn;
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSRect rect = cellFrame;
    rect.origin.x += ceilf(((cellFrame.size.width - _nextBtn.frame.size.width)/2.0));
    rect.origin.y += ceilf((cellFrame.size.height - _nextBtn.frame.size.height)/2.0);
    [self.nextBtn setFrameOrigin:NSMakePoint(rect.origin.x,  rect.origin.y)];
    [controlView addSubview:self.nextBtn];
    [super drawWithFrame:cellFrame inView:controlView];
}


@end
