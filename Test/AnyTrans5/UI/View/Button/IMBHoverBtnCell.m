//
//  IMBHoverBtnCell.m
//  DataRecovery
//
//  Created by iMobie on 5/5/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBHoverBtnCell.h"

@implementation IMBHoverBtnCell
@synthesize leftImage = _leftImage;
@synthesize rightImage = _rightImage;
@synthesize middleImage = _middleImage;

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView  {
    frame.origin.x = (controlView.frame.size.width - title.size.width) / 2;
    return [super drawTitle:[self attributedTitle] withFrame:frame inView:controlView];
}

- (void)dealloc
{
    if (_leftImage != nil) {
        [_leftImage release];
        _leftImage = nil;
    }
    if (_rightImage != nil) {
        [_rightImage release];
        _rightImage = nil;
    }
    if (_middleImage != nil) {
        [_middleImage release];
        _middleImage = nil;
    }
    [super dealloc];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    if (_leftImage != nil && _rightImage != nil && _middleImage != nil) {
        float xPos = 0;
        float yPos = 0;
        NSRect drawingRect;
        NSRect imageRect;
        // 开始绘制左边的部分
        imageRect.origin = NSZeroPoint;
        imageRect.size = _leftImage.size;
        drawingRect.origin.x = xPos;
        drawingRect.origin.y = yPos;
        drawingRect.size = imageRect.size;
        xPos += imageRect.size.width;
        
        if (drawingRect.size.width > 0) {
            [_leftImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        
        // 开始绘制中间的部分
        imageRect.size = _middleImage.size;
        int drawCount = ceil((cellFrame.size.width - _leftImage.size.width - _rightImage.size.width) / imageRect.size.width);
        for (int i = 0; i < drawCount; i++) {
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size = imageRect.size;
            xPos += imageRect.size.width;
            
            if (drawingRect.size.width > 0) {
                [_middleImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }
        
        // 开始绘制右边的部分
        imageRect.size = _rightImage.size;
        drawingRect.origin.x = cellFrame.size.width - imageRect.size.width;
        drawingRect.origin.y = yPos;
        drawingRect.size = imageRect.size;
        
        if (drawingRect.size.width > 0) {
            [_rightImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

@end
