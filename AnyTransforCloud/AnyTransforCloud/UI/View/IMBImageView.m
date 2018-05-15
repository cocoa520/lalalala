//
//  IMBImageView.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-8.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBImageView.h"

@implementation IMBImageView
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

//设置可以拖拽窗口
-(BOOL)mouseDownCanMoveWindow {
    return YES;
}


@end
