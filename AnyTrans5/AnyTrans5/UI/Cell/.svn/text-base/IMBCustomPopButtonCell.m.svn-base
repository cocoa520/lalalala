//
//  IMBCustomPopButtonCell.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCustomPopButtonCell.h"

@implementation IMBCustomPopButtonCell


-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:self.title];
    /* if your values can be attributed strings, make them white when selected */
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:self.lineBreakMode];
    [textParagraph setAlignment:self.alignment];
    
    if (titleStr != nil) {
        [titleStr addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, [titleStr length])];
        NSRect rect = [self titleRectForBounds:cellFrame];
        [titleStr drawWithRect: rect
                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
        [titleStr release];
    }
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = [super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = self.attributedStringValue;
    NSMutableAttributedString *titleStr = [attrString mutableCopy];
    NSRect textRect = NSZeroRect;
    if (titleStr != nil) {
        textRect = [titleStr boundingRectWithSize: titleFrame.size
                                          options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
        [titleStr release];
    }
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.x = titleFrame.origin.x + 8;
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height + 2;
        titleFrame.size.width -= 4;
    }
    titleFrame.size.width -= 2;
    return titleFrame;
}
@end
