//
//  IMBCheckHeaderCell.m
//  MacClean
//
//  Created by Gehry on 1/20/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBCheckHeaderCell.h"
#import "IMBCommonDefine.h"
#import "StringHelper.h"

@implementation IMBCheckHeaderCell
@synthesize checkButton = _checkButton;
@synthesize backgroundgradient = _backgroundgradient;
@synthesize hasTitleBorderLine = _hasTitleBorderline;

#define TRIANGLE_WIDTH	8
#define TRIANGLE_HEIGHT	7
#define MARGIN_X		4
#define MARGIN_Y		5

#define LINE_MARGIN_Y	12

- (void)dealloc
{
    if (_backgroundgradient != nil ) {
        [_backgroundgradient release],
        _backgroundgradient = nil;
    }
    if (_checkButton != nil) {
        [_checkButton release];
        _checkButton = nil;
    }
    [super dealloc];
}


- (id)initWithCell:(NSTableHeaderCell*)cell
{
    self = [super initTextCell:[cell stringValue]];
    if (self) {
        _checkButton = [[IMBCheckButton alloc] initWithCheckImg:[StringHelper imageNamed:@"sel_all"] unCheckImg:[StringHelper imageNamed:@"sel_non"] mixImg:[StringHelper imageNamed:@"sel_sem"]];
        [_checkButton setFrameSize:NSMakeSize(14, 14)];
        [_checkButton setButtonType:NSSwitchButton];
        [_checkButton setEnabled:YES];
        [_checkButton setAllowsMixedState:YES];
        [_checkButton setState:NSOffState];
        
        NSArray* colorArray = [NSArray arrayWithObjects:
                               [NSColor whiteColor],
                               [NSColor whiteColor],
                               [NSColor whiteColor],
                               nil];
        if (_backgroundgradient != nil) {
            [_backgroundgradient release];
            _backgroundgradient = nil;
        }
        _backgroundgradient = [[NSGradient alloc] initWithColors:colorArray];
    }
    return self;
}

- (id)initWithSelectCell:(NSTableHeaderCell*)cell{
    self = [super initTextCell:[cell stringValue]];
    if (self) {
        NSArray* colorArray = [NSArray arrayWithObjects:
                               [NSColor whiteColor],
                               [NSColor whiteColor],
                               [NSColor whiteColor],
                               nil];
        if (_backgroundgradient != nil) {
            [_backgroundgradient release];
            _backgroundgradient = nil;
        }
        _backgroundgradient = [[NSGradient alloc] initWithColors:colorArray];
    }
    return self;
    
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    if (self.attributedStringValue.length != 0) {
        NSMutableAttributedString* attributedString =
        [[NSMutableAttributedString alloc] initWithAttributedString:
         [self attributedStringValue]];
        [attributedString setAlignment:textAlignment range:NSMakeRange(0, [attributedString length])];
        [self setAttributedStringValue: attributedString];
        [attributedString release];
    }
}

- (void)drawBackgroundInRect:(NSRect)rect hilighted:(BOOL)hilighted
{
    rect = NSMakeRect(NSMinX(rect) - 1 , NSMinY(rect) + 1, rect.size.width + 1, rect.size.height - 1);
    if (_hasTitleBorderline) {
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
        NSGraphicsContext *context = [NSGraphicsContext currentContext];
        [context saveGraphicsState];
        [[NSColor whiteColor] set];
        [context setShouldAntialias:NO];
        [path setLineWidth:1.0];
        [path stroke];
        [context restoreGraphicsState];
        
        NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        [gc saveGraphicsState];
        [gc setShouldAntialias:NO];
        
        path = [NSBezierPath bezierPath];
        [path setLineWidth:1.0];
        NSPoint p = NSMakePoint(rect.origin.x , rect.origin.y+2.0);
        [path moveToPoint:p];
        
        p.y += rect.size.height-2.0;
        [COLOR_TEXT_LINE setStroke];
        if (_hasLeftTitleBorderLine) {
            [path lineToPoint:p];
            p.x += rect.size.width;
            [path lineToPoint:p];
        }
        else{
            [path stroke];
            [path moveToPoint:p];
            p.x += rect.size.width;
            [path lineToPoint:p];
            
        }
        [path stroke];
        NSBezierPath* path1 = [NSBezierPath bezierPath];
        p = NSMakePoint(rect.origin.x , rect.origin.y+1.0);
        [path1 moveToPoint:p];
        p.x += rect.size.width;
        [path1 lineToPoint:p];
        [COLOR_TEXT_LINE setStroke];
        
        [path1 stroke];
        [gc restoreGraphicsState];
        
    }else
    {
        
        NSRect r = rect;
        r.origin.x = rect.origin.x;
        r.origin.y = rect.origin.y + 1;
        r.size.width = rect.size.width;
        r.size.height = rect.size.height - 2;
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
        NSGraphicsContext *context = [NSGraphicsContext currentContext];
        [context saveGraphicsState];
        [COLOR_TEXT_LINE set];
        [context setShouldAntialias:NO];
        [path setLineWidth:1.0];
        [path stroke];
        [context restoreGraphicsState];
        //        [_backgroundgradient retain];
        //        [_backgroundgradient drawInRect:r angle:90.0];
    }
    
}


