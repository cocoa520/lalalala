//
//  IMBCheckCell.m
//  MacClean
//
//  Created by LuoLei on 15-5-13.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import "IMBCheckBoxCell.h"
#import "StringHelper.h"
static const float CheckBoxWidth=14.0;
static const float CheckBoxHeight=14.0;
@implementation IMBCheckBoxCell
@synthesize onImage =_onImage;
@synthesize offIMage = _offImage;
@synthesize outlineCheck = _outlineCheck;

- (id)copyWithZone:(NSZone *)zone {
    IMBCheckBoxCell *cell = (IMBCheckBoxCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_onImage = [_onImage retain];
    cell->_onhigHlightImage = [_onhigHlightImage retain];
    cell->_offImage = [_offImage retain];
    cell->_offhigHlightImage = [_offhigHlightImage retain];
    cell->_mixedImage = [_mixedImage retain];
    cell->_mixedHighlightImage = [_mixedHighlightImage retain];
    return cell;
}

- (void)awakeFromNib
{
    [self setAllowsMixedState:YES];
    _onImage = [[StringHelper imageNamed:@"sel_all"] retain];
    _onhigHlightImage = [[StringHelper imageNamed:@"sel_all2"] retain];
    _offImage = [[StringHelper imageNamed:@"sel_non"] retain];
    _offhigHlightImage = [[StringHelper imageNamed:@"sel_non2"] retain];
    _mixedImage = [[StringHelper imageNamed:@"sel_sem"] retain];
    _mixedHighlightImage = [[StringHelper imageNamed:@"sel_sem2"] retain];
}

- (void)reloadImage
{
    [_onImage release];
    [_onhigHlightImage release];
    [_offImage release];
    [_offhigHlightImage release];
    [_mixedHighlightImage release];
    _onImage = [[StringHelper imageNamed:@"sel_all"] retain];
    _onhigHlightImage = [[StringHelper imageNamed:@"sel_all2"] retain];
    _offImage = [[StringHelper imageNamed:@"sel_non"] retain];
    _offhigHlightImage = [[StringHelper imageNamed:@"sel_non2"] retain];
    _mixedImage = [[StringHelper imageNamed:@"sel_sem"] retain];
    _mixedHighlightImage = [[StringHelper imageNamed:@"sel_sem2"] retain];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect rect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, CheckBoxWidth, CheckBoxHeight);
    if (_outlineCheck) {
        rect.origin.x += (cellFrame.size.width - CheckBoxWidth)/2 +6;
        rect.origin.y += (cellFrame.size.height - CheckBoxHeight)/2.0 + 1;
    }else {
        rect.origin.x += (cellFrame.size.width - CheckBoxWidth)/2.0 ;
        rect.origin.y += (cellFrame.size.height - CheckBoxHeight)/2.0 + 1;
    }

    NSInteger row = 0;
    NSTableView *tableView = (NSTableView*)controlView;
    row = [tableView rowAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.width/2.0, cellFrame.origin.y+cellFrame.size.height/2.0)];
    if (self.state == NSOnState) {
        if ([tableView isRowSelected:row]) {
            if (self.backgroundStyle == NSBackgroundStyleDark) {
                [_onhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }else
            {
                [_onImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
        }else {
            [_onImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }else if(self.state == NSOffState)
    {
        if ([tableView isRowSelected:row]) {
            if (self.backgroundStyle == NSBackgroundStyleDark) {
                [_offhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }else
            {
                [_offImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
//
        }else
        {
            [_offImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
        
    }else if (self.state == NSMixedState)
    {
        if ([tableView isRowSelected:row]) {
            if (self.backgroundStyle == NSBackgroundStyleDark) {
                [_mixedHighlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }else
            {
                [_mixedImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
        }else {
            [_mixedImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }
}


- (void)dealloc
{
    if (_onImage) {
        [_onImage release];
        _onImage = nil;
    }
    if (_onhigHlightImage) {
        [_onhigHlightImage release];
        _onhigHlightImage = nil;
    }
    if (_offImage) {
        [_offImage release];
        _offImage = nil;
    }
    if (_offhigHlightImage) {
        [_offhigHlightImage release];
        _offhigHlightImage = nil;
    }
    if (_mixedImage) {
        [_mixedImage release];
        _mixedImage = nil;
    }
    if (_mixedHighlightImage) {
        [_mixedHighlightImage release];
        _mixedHighlightImage = nil;
    }
    [super dealloc];
}
@end
