//
//  IMBBasedViewTableView.m
//  MacClean
//
//  Created by LuoLei on 15-12-10.
//  Copyright (c) 2015年 imobie. All rights reserved.
//

#import "IMBBasedViewTableView.h"

@implementation IMBBasedViewTableView
@synthesize selectionHighlightColor = _selectionHighlightColor;
@synthesize canSelect = _canSelect;
@synthesize borderColor = _borderColor;
- (void)awakeFromNib
{
    [self setGridColor:[NSColor colorWithCalibratedRed:208.0/255 green:208.0/255 blue:208.0/255 alpha:1.0]];
}

- (id)_highlightColorForCell:(id)cell
{
    if ([self selectionHighlightStyle] != -1) {
        return _selectionHighlightColor;
    }
    return nil;
}

- (void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend
{
    if (_canSelect) {
        [super selectRowIndexes:indexes byExtendingSelection:extend];
        [self setNeedsDisplay:YES];
    }
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
    if ([self.delegate respondsToSelector:@selector(scrollWheel:)]) {
        [self.delegate scrollWheel:theEvent];
    }
}

- (void)setBorderColor:(NSColor *)borderColor
{
    if (_borderColor != borderColor) {
        [_borderColor release];
        _borderColor = [borderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    if (_borderColor != nil) {
        [_borderColor setStroke];
        [path addClip];
        [path stroke];
    }
}

- (void)dealloc
{
    self.selectionHighlightColor = nil;
    [super dealloc];
}
@end
