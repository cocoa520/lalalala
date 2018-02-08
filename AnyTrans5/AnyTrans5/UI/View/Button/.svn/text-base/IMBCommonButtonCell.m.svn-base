//
//  IMBCommonButtonCell.m
//  PhoneClean3.0
//
//  Created by Pallas on 8/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBCommonButtonCell.h"
#import "StringHelper.h"

@implementation IMBCommonButtonCell
@synthesize mouseStatus = _mouseStatus;
@synthesize textOffsetY = _textOffsetY;
@synthesize borderColor = _borderColor;
@synthesize lineWeight = _lineWeight;
@synthesize radius = _radius;
@synthesize prefixMouseOutPicName = _prefixMouseOutPicName;
@synthesize middleMouseOutPicName = _middleMouseOutPicName;
@synthesize suffixMouseOutPicName = _suffixMouseOutPicName;
@synthesize prefixMouseEnterPicName = _prefixMouseEnterPicName;
@synthesize middleMouseEnterPicName = _middleMouseEnterPicName;
@synthesize suffixMouseEnterPicName = _suffixMouseEnterPicName;
@synthesize prefixMouseDownPicName = _prefixMouseDownPicName;
@synthesize middleMouseDownPicName = _middleMouseDownPicName;
@synthesize suffixMouseDownPicName = _suffixMouseDownPicName;

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView {
    frame.origin.y -= self.textOffsetY;
    return [super drawTitle:[self attributedTitle] withFrame:frame inView:controlView];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    float pixHeight = 0;
    if (self.mouseStatus == MouseEnter || self.mouseStatus == MouseUp) {
        NSImage *bglImg = [StringHelper imageNamed:self.prefixMouseEnterPicName];
        NSImage *bgmImg = [StringHelper imageNamed:self.middleMouseEnterPicName];
        NSImage *bgrImg = [StringHelper imageNamed:self.suffixMouseEnterPicName];
        if (bglImg != nil && bgmImg != nil && bgrImg != nil) {
            pixHeight = bglImg.size.height;
            NSRect lineRect  = NSZeroRect;
            lineRect.size = NSMakeSize(cellFrame.size.width - 2, pixHeight - 2);
            lineRect.origin = NSMakePoint(cellFrame.origin.x + 1, ((cellFrame.size.height - pixHeight) / 2) + 1);
            NSBezierPath *path =  nil;
            if (self.borderColor != nil && self.lineWeight > 0) {
                [self.borderColor set];
                path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:self.radius yRadius:self.radius];
                [path fill];
            }
            
            // 先绘制头和尾，再绘制中间的部分
            float xPos = 0;             // 计算当前绘制的x坐标
            float yPos = (cellFrame.size.height - bglImg.size.height) / 2;
            float remainWeight = cellFrame.size.width;
            NSRect drawingRect;         // 将图片绘制到的区域
            
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = bglImg.size;
            
            // 开始绘制左边的部分
            if (imageRect.size.width <= remainWeight) {
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = imageRect.size.width;
                drawingRect.size.height = imageRect.size.height;
                xPos += imageRect.size.width;
                remainWeight -= imageRect.size.width;
            } else {
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = remainWeight;
                drawingRect.size.height = imageRect.size.height;
                xPos += remainWeight - xPos;
                remainWeight -= remainWeight;
            }
            if (drawingRect.size.width > 0) {
                [bglImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
            
            // 开始绘制右边的部分
            if (remainWeight > 0) {
                imageRect.size = bgrImg.size;
                if (imageRect.size.width <= remainWeight) {
                    drawingRect.origin.x = cellFrame.size.width - imageRect.size.width;
                    drawingRect.origin.y = yPos;
                    drawingRect.size.width = imageRect.size.width;
                    drawingRect.size.height = imageRect.size.height;
                    remainWeight -= imageRect.size.width;
                } else {
                    drawingRect.origin.x = xPos;
                    drawingRect.origin.y = yPos;
                    drawingRect.size.width = remainWeight;
                    drawingRect.size.height = imageRect.size.height;
                    remainWeight -= remainWeight;
                }
                if (drawingRect.size.width > 0) {
                    [bgrImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }
            
            // 开始绘制中间的部分
            if (remainWeight > 0) {
                imageRect.size = bgmImg.size;
                int drawCount = ceil(remainWeight / imageRect.size.width);
                for (int i = 0; i < drawCount; i++) {
                    if (imageRect.size.width <= remainWeight) {
                        drawingRect.origin.x = xPos;
                        drawingRect.origin.y = yPos;
                        drawingRect.size.width = imageRect.size.width;
                        drawingRect.size.height = imageRect.size.height;
                        xPos += imageRect.size.width;
                        remainWeight -= imageRect.size.width;
                    } else {
                        drawingRect.origin.x = xPos;
                        drawingRect.origin.y = yPos;
                        drawingRect.size.width = remainWeight;
                        drawingRect.size.height = imageRect.size.height;
                        xPos += remainWeight - xPos;
                        remainWeight -= remainWeight;
                    }
                    if (drawingRect.size.width > 0) {
                        [bgmImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                    }
                }
            }
            
            if (self.borderColor != nil && self.lineWeight > 0) {
                [path setLineWidth:self.lineWeight];
                [path stroke];
            }
        }
    } else if (self.mouseStatus == MouseDown) {
        NSImage *bglImg = [StringHelper imageNamed:self.prefixMouseDownPicName];
        NSImage *bgmImg = [StringHelper imageNamed:self.middleMouseDownPicName];
        NSImage *bgrImg = [StringHelper imageNamed:self.suffixMouseDownPicName];
        float yPos = (cellFrame.size.height - bglImg.size.height) / 2;
        if (bglImg != nil && bgmImg != nil && bgrImg != nil) {
            pixHeight = bglImg.size.height;
            NSRect lineRect  = NSZeroRect;
            lineRect.size = NSMakeSize(cellFrame.size.width - 2, pixHeight - 2);
            lineRect.origin = NSMakePoint(cellFrame.origin.x + 1, ((cellFrame.size.height - pixHeight) / 2) + 1);
            NSBezierPath *path =  nil;
            if (self.borderColor != nil && self.lineWeight > 0) {
                [self.borderColor set];
                path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:self.radius yRadius:self.radius];
                [path fill];
            }
            
            // 先绘制头和尾，再绘制中间的部分
            float xPos = 0;             // 计算当前绘制的x坐标
            float remainWeight = cellFrame.size.width;
            NSRect drawingRect;         // 将图片绘制到的区域
            
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = bglImg.size;
            
            // 开始绘制左边的部分
            if (imageRect.size.width <= remainWeight) {
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = imageRect.size.width;
                drawingRect.size.height = imageRect.size.height;
                xPos += imageRect.size.width;
                remainWeight -= imageRect.size.width;
            } else {
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = remainWeight;
                drawingRect.size.height = imageRect.size.height;
                xPos += remainWeight - xPos;
                remainWeight -= remainWeight;
            }
            if (drawingRect.size.width > 0) {
                [bglImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
            
            // 开始绘制右边的部分
            if (remainWeight > 0) {
                imageRect.size = bgrImg.size;
                if (imageRect.size.width <= remainWeight) {
                    drawingRect.origin.x = cellFrame.size.width - imageRect.size.width;
                    drawingRect.origin.y = yPos;
                    drawingRect.size.width = imageRect.size.width;
                    drawingRect.size.height = imageRect.size.height;
                    remainWeight -= imageRect.size.width;
                } else {
                    drawingRect.origin.x = xPos;
                    drawingRect.origin.y = yPos;
                    drawingRect.size.width = remainWeight;
                    drawingRect.size.height = imageRect.size.height;
                    remainWeight -= remainWeight;
                }
                if (drawingRect.size.width > 0) {
                    [bgrImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }
            
            // 开始绘制中间的部分
            if (remainWeight > 0) {
                imageRect.size = bgmImg.size;
                int drawCount = ceil(remainWeight / imageRect.size.width);
                for (int i = 0; i < drawCount; i++) {
                    if (imageRect.size.width <= remainWeight) {
                        drawingRect.origin.x = xPos;
                        drawingRect.origin.y = yPos;
                        drawingRect.size.width = imageRect.size.width;
                        drawingRect.size.height = imageRect.size.height;
                        xPos += imageRect.size.width;
                        remainWeight -= imageRect.size.width;
                    } else {
                        drawingRect.origin.x = xPos;
                        drawingRect.origin.y = yPos;
                        drawingRect.size.width = remainWeight;
                        drawingRect.size.height = imageRect.size.height;
                        xPos += remainWeight - xPos;
                        remainWeight -= remainWeight;
                    }
                    if (drawingRect.size.width > 0) {
                        [bgmImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                    }
                }
            }
            
            if (self.borderColor != nil && self.lineWeight > 0) {
                [path setLineWidth:self.lineWeight];
                [path stroke];
            }
        }
    } else {
        NSImage *bglImg = [StringHelper imageNamed:self.prefixMouseOutPicName];
        NSImage *bgmImg = [StringHelper imageNamed:self.middleMouseOutPicName];
        NSImage *bgrImg = [StringHelper imageNamed:self.suffixMouseOutPicName];
        float yPos = (cellFrame.size.height - bglImg.size.height) / 2;
        if (bglImg != nil && bgmImg != nil && bgrImg != nil) {
            pixHeight = bglImg.size.height;
            NSRect lineRect  = NSZeroRect;
            lineRect.size = NSMakeSize(cellFrame.size.width - 2, pixHeight - 2);
            lineRect.origin = NSMakePoint(cellFrame.origin.x + 1, ((cellFrame.size.height - pixHeight) / 2) + 1);
            NSBezierPath *path =  nil;
            if (self.borderColor != nil && self.lineWeight > 0) {
                [self.borderColor set];
                path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:self.radius yRadius:self.radius];
                [path fill];
            }
            
            // 先绘制头和尾，再绘制中间的部分
            float xPos = 0;             // 计算当前绘制的x坐标
            float remainWeight = cellFrame.size.width;
            NSRect drawingRect;         // 将图片绘制到的区域
            
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = bglImg.size;
            
            // 开始绘制左边的部分
            if (imageRect.size.width <= remainWeight) {
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = imageRect.size.width;
                drawingRect.size.height = imageRect.size.height;
                xPos += imageRect.size.width;
                remainWeight -= imageRect.size.width;
            } else {
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = remainWeight;
                drawingRect.size.height = imageRect.size.height;
                xPos += remainWeight - xPos;
                remainWeight -= remainWeight;
            }
            if (drawingRect.size.width > 0) {
                [bglImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
            
            // 开始绘制右边的部分
            if (remainWeight > 0) {
                imageRect.size = bgrImg.size;
                if (imageRect.size.width <= remainWeight) {
                    drawingRect.origin.x = cellFrame.size.width - imageRect.size.width;
                    drawingRect.origin.y = yPos;
                    drawingRect.size.width = imageRect.size.width;
                    drawingRect.size.height = imageRect.size.height;
                    remainWeight -= imageRect.size.width;
                } else {
                    drawingRect.origin.x = xPos;
                    drawingRect.origin.y = yPos;
                    drawingRect.size.width = remainWeight;
                    drawingRect.size.height = imageRect.size.height;
                    remainWeight -= remainWeight;
                }
                if (drawingRect.size.width > 0) {
                    [bgrImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }
            
            // 开始绘制中间的部分
            if (remainWeight > 0) {
                imageRect.size = bgmImg.size;
                int drawCount = ceil(remainWeight / imageRect.size.width);
                for (int i = 0; i < drawCount; i++) {
                    if (imageRect.size.width <= remainWeight) {
                        drawingRect.origin.x = xPos;
                        drawingRect.origin.y = yPos;
                        drawingRect.size.width = imageRect.size.width;
                        drawingRect.size.height = imageRect.size.height;
                        xPos += imageRect.size.width;
                        remainWeight -= imageRect.size.width;
                    } else {
                        drawingRect.origin.x = xPos;
                        drawingRect.origin.y = yPos;
                        drawingRect.size.width = remainWeight;
                        drawingRect.size.height = imageRect.size.height;
                        xPos += remainWeight - xPos;
                        remainWeight -= remainWeight;
                    }
                    if (drawingRect.size.width > 0) {
                        [bgmImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                    }
                }
            }
            
            if (self.borderColor != nil && self.lineWeight > 0) {
                [path setLineWidth:self.lineWeight];
                [path stroke];
            }
        }
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

@end
