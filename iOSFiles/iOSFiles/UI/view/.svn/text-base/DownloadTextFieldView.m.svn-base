//
//  DownloadTextFieldView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "DownloadTextFieldView.h"
@implementation DownloadTextFieldView
@synthesize borderColor = _borderColor;
@synthesize needGrowWidth = _needGrowWidth;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    _needGrowWidth = YES;
    [self setBordered:NO];
    [self setEditable:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
}

- (void)setNeedGrowWidth:(BOOL)needGrowWidth
{
    _needGrowWidth = needGrowWidth;
    if (_needGrowWidth) {
        [self setEditable:NO];
    }else{
        [self setEditable:YES];
    }
}

- (void)setTextColor:(NSColor *)color
{
    DownloadTextFieldCell *cell = [[DownloadTextFieldCell alloc] init];
    cell.stringValue = self.stringValue;
    cell.font = self.font;
    cell.textColor = color;
    [self setCell:cell];
    [cell release];
    [super setTextColor:color];
}

- (void)setNoNeedTextColor:(NSColor *)color
{
    [super setTextColor:color];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
    [path setLineWidth:2];
    [_borderColor setStroke];
    [path addClip];
    [path stroke];
}

- (void)setStringValue:(NSString *)aString
{
    [super setStringValue:aString];
    if (_needGrowWidth) {
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:(aString?aString:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,nil]];
        int lengthInt = 0;
        
        lengthInt = title.size.width +16;
        [self setFrameSize:NSMakeSize(lengthInt, self.frame.size.height)];
        [self setNeedsDisplay:YES];
        [title release];
        title = nil;

    }
}

@end

@implementation DownloadTextFieldCell

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:self.stringValue];
    /* if your values can be attributed strings, make them white when selected */
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:self.lineBreakMode];
    [textParagraph setAlignment:self.alignment];
    
    if (titleStr != nil) {
        [titleStr addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, [titleStr length])];
        [titleStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, [titleStr length])];
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
        titleFrame.origin.x = (NSWidth(theRect) - textRect.size.width)/2.0 ;
        titleFrame.origin.y = (theRect.size.height - textRect.size.height) / 2.0 + 2;
        titleFrame.size.height = textRect.size.height + 2;
        titleFrame.size.width -= 4;
    }
    titleFrame.size.width -= 2;
    return titleFrame;
}


@end
