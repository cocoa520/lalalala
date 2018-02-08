//
//  IMBCustomShapeIView.m
//  MacClean
//
//  Created by LuoLei on 16-1-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCustomShapeView.h"

@implementation IMBCustomShapeView
@synthesize leftImage = _leftImage;
@synthesize middleImage = _middleImage;
@synthesize rightImage = _rightImage;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setLeftImage:(NSImage *)leftImage midImage:(NSImage *)midImage rightImage:(NSImage *)rightImage
{
    [_leftImage release];
    [_middleImage release];
    [_rightImage release];
    _leftImage = [leftImage retain];
    _middleImage = [midImage retain];
    _rightImage = [rightImage retain];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
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
    int drawCount = ceil((dirtyRect.size.width - _leftImage.size.width - _rightImage.size.width) / imageRect.size.width);
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
    drawingRect.origin.x = xPos;
    drawingRect.origin.y = yPos;
    drawingRect.size = imageRect.size;
    if (drawingRect.size.width > 0) {
        [_rightImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
}

- (void)dealloc
{
    [_leftImage release],_leftImage = nil;
    [_rightImage release],_rightImage = nil;
    [_middleImage release],_middleImage = nil;
    [super dealloc];
}
@end
