//
//  IMBBackgroundView.m
//  IMBFolderOrFileButton
//
//  Created by iMobie on 14-7-3.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBSelectionView.h"
#import "StringHelper.h"

@implementation IMBSelectionView
@synthesize selectionColor = _selectionColor;
@synthesize selected = _selected;
- (id)initWithFrame:(NSRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        [self setNeedsDisplay:YES];
    }
}

- (void)setSelectionColor:(NSColor *)backgroundColor
{
    if (_selectionColor != backgroundColor) {
        [_selectionColor release];
        _selectionColor = [backgroundColor retain];
        [self setNeedsDisplay:YES];
    }
}
- (void)drawRect:(NSRect)dirtyRect
{
    if (NSEqualSizes(self.frame.size, dirtyRect.size)) {
        
        if (_selected) {
            NSBezierPath *backgroundpath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
            [[NSColor colorWithDeviceRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:1] setFill];
            [backgroundpath fill];
        }else
        {
            NSBezierPath *backgroundpath = [NSBezierPath bezierPathWithRect:dirtyRect];
            [[NSColor clearColor] setFill];
            [backgroundpath fill];
        }

    }else
    {
        if (_selected) {
            NSBezierPath *backgroundpath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:5];
            [[NSColor colorWithDeviceRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:1] setFill];
            [backgroundpath fill];
        }else
        {
            NSBezierPath *backgroundpath = [NSBezierPath bezierPathWithRect:self.bounds];
            [[NSColor clearColor] setFill];
            [backgroundpath fill];
        }

    }
    
}


-(void)dealloc
{
    [_selectionColor release],_selectionColor = nil;
    [super dealloc];
}
@end
