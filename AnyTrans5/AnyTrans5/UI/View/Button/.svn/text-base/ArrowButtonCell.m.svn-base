//
//  ArrowButtonCell.m
//  PhoneClean3.0
//
//  Created by apple on 13-9-18.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "ArrowButtonCell.h"
#import "HoverButton.h"
#import "StringHelper.h"
static float ImageWidth = 14;
static float ImageHeight = 14;
@implementation ArrowButtonCell
@synthesize enterIMage = _enterImage;
@synthesize defaultImage = _defaultImage;
@synthesize btn = _btn;
- (id)copyWithZone:(NSZone *)zone {
    ArrowButtonCell *cell = (ArrowButtonCell *)[super copyWithZone:zone];
    cell->_enterImage = [_enterImage retain];
    cell->_defaultImage = [_defaultImage retain];
    return cell;
}

- (void)awakeFromNib
{
    [self setAllowsMixedState:YES];
    _enterImage = [[StringHelper imageNamed:@"bookmark_close2"] retain];
    _defaultImage = [[StringHelper imageNamed:@"bookmark_close1"] retain];
    _btn = [[HoverButton alloc] init];
    [_btn setMouseEnteredImage:[StringHelper imageNamed:@"bookmark_close2"] mouseExitImage:[StringHelper imageNamed:@"bookmark_close1"] mouseDownImage:[StringHelper imageNamed:@"bookmark_close3"]];
    [_btn setFrame:NSMakeRect(0, 0, 20, 20)];
}



- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//    NSRect rect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, ImageWidth, ImageHeight);
//    rect.origin.x += (cellFrame.size.width - ImageWidth)/2.0 ;
//    rect.origin.y += (cellFrame.size.height - ImageHeight)/2.0 + 1;
//    
//    [_defaultImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
     [_btn setFrame:NSMakeRect(cellFrame.origin.x+ 2, cellFrame.origin.y + 2, _btn.frame.size.width, _btn.frame.size.height)];
    [controlView addSubview:_btn];
}

- (void)dealloc
{
    if (_enterImage) {
        [_enterImage release];
        _enterImage = nil;
    }
    if (_defaultImage) {
        [_defaultImage release];
        _defaultImage = nil;
    }

    [super dealloc];
}

@end