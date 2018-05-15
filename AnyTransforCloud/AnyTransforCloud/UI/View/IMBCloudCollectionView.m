//
//  IMBCloudCollectionView.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/7.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCloudCollectionView.h"
#import "IMBAllCloudViewController.h"

@implementation IMBCloudCollectionView
@synthesize collDelegate = _collDelegate;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)dealloc
{
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingMouseMoved;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL overClose = NO;
    for (NSView *view in self.subviews) {
        overClose = NSMouseInRect(mousePt,[view frame], [self isFlipped]);
        if (overClose) {
            break;
        }
    }
    if (!overClose) {
        if (_collDelegate && [_collDelegate respondsToSelector:@selector(cancelSelectState:)]) {
            [_collDelegate cancelSelectState:NSOffState];
        }
    }
    
    [super mouseDown:theEvent];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL overClose = NO;
    for (NSView *view in self.subviews) {
        overClose = NSMouseInRect(mousePt,[view frame], [self isFlipped]);
        if (overClose) {
            break;
        }
    }
    if (!overClose) {
        if (_collDelegate && [_collDelegate respondsToSelector:@selector(cancelSelectState:)]) {
            [_collDelegate cancelSelectState:NSOffState];
        }
    }
    
    [super rightMouseDown:theEvent];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    [super mouseMoved:theEvent];
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL overClose = NO;
    for (NSView *view in self.subviews) {
        overClose = NSMouseInRect(mousePt,[view frame], [self isFlipped]);
        if (overClose) {
            [view mouseEntered:theEvent];
        }else {
            [view mouseExited:theEvent];
        }
    }
}

@end
