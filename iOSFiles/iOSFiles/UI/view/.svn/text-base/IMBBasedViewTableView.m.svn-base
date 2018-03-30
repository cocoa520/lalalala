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
@synthesize listener = _listener;
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
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:0 yRadius:0];
    if (_borderColor != nil) {
        [_borderColor setStroke];
        [path addClip];
        [path stroke];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    int row = (int)[self rowAtPoint:point];
    if ( row <0 ) {
        return;
    }
    NSRect rect = [self rectOfRow:row];
    int column1 = (int)[self columnWithIdentifier:@"CheckCol"];
    NSRect columRect = [self rectOfColumn:column1];
    //    IMBCheckBoxCell *cell = (IMBCheckBoxCell *)[self preparedCellAtColumn:column1 row:row];
    NSSize size = NSMakeSize(14, 14);//[cell cellSize];
    
    NSRect chekRect = NSMakeRect(0, 0, size.width, size.height);
    chekRect.origin.x = rect.origin.x +(columRect.size.width - size.width)/2+8;
    chekRect.origin.y = rect.origin.y + (rect.size.height - size.height)/2.0;
    if (NSMouseInRect(point, chekRect, [self isFlipped])) {
        _clickCheckBox = YES;
        [super mouseDown:theEvent];
        if ([_listener respondsToSelector:@selector(tableView:row:)]) {
            [_listener tableView:self row:row];
        }
    }else {
        _clickCheckBox = NO;
        [super mouseDown:theEvent];
    }
    //    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    //    if ([_listener respondsToSelector:@selector(loadViewBtn)]) {
    //        [_listener loadViewBtn];
    //    }
}

- (void)dealloc
{
    self.selectionHighlightColor = nil;
    [super dealloc];
}
@end
