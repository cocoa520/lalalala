//
//  IMBCheckCell.m
//  MacClean
//
//  Created by LuoLei on 15-5-13.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import "IMBCheckBoxCell.h"
@implementation IMBCheckBoxCell
@synthesize onImage =_onImage;
@synthesize offIMage = _offImage;
@synthesize outlineCheck = _outlineCheck;
@synthesize specifyCheck = _specifyCheck;
@synthesize isEmpty = _isEmpty;
@synthesize isMessageCell = _isMessageCell;
@synthesize isoutlineviewcell;
@synthesize isSubNodeCell;
@synthesize isStatue;
@synthesize isHaveValue;

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
    if (self.tag == 1) {
        [self setAllowsMixedState:NO];
        _onImage = [[NSImage imageNamed:@"itu_select1"] retain];
        _onhigHlightImage = [[NSImage imageNamed:@"itu_select1"] retain];
        _offImage = [[NSImage imageNamed:@"itu_default1"] retain];
        _offhigHlightImage = [[NSImage imageNamed:@"itu_default2"] retain];
        _mixedImage = [[NSImage imageNamed:@"itu_default1"] retain];
        _mixedHighlightImage = [[NSImage imageNamed:@"itu_default2"] retain];
        
        CheckBoxWidth = 16.0;
        CheckBoxHeight = 16.0;
    }else {
        [self setAllowsMixedState:YES];
        _onImage = [[NSImage imageNamed:@"box_select1"] retain];
        _onhigHlightImage = [[NSImage imageNamed:@"box_select1"] retain];
        _offImage = [[NSImage imageNamed:@"box_default1"] retain];
        _offhigHlightImage = [[NSImage imageNamed:@"box_default1"] retain];
        _mixedImage = [[NSImage imageNamed:@"box_mix_select1"] retain];
        _mixedHighlightImage = [[NSImage imageNamed:@"box_mix_select1"] retain];
        
        CheckBoxWidth = 14.0;
        CheckBoxHeight = 14.0;
    }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    
    NSRect rect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, CheckBoxWidth, CheckBoxHeight);
    if (_isMessageCell) {
        rect.origin.x += cellFrame.size.width - CheckBoxWidth;
        rect.origin.y += (cellFrame.size.height - CheckBoxHeight)/2.0 ;
    }else{
        if (_specifyCheck) {
            rect.origin.x += (cellFrame.size.width - CheckBoxWidth) - 6;
            rect.origin.y += (cellFrame.size.height - CheckBoxHeight)/2.0 + 1;
        }else {
            if (_outlineCheck) {
                rect.origin.x += (cellFrame.size.width - CheckBoxWidth) - 4;
                rect.origin.y += (cellFrame.size.height - CheckBoxHeight)/2.0 + 1;
            }else {
                rect.origin.x += cellFrame.size.width - CheckBoxWidth;
                //            rect.origin.x += (cellFrame.size.width - CheckBoxWidth)/2.0;
                rect.origin.y += (cellFrame.size.height - CheckBoxHeight)/2.0 + 1;
            }
        }

    }
  
   
    if (!_isEmpty) {
        NSInteger row = 0;
        NSTableView *tableView = (NSTableView*)controlView;
        row = [tableView rowAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.width/2.0, cellFrame.origin.y+cellFrame.size.height/2.0)];
        if (self.state == NSOnState) {
            if ([tableView isRowSelected:row]) {
                if (isoutlineviewcell) {
                    if (isStatue) {
                        [_onhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                    }else{
                        if (isHaveValue) {
                              [_onhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                        }else{
                              [_onhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                        }
                    }
                }else{
                    [_onhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }
                //            if (controlView == [[controlView window] firstResponder]) {
                              //            }else
                //            {
                //                [_onImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                //            }
            }else {
                if (_outlineCheck) {
                    if (isStatue) {
                        [_onImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                    }else{
                        if (isHaveValue) {
                            [_onImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                        }else{
                            [_onImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                        }
                    }
                }else{
                    [_onImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }
            }
        }else if(self.state == NSOffState)
        {
            if ([tableView isRowSelected:row]) {
                //            if (controlView == [[controlView window] firstResponder]) {
                if (_outlineCheck) {
                    if (isStatue) {
                        [_offhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                    }else{
                        if (isHaveValue) {
                            [_offhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                        }else{
                            [_offhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                        }
                    }
                }else{
                    [_offhigHlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }
                //            }else
                //            {
                //                [_offImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                //            }
                //
            }else
            {
                if (_outlineCheck) {
                    if (isStatue) {
                        [_offImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                    }else{
                        if (isHaveValue) {
                            [_offImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                        }else{
                            [_offImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                        }
                    }
                }else{
                    [_offImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }
            }
            
        }else if (self.state == NSMixedState)
        {
            if ([tableView isRowSelected:row]) {
                //            if (controlView == [[controlView window] firstResponder]) {
                if (_outlineCheck) {
                    if (isStatue) {
                        [_mixedHighlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                    }else{
                        if (isHaveValue) {
                            [_mixedHighlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                        }else{
                            [_mixedHighlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                        }
                    }
                }else{
                    [_mixedHighlightImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }
                //            }else
                //            {
                //                [_mixedImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                //            }
            }else {
                if (_outlineCheck) {
                    if (isStatue) {
                        [_mixedImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                    }else{
                        if (isHaveValue) {
                            [_mixedImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                        }else{
                            [_mixedImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.4 respectFlipped:YES hints:nil];
                        }
                    }
                }else{
                    [_mixedImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
                }
            }
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