- (void)_drawInRect:(NSRect)rect hilighted:(BOOL)hilighted
{
    
    [[NSColor whiteColor] set];
    NSRectFill(rect);
    //
    //    return;
    [self drawBackgroundInRect:rect hilighted:hilighted ];
    
    NSRect stringFrame = rect;
    if (_priority == 0) {
        NSAttributedString *string = [self attributedStringValue];
        if (string.string.length > 0) {
            NSRange range = NSMakeRange(0, string.length);
            NSParagraphStyle *style = [string attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&range];
            if (style.alignment == NSLeftTextAlignment) {
                stringFrame.size.width -= TRIANGLE_WIDTH;
                stringFrame.size.width -= 10;
                stringFrame.origin.x += 10;
            }
            else{
                stringFrame.size.width -= TRIANGLE_WIDTH;
            }
        }
        
    }
    else{
        NSAttributedString *string = [self attributedStringValue];
        NSRange range = NSMakeRange(0, string.length);
        if (string.length > 0) {
            NSParagraphStyle *style = [string attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&range];
            if (style.alignment == NSLeftTextAlignment) {
                stringFrame.origin.x += 10;
                stringFrame.size.width -= 10;
            }
        }
    }
    stringFrame.origin.y += LINE_MARGIN_Y;
    [[self attributedStringValue] drawInRect:stringFrame];
    
}



#pragma mark -
#pragma mark Overridden methods (NSCell)
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (_priority == 0) {
        [self _drawInRect:cellFrame hilighted:YES];
    } else {
        [self _drawInRect:cellFrame hilighted:NO];
    }
    if (!_hasTitleBorderline) {
        NSRect rect = controlView.frame;
        rect.origin.x = 46;
        rect.size.width = controlView.frame.size.width;
        NSBezierPath *path = [NSBezierPath bezierPath];
        
        [path moveToPoint:NSMakePoint(rect.origin.x, rect.origin.y)];
        [path lineToPoint:NSMakePoint(rect.size.width, rect.origin.y)];
        [COLOR_TEXT_LINE setStroke];
        [path stroke];
        NSBezierPath *path1 = [NSBezierPath bezierPath];
        if (_hasLeftTitleBorderLine) {
            [path1 moveToPoint:NSMakePoint(rect.origin.x, rect.origin.y)];
            [path1 lineToPoint:NSMakePoint(rect.origin.x, rect.size.height)];
            
        }
        else{
            [path1 moveToPoint:NSMakePoint(rect.origin.x, rect.size.height)];
        }
        [path1 lineToPoint:NSMakePoint(rect.size.width, rect.size.height)];
        [COLOR_TEXT_LINE setStroke];
        [path1 stroke];
        
    }
    if(_checkButton){
        if (![_checkButton superview]) {
            [_checkButton setFrame:NSMakeRect(ceilf((cellFrame.size.width- 2 - _checkButton.frame.size.width)/2.0)+1, (cellFrame.size.height - _checkButton.frame.size.height)/2.0+1, _checkButton.frame.size.width, _checkButton.frame.size.height)];
            [controlView addSubview:_checkButton];
        }
        else{
            [_checkButton setFrame:NSMakeRect(ceilf((cellFrame.size.width- 2 - _checkButton.frame.size.width)/2.0)+6, (cellFrame.size.height - _checkButton.frame.size.height)/2.0+1, _checkButton.frame.size.width, _checkButton.frame.size.height)];
        }
        
    }
}

- (NSRect)titleRectForBounds:(NSRect)theRect{
    NSRect titleFrame = [super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = self.attributedStringValue;
    NSRect textRect = [attrString boundingRectWithSize: titleFrame.size
                                               options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
    
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height;
    }
    return titleFrame;
    
}
//加了排序后无效了。需要在排序的方法前，显示高亮
- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self _drawInRect:cellFrame hilighted:YES];
    
    [self drawSortIndicatorWithFrame:cellFrame
                              inView:controlView
                           ascending:_ascending
                            priority:_priority];
    
}


- (void)drawSortIndicatorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView ascending:(BOOL)ascending priority:(NSInteger)priority
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    if (ascending) {
        NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - TRIANGLE_WIDTH - MARGIN_X,
                                cellFrame.origin.y + cellFrame.size.height - MARGIN_Y);
        [path moveToPoint:p];
        
        
        p.x += TRIANGLE_WIDTH/2.0;
        p.y -= TRIANGLE_HEIGHT;
        [path lineToPoint:p];
        
        p.x += TRIANGLE_WIDTH/2.0;
        p.y += TRIANGLE_HEIGHT;
        [path lineToPoint:p];
        
    } else {
        NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - TRIANGLE_WIDTH - MARGIN_X,
                                cellFrame.origin.y + MARGIN_Y);
        [path moveToPoint:p];
        
        
        p.x += TRIANGLE_WIDTH/2.0;
        p.y += TRIANGLE_HEIGHT;
        [path lineToPoint:p];
        
        p.x += TRIANGLE_WIDTH/2.0;
        p.y -= TRIANGLE_HEIGHT;
        [path lineToPoint:p];
        
    }
    
    [path closePath];
    
    if (_priority == 0) {
        [[NSColor whiteColor] set];
    } else {
        [[NSColor clearColor] set];
    }
    [path fill];
}

- (void)setSortAscending:(BOOL)ascending priority:(NSInteger)priority
{
    _ascending = ascending;
    _priority = priority;
}


@end
