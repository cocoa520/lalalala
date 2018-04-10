//
//  IMBTableViewBtnCell.m
//  PhoneRescue
//
//  Created by iMobie on 4/26/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBTableViewBtnCell.h"

@implementation IMBTableViewBtnCell
@synthesize deleteBtn = _deleteBtn;
@synthesize findBtn = _findBtn;
//@synthesize exportBtn = _exportBtn;

@synthesize tipText = _tipText;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [super drawWithFrame:cellFrame inView:controlView];
        // 当是卸状态的时候需要将卸载按钮弄到界面上
        int centerSpace = 50;
        int centerX = cellFrame.origin.x;
    
        if (![self.deleteBtn superview]) {
            [self.deleteBtn removeFromSuperview];
            int oringeRight = centerX + centerSpace/2;
            [self.deleteBtn setFrameOrigin:NSMakePoint(oringeRight +26, cellFrame.origin.y + (cellFrame.size.height - self.deleteBtn.frame.size.height) / 2)];
            [controlView addSubview:self.deleteBtn];
        }
    
        if (![self.findBtn superview]) {
            [self.findBtn removeFromSuperview];
            int oringeCenter = centerX  - self.findBtn.frame.size.width/2;
            [self.findBtn setFrameOrigin:NSMakePoint(oringeCenter +26, cellFrame.origin.y + (cellFrame.size.height - self.findBtn.frame.size.height) / 2)];
            [controlView addSubview:self.findBtn];
        }
}


@end
