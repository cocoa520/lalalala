//
//  IMBCustomTableView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/26.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCustomTableView.h"
#import "StringHelper.h"
#import "IMBTableRowView.h"

@implementation IMBCustomTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSImage *)dragImageForRowsWithIndexes:(NSIndexSet *)dragRows tableColumns:(NSArray *)tableColumns event:(NSEvent *)dragEvent offset:(NSPointPointer)dragImageOffset {
    NSPoint point = [self convertPoint:dragEvent.locationInWindow fromView:nil];
    NSImage * image = [super dragImageForRowsWithIndexes:dragRows tableColumns:tableColumns event:dragEvent offset:&point];
    
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(340, image.size.height)];
    
    [scalingimage lockFocus];
    
    [[NSColor clearColor] setFill];
    NSRectFill(NSMakeRect(0, 0, scalingimage.size.width, scalingimage.size.height));
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
    [image drawInRect:NSMakeRect(0, 0, scalingimage.size.width, scalingimage.size.height) fromRect:NSMakeRect(0, 0, scalingimage.size.width, scalingimage.size.height) operation:NSCompositeSourceOver fraction:1.0];

    NSString *countstr = [NSString stringWithFormat:@"%d",_selectedCount];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:countstr?:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] range:NSMakeRange(0, str.length)];

    NSRect drawRect = NSMakeRect(scalingimage.size.width - (str.size.width + 8), (scalingimage.size.height - (str.size.width + 8))/2.0, str.size.width + 8, str.size.width + 8);
    NSBezierPath *path = nil;

    path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:(str.size.width + 8)/2.0 yRadius:(str.size.width + 8)/2.0];
    
    [[StringHelper getColorFromString:CustomColor(@"tableView_drag_bgColor", nil)] setFill];
    [path fill];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setStroke];
    [path stroke];
    
    [str drawInRect:NSMakeRect(drawRect.origin.x+4,drawRect.origin.y +(drawRect.size.height - str.size.height )/2.0, str.size.width+8, str.size.height)];
    [str release];
    str = nil;
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(52, 2, scalingimage.size.width, scalingimage.size.height - 2)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    
    [scalingimage unlockFocus];
    [scalingimage release];
    NSImage *dragImage = [[[NSImage alloc] initWithData:tempdata] autorelease];
    return dragImage;
}

- (void)setListener:(id<IMBTableViewListener>)listener {
    _listener = listener;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseMoved|NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

//- (void)drawBackgroundInClipRect:(NSRect)clipRect {
//    
////    NSRect rect = self.bounds;
//    if (self.usesAlternatingRowBackgroundColors) {
//        [super drawBackgroundInClipRect:clipRect];
////        CGFloat height = rect.size.height;
////        CGFloat rowheight = [self rowHeight];
////        CGFloat width = rect.size.width;
////        NSInteger rowCount = floor(height/rowheight);
////        for (int i = 0; i<rowCount;i++) {
////            NSRect rowRect = NSMakeRect(0, i*rowheight, width, rowheight);
////            if (i%2==0) {
////                [[NSColor clearColor] setFill];
////                NSRectFill(rowRect);
////                [_alternatingEvenRowBackgroundColor setFill];
////                NSRectFill(rowRect);
////            }else
////            {
////                [[NSColor clearColor] setFill];
////                NSRectFill(rowRect);
////                [_alternatingOddRowBackgroundColor  setFill];
////                NSRectFill(rowRect);
////            }
////        }
////        
////        if (rowCount*rowheight<height) {
////            NSRect rect = NSMakeRect(0, rowCount*rowheight, width, height-rowCount*rowheight);
////            if (rowCount%2 == 0) {
////                [[NSColor clearColor] setFill];
////                NSRectFill(rect);
////                [_alternatingEvenRowBackgroundColor setFill];
////            }else
////            {
////                [[NSColor clearColor] setFill];
////                NSRectFill(rect);
////                [_alternatingOddRowBackgroundColor setFill];
////            }
////            NSRectFill(rect);
////        }
//    }else {
//        [super drawBackgroundInClipRect:clipRect];
//    }
//}
//
//- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {
//    NSColor* bgColor = Nil;
//    if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow]) {
//        if (row == _moveRow) {
//            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)];
//        }else {
//            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)];
//        }
//        
//    }else {
//        
//        if (self == [[self window] firstResponder] ) {
//            
//            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)];
//            
//        }else {
//            
//            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)];
//        }
//        
//    }
//    
//    NSIndexSet* selectedRowIndexes = [self selectedRowIndexes];
//    if ([selectedRowIndexes containsIndex:row]||(row == _moveRow) ) {
//        [[NSColor clearColor] setFill];
//        NSRectFill([self rectOfRow:row]);
//        [bgColor setFill];
//        NSRectFill([self rectOfRow:row]);
//    }
//    [super drawRow:row clipRect:clipRect];
//}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL overClose = NO;
    NSInteger totalRow = [self numberOfRows];
    for (int index=0;index<totalRow;index++) {
        IMBTableRowView *rowView = [self rowViewAtRow:index makeIfNecessary:NO];
        overClose = NSMouseInRect(mousePt,[rowView frame], [self isFlipped]);
        if (overClose) {
            [rowView mouseEntered:theEvent];
            if (rowView.subviews) {
                NSView *view = [rowView.subviews objectAtIndex:0];
                [view mouseEntered:theEvent];
            }
        }else {
            [rowView mouseExited:theEvent];
            if (rowView.subviews) {
                NSView *view = [rowView.subviews objectAtIndex:0];
                [view mouseExited:theEvent];
            }
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSInteger clickCount = theEvent.clickCount;
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    int row = (int)[self rowAtPoint:point];
    if ( row <0 ) {
        return;
    }
    if (clickCount == 1) {
        if ([_listener respondsToSelector:@selector(tableViewSingleClick:row:)]) {
            [_listener tableViewSingleClick:self row:row];
        }
    } else if (clickCount == 2) {
        if ([_listener respondsToSelector:@selector(tableViewDoubleClick:row:)]) {
            [_listener tableViewDoubleClick:self row:row];
        }
    }
    [super mouseDown:theEvent];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    int row = (int)[self rowAtPoint:point];
    if ( row <0 ) {
        return;
    }
    NSRect rect = [self rectOfRow:row];
    
    if (NSMouseInRect(point, rect, [self isFlipped])) {
        if ([_listener respondsToSelector:@selector(tableView:rightDownrow:)]) {
            [_listener tableView:self rightDownrow:row];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super rightMouseDown:theEvent];
    });
}

@end
