//
//  IMBTabTableView.m
//  iMobieTrans
//
//  Created by iMobie on 14-6-12.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBTabTableView.h"

@implementation IMBTabTableView
@synthesize selectionHighlightColor= _selectionHighlightColor;
@synthesize backgroundimage = _backgroundimage;
@synthesize rightBorder = _rightBorder;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _rightBorder = NO;
}
- (void)drawRect:(NSRect)dirtyRect
{
    //画背景图片
    if (_backgroundimage) {
        int imageWidth = _backgroundimage.size.width;
        int imageHeight = _backgroundimage.size.height;
        
        int xCount = ceil(self.frame.size.width / imageWidth);
        int yCount = ceil(self.frame.size.height / imageHeight);
        
        
        for (int i = 0; i < xCount; i ++) {
            for (int j = 0; j < yCount; j ++) {
                [_backgroundimage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
            }
        }
    }
    
    //画右边的border
    if (_rightBorder) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(self.bounds.size.width, self.bounds.size.height)];
        [path lineToPoint:NSMakePoint(self.bounds.size.width, 0)];
        [[NSColor colorWithCalibratedRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:1.0] setStroke];
        //[[NSColor redColor] setStroke];
        [path stroke];
    }
   
   [super drawRect:dirtyRect];
}

- (NSMenu *)menuForEvent:(NSEvent*)event {
    [[self window] makeFirstResponder:self];
    
    NSPoint menuPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    
    int row = [self rowAtPoint:menuPoint];
    if (row >= 0)
    {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        
    }
    if (row < 0 )
    {
        
        return nil;
        
    }
    else
    {
        return self.menu;
    }
}

- (void)setBackgroundimage:(NSImage *)backgroundimage
{
    if (_backgroundimage != backgroundimage) {
        [_backgroundimage release];
        _backgroundimage = [backgroundimage retain];
        [self setNeedsDisplay:YES];
    }
}
//设置高亮颜色
- (id)_highlightColorForCell:(id)cell
{

    if ([self selectionHighlightStyle] != -1) {
        return _selectionHighlightColor;
    }
    
    return nil;
}

- (void)dealloc
{
    [_selectionHighlightColor release],_selectionHighlightColor = nil;
    [_backgroundimage release],_backgroundimage = nil;
    [super dealloc];
}

@end
