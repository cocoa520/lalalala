//
//  IMBAddBookmarkPopupView.m
//  iMobieTrans
//
//  Created by iMobie on 14-8-29.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBAddBookmarkPopupView.h"

@implementation IMBAddBookmarkPopupView

- (void)awakeFromNib
{
    NSButton *addBookmark = [[NSButton alloc] initWithFrame:NSMakeRect(5, 5, 140, 25)];
    [addBookmark setTitle:CustomLocalizedString(@"Bookmark_id_4", nil)];
    [addBookmark setBordered:NO];
   [addBookmark setAction:@selector(addBookmark:)];
    addBookmark.tag = 100;
    NSButton *addFolder = [[NSButton alloc] initWithFrame:NSMakeRect(5, 35, 140, 25)];
    [addFolder setTitle:CustomLocalizedString(@"Bookmark_id_3", nil)];
    [addFolder setBordered:NO];
    [addFolder setAction:@selector(addFolder:)];
    addFolder.tag = 101;
    [self addSubview:addBookmark];
    [self addSubview:addFolder];
    [addFolder release];
    [addBookmark release];
}

- (void)drawRect:(NSRect)dirtyRect
{
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [[NSColor colorWithCalibratedRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0] setFill];
    [path fill];
    [[NSColor colorWithCalibratedRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:1.0] setStroke];
    [path stroke];
    
    NSBezierPath *path1= [NSBezierPath bezierPath];
    [path1 setLineWidth:0.2];
    [path1 moveToPoint:NSMakePoint(0, 33)];
    [path1 lineToPoint:NSMakePoint(150, 33)];
    [[NSColor colorWithCalibratedRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:1.0] setStroke];
    [path1 stroke];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
//    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];

}
@end
