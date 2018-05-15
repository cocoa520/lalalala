//
//  IMBOutlineView.m
//  AnyTransforCloud
//
//  Created by hym on 01/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBOutlineView.h"
#import "IMBTableRowView.h"
@implementation IMBOutlineView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row {
    return NSZeroRect;
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

- (void)dealloc {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}



@end
