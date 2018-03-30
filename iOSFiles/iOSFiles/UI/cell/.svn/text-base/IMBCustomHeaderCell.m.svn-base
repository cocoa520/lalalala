//
//  CustomHeaderCell.m
//  CustomHeaderSample
//
//  Created by Hiroshi Hashiguchi on 11/01/25.
//  Copyright 2011 . All rights reserved.
//

#import "IMBCustomHeaderCell.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"
@implementation IMBCustomHeaderCell
@synthesize backgroundgradient = _backgroundgradient;
@synthesize hasTitleBorderline = _hasTitleBorderline;
@synthesize hasLeftTitleBorderLine = _hasLeftTitleBorderLine;
@synthesize ascending =_ascending;
@synthesize isShowTriangle = _isShowTriangle;
@synthesize hasDiviation = _hasDiviation;
@synthesize diviationY = _diviationY;
#define TRIANGLE_WIDTH	8
#define TRIANGLE_HEIGHT	7
#define MARGIN_X		4
#define MARGIN_Y		5

#define LINE_MARGIN_Y	6

- (id)copyWithZone:(NSZone *)zone {
    IMBCustomHeaderCell *cell = (IMBCustomHeaderCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_descendingImage = [_descendingImage retain];
    cell->_ascendingImage = [_ascendingImage retain];
    cell->_backgroundgradient = [_backgroundgradient retain];
    return cell;
}

- (id)initWithCell:(NSTableHeaderCell*)cell
{
	self = [super initTextCell:[cell stringValue]];
	if (self) {
        
		NSMutableAttributedString* attributedString =
		[[[NSMutableAttributedString alloc] initWithAttributedString:
		  [cell attributedStringValue]] autorelease];
         [attributedString setAlignment:NSLeftTextAlignment range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_ORDINARY range:NSMakeRange(0, [attributedString length])];
    
        _hasLeftTitleBorderLine = true;
		[self setAttributedStringValue: attributedString];
                        
        NSArray* colorArray = [NSArray arrayWithObjects:
                               [NSColor whiteColor],
                               [NSColor whiteColor],
                               [NSColor whiteColor],
                               nil];

        _ascendingImage = [[NSImage imageNamed:@"list_arrow"] retain];
        _descendingImage  = [[NSImage imageNamed:@"list_arrow2"] retain];
        _backgroundgradient = [[NSGradient alloc] initWithColors:colorArray];
		_ascending = YES;
		_priority = 1;
        _isShowTriangle = NO;
        _hasTitleBorderline = YES;
	}
	return self;
	
}

- (void)setIsShowTriangle:(BOOL)isShowTriangle {
    _isShowTriangle = isShowTriangle;
}

- (void)setHasDiviation:(BOOL)hasDiviation {
    _hasDiviation = hasDiviation;
}

- (void)setDiviationY:(float)diviationY {
    _diviationY = diviationY;
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
    //NSLog(@"hilighted: %d",hilighted);
//	CGFloat delta = hilighted ? -0.075 : 0;
    if (_hasTitleBorderline) {
        [_backgroundgradient retain];
        [_backgroundgradient drawInRect:rect angle:90.0];
        NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        [gc saveGraphicsState];
        [gc setShouldAntialias:NO];
        
        NSBezierPath* path = [NSBezierPath bezierPath];
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
        //[[NSColor redColor] setStroke];
        [path1 stroke];
        [gc restoreGraphicsState];

    }else
    {
    
        NSRect r = rect;
        r.origin.x = rect.origin.x;
        r.origin.y = rect.origin.y + 1;
        r.size.width = rect.size.width;
        r.size.height = rect.size.height - 2;
        [_backgroundgradient retain];
        [_backgroundgradient drawInRect:r angle:90.0];
    }
}

- (void)_drawInRect:(NSRect)rect hilighted:(BOOL)hilighted
{
	[self drawBackgroundInRect:rect hilighted:hilighted ];
    
	NSRect stringFrame = rect;
	if (_priority == 0) {
        NSAttributedString *string = [self attributedStringValue];
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
	stringFrame.origin.y += LINE_MARGIN_Y ;
    if (_hasDiviation) {
        stringFrame.origin.y += LINE_MARGIN_Y -_diviationY;
    }
    
    if ([[IMBSoftWareInfo singleton] chooseLanguageType] == JapaneseLanguage || [[IMBSoftWareInfo singleton] chooseLanguageType] == ArabLanguage) {
        stringFrame.origin.y = 3;
    }
    
	[[self attributedStringValue] drawInRect:stringFrame];
}

#pragma mark Overridden methods (NSCell)
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect headerFrame = cellFrame;
    if (_priority == 0) {
		[self _drawInRect:cellFrame hilighted:YES];
	} else {
		[self _drawInRect:cellFrame hilighted:NO];
	}
    if (_isShowTriangle) {
        int dis = 14;
        NSSize imageSize = _ascendingImage.size;
        NSRect triangleRect = NSMakeRect(NSMaxX(headerFrame) - dis - imageSize.width/2 - 6, NSMidY(headerFrame) - imageSize.height/2, imageSize.width, imageSize.height);
        
        if (_ascending) {
            
            [_ascendingImage drawInRect:triangleRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
            
        }else{
            [_descendingImage drawInRect:triangleRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
            
        }
    }
    
//   
//    if (!_hasTitleBorderline) {
//        NSRect rect = controlView.frame;
//        rect.origin.x = 46;
//        rect.size.width = controlView.frame.size.width;
//        NSBezierPath *path = [NSBezierPath bezierPath];
//       
//        [path moveToPoint:NSMakePoint(rect.origin.x, rect.origin.y)];
//        [path lineToPoint:NSMakePoint(rect.size.width, rect.origin.y)];
//        [[NSColor colorWithDeviceRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
//        [path stroke];
//         NSBezierPath *path1 = [NSBezierPath bezierPath];
//        if (_hasLeftTitleBorderLine) {
//            [path1 moveToPoint:NSMakePoint(rect.origin.x, rect.origin.y)];
//            [path1 lineToPoint:NSMakePoint(rect.origin.x, rect.size.height)];
//
//        }
//        else{
//            [path1 moveToPoint:NSMakePoint(rect.origin.x, rect.size.height)];
//        }
//        [path1 lineToPoint:NSMakePoint(rect.size.width, rect.size.height)];
//        [[NSColor colorWithDeviceRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
//        [path1 stroke];
//
//    }
    
   
   

//	[self drawSortIndicatorWithFrame:cellFrame
//							  inView:controlView
//						   ascending:_ascending
//							priority:_priority];
   
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
    //NSLog(@"priority %d, ascending %d", priority, ascending);
    
    
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
		[COLOR_View_NORMAL set];
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

- (void)setBackgroundgradient:(NSGradient *)backgroundgradient {
    _backgroundgradient = [backgroundgradient retain];
}


- (void)dealloc
{
    if (_backgroundgradient != nil) {
        [_backgroundgradient release],
        _backgroundgradient = nil;
    }
    [_ascendingImage release],_ascendingImage = nil;
    [_descendingImage release],_descendingImage = nil;
    [super dealloc];
}

@end
