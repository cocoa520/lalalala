//
//  IMBFunctionButtonCell.m
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBFunctionButtonCell.h"

@implementation IMBFunctionButtonCell

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView  {
   
    NSRect rect = frame;
    rect.origin.y += 74;
    if (title.size.width<76) {
        rect.size.width = title.size.width;
        rect.origin.x = (80 - title.size.width)/2;
        rect.origin.y -= 3;
    }else
    {
        rect.size.width = 76;
        rect.origin.x = 2;
        rect.origin.y -= 3;
    }
   
//    [title drawInRect:rect];
    return [super drawTitle:[self attributedTitle] withFrame:rect inView:controlView];
//    return rect;
}

- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView {
    float yPos = 0;
    float xPos = 0;
    if (image != nil) {
        yPos = 8;
        xPos = (80 - frame.size.width) / 2;
        NSRect drawingRect;         // 将图片绘制到的区域
        
        // 用来苗素图片信息
        NSRect imageRect;
        imageRect.origin = NSMakePoint(0, 0);
        imageRect.size = image.size;
        
        drawingRect.origin.x = xPos;
        drawingRect.origin.y = yPos;
        drawingRect.size.width = imageRect.size.width;
        drawingRect.size.height = imageRect.size.height;
        
        [image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//    NSLog(@"color:%@",self.backgroundColor);
    
    [super drawWithFrame:cellFrame inView:controlView];
//     [self setBackgroundStyle:NSBackgroundStyleLight];
    
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super highlight:NO withFrame:cellFrame inView:controlView];
}
- (NSRect)titleRectForBounds:(NSRect)theRect
{
    NSRect rect;
    rect.origin.x = 0;
    rect.origin.y = 5;
    rect.size.width  = 80;
    rect.size.height = 30;
    return rect;
    
}

- (NSBackgroundStyle)backgroundStyle
{
    return NSBackgroundStyleLight;
}

@end
