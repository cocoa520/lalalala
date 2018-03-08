//
//  CenterTextFieidCell.m
//  AppDemo
//
//  Created by zhang yang on 13-3-6.
//  Copyright (c) 2013年 iMobie. All rights reserved.
//

#import "IMBCenterTextFieldCell.h"
#import "IMBCommonDefine.h"

@implementation IMBCenterTextFieldCell
@synthesize nodeDetail = _nodeDetail;
@synthesize mouseMoveNodeDetail = _mouseMoveNodeDetail;
@synthesize titleColor = _titleColor;
@synthesize fontSize = _fontSize;
@synthesize hilightTitleColor = _hilightTitleColor;
@synthesize loadingView = _loadingView;
@synthesize isLoading = _isLoading;
- (id)init
{
    if (self = [super init]) {
        [self initProperties];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initProperties];
}

- (void)initProperties
{
    _titleColor = [COLOR_TEXT_ORDINARY retain];
    _hilightTitleColor = [COLOR_TEXT_ORDINARY retain];
    _fontSize = 12.0f;
    _isLoading = NO;
}

- (void)dealloc
{
    [_titleColor release],_titleColor = nil;
    [_hilightTitleColor release], _hilightTitleColor = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    IMBCenterTextFieldCell *cell = (IMBCenterTextFieldCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_titleColor = [_titleColor retain];
    cell->_hilightTitleColor = [_hilightTitleColor retain];
    return cell;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSRect rect = cellFrame;
    rect.origin.x += ceilf(cellFrame.size.width - _loadingView.frame.size.width)/2.0 + 19;
    rect.origin.y += ceilf((cellFrame.size.height - _loadingView.frame.size.height)/2.0);
    [self.loadingView setFrameOrigin:NSMakePoint(rect.origin.x,  rect.origin.y)];
    if (_isLoading) {
        if (![_loadingView superview]) {
            [controlView addSubview:_loadingView];
            [_loadingView startAnimation];
        }
    }else{
        if ([_loadingView superview]) {
            [_loadingView removeFromSuperview];
            [_loadingView endAnimation];
        }
    }
    [super drawWithFrame:cellFrame inView:controlView];
}


-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    NSAttributedString *attrString = self.attributedStringValue;
    NSMutableAttributedString *titleStr = [attrString mutableCopy];
    if (_isLoading) {
        [titleStr release];
        titleStr = nil;
    }
    
    /* if your values can be attributed strings, make them white when selected */
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:self.lineBreakMode];
    [textParagraph setAlignment:self.alignment];
    if (self.isHighlighted&& self.backgroundStyle == NSBackgroundStyleDark ) {
        [titleStr addAttribute: NSForegroundColorAttributeName
                         value: _hilightTitleColor
                         range: NSMakeRange(0, titleStr.length) ];
        [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
        
    } else {
        if (controlView == [[controlView window] firstResponder]) {
            
            [titleStr addAttribute: NSForegroundColorAttributeName
                             value: _titleColor
                             range: NSMakeRange(0, titleStr.length) ];
            [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
            
        }else
        {
            if (!self.isHighlighted) {
                [titleStr addAttribute: NSForegroundColorAttributeName
                                 value: _titleColor
                                 range: NSMakeRange(0, titleStr.length) ];
                
                [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
            }else
            {
                [titleStr addAttribute: NSForegroundColorAttributeName
                                 value: COLOR_TEXT_ORDINARY
                                 range: NSMakeRange(0, titleStr.length) ];
                
                [titleStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize] range:NSMakeRange(0, [titleStr length])];
            }
        }
    }
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
    return titleFrame;
}

@end
