//
//  IMBSerachFieldCell.m
//  AnyTrans
//
//  Created by LuoLei on 16-10-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBSearchFieldCell.h"
#import "StringHelper.h"
#import "IMBFilpedView.h"
@implementation IMBSearchFieldCell
@synthesize searchBackgroundColor = _searchBackgroundColor;
@synthesize cursorColor = _cursorColor;
@synthesize searchBorderColor = _searchBorderColor;
- (id)copyWithZone:(NSZone *)zone {
    IMBSearchFieldCell *cell = (IMBSearchFieldCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_searchBackgroundColor = [_searchBackgroundColor retain];
    cell->_cursorColor = [_cursorColor retain];
    
    return cell;
}

- (void)awakeFromNib{
    imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(1, 6, 11, 11)];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSAttributedString *attrString = self.attributedStringValue;
    NSMutableAttributedString *titleStr = [attrString mutableCopy];
    [titleStr addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, titleStr.length)];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:self.lineBreakMode];
    if (titleStr != nil) {
        [titleStr addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, [titleStr length])];
        NSRect rect = [self titleRectForBounds:cellFrame];
        [titleStr drawWithRect: rect
                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
        [titleStr release];
    }
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
    //aRect = [self titleRectForBounds:aRect];
    [super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj {
    if (_cursorColor) {
        NSText *text = [super setUpFieldEditorAttributes:textObj];
        [(NSTextView*)text setInsertionPointColor:_cursorColor];
        return text;
    }else{
        return [super setUpFieldEditorAttributes:textObj];
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
        titleFrame.origin.x = titleFrame.origin.x + 2.0;
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0 - 2.0;
        titleFrame.size.height = textRect.size.height;
        titleFrame.size.width -= 4;
    }
    titleFrame.size.width -= 2;
    return titleFrame;
}



- (void)dealloc {
    [imageView release], imageView = nil;
    [_searchBackgroundColor release],_searchBackgroundColor = nil;
    [_cursorColor release], _cursorColor = nil;
    [super dealloc];
}
@end
