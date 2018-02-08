//
//  IMBSkinButton.m
//  AnyTrans
//
//  Created by iMobie on 10/20/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBSkinButton.h"
#import "StringHelper.h"

@implementation IMBSkinButton
@synthesize buttonName = _buttonName;
@synthesize isChange = _isChange;
@synthesize btnCell = _btnCell;
@synthesize skinName = _skinName;
- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName {
    self = [super initWithFrame:frame];
    if (self) {
        _isChange = NO;
        [self setTitle:@""];
        [self setButtonName:buttonName];
        _btnCell = [[IMBGeneralBtnCell alloc] init];
        [_btnCell setIsSkin:YES];
        [self setCell:_btnCell];
//        _buttonName = [buttonName retain];
        _buttonType = MouseOut;
        [self setImagePosition:NSNoImage];
        [self setBordered:NO];
        [self setButtonImageName:prefixImageName];
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (void)dealloc
{
    if (_leftImageName != nil) {
        [_leftImageName release];
        _leftImageName = nil;
    }
    if (_rightImageName != nil) {
        [_rightImageName release];
        _rightImageName = nil;
    }
    if (_middleImageName != nil) {
        [_middleImageName release];
        _middleImageName = nil;
    }
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    if (_applyImage != nil) {
        [_applyImage release];
        _applyImage = nil;
    }
    if (_downloadImage != nil) {
        [_downloadImage release];
        _downloadImage = nil;
    }
    if (_downloadEnterImage != nil) {
        [_downloadEnterImage release];
        _downloadEnterImage = nil;
    }
    if (_disableImage != nil) {
        [_disableImage release];
        _disableImage = nil;
    }
    if (_btnCell != nil) {
        [_btnCell release];
        _btnCell = nil;
    }
    [super dealloc];
}

- (void)reSetInit:(NSString *)btnName WithPrefixImageName:(NSString *)prefixImageName {
    _isChange = NO;
    [self setTitle:@""];
    [self setButtonName:btnName];
//    _buttonName = [btnName retain];
    _buttonType = MouseOut;
    _btnCell = [[IMBGeneralBtnCell alloc] init];
    [_btnCell setIsSkin:YES];
    [self setCell:_btnCell];
    [self setImagePosition:NSNoImage];
    [self setBordered:NO];
    [self setButtonImageName:prefixImageName];
    [self setNeedsDisplay:YES];
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)setButtonImageName:(NSString *)prefixImageName {
    if (_leftImageName != nil) {
        [_leftImageName release];
        _leftImageName = nil;
    }
    if (_rightImageName != nil) {
        [_rightImageName release];
        _rightImageName = nil;
    }
    if (_middleImageName != nil) {
        [_middleImageName release];
        _middleImageName = nil;
    }
    if (_applyImage != nil) {
        [_applyImage release];
        _applyImage = nil;
    }
    if (_downloadImage != nil) {
        [_downloadImage release];
        _downloadImage = nil;
    }
    if (_downloadEnterImage != nil) {
        [_downloadEnterImage release];
        _downloadEnterImage = nil;
    }
    if (_disableImage != nil) {
        [_disableImage release];
        _disableImage = nil;
    }
    _leftImageName = [[NSString stringWithFormat:@"%@_left",prefixImageName] retain];
    _rightImageName = [[NSString stringWithFormat:@"%@_right",prefixImageName] retain];
    _middleImageName = [[NSString stringWithFormat:@"%@_mid",prefixImageName] retain];
    _applyImage = [[StringHelper imageNamed:@"skin_apply"] retain];
    _downloadImage = [[StringHelper imageNamed:@"skin_download"] retain];
    _downloadEnterImage = [[StringHelper imageNamed:@"skin_download_enter"] retain];
    _disableImage = [[StringHelper imageNamed:@"skin_btn_selete"] retain];
}

- (void)setEnabled:(BOOL)flag {
    [super setEnabled:flag];
    if (flag) {
        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
    }else {
        [self setTitle:@""];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect drawingRect;
    NSRect imageRect;
    if (self.isEnabled) {
        [_btnCell setIsSkin:YES];
        if (_isChange) {
            if (_buttonType == MouseEnter) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_middleImageName]];
            }else if (_buttonType == MouseOut) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
            }else if (_buttonType == MouseUp) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
            }else if (_buttonType == MouseDown) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_middleImageName]];
            }else {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
            }
//
//            [[NSColor blackColor] set];
//            NSRectFill(dirtyRect);
            
            [_btnCell setIsApply:YES];
            if (_applyImage != nil) {
                _btnCell.applyImage = _applyImage;
//                imageRect.origin = NSZeroPoint;
//                imageRect.size = _applyImage.size;
//                
//                drawingRect.origin = NSMakePoint(20, (dirtyRect.size.height - _applyImage.size.height) / 2);
//                drawingRect.size = _applyImage.size;
//                
//                [_applyImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }else {
            if (_buttonType == MouseEnter) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_middleImageName]];
            }else if (_buttonType == MouseOut) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@5",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@5",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@5",_middleImageName]];
            }else if (_buttonType == MouseUp) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@5",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@5",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@5",_middleImageName]];
            }else if (_buttonType == MouseDown) {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_middleImageName]];
            }else {
                _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
                _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
                _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
            }
            
            [_btnCell setIsApply:NO];
            if (_buttonType == MouseUp || _buttonType == MouseOut) {
                [_btnCell setDownloadState:NO];
                if (_downloadImage != nil) {
                    _btnCell.downloadImage = _downloadImage;
//                    imageRect.origin = NSZeroPoint;
//                    imageRect.size = _downloadImage.size;
//                    
//                    drawingRect.origin = NSMakePoint(20, (dirtyRect.size.height - _downloadImage.size.height) / 2);
//                    drawingRect.size = _downloadImage.size;
//                    
//                    [_downloadImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }else {
                [_btnCell setDownloadState:YES];
                if (_downloadEnterImage != nil) {
                    _btnCell.downloadEnterImage = _downloadEnterImage;
//                    imageRect.origin = NSZeroPoint;
//                    imageRect.size = _downloadEnterImage.size;
//                    
//                    drawingRect.origin = NSMakePoint(20, (dirtyRect.size.height - _downloadEnterImage.size.height) / 2);
//                    drawingRect.size = _downloadEnterImage.size;
//                    
//                    [_downloadEnterImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }
        }
    }else {
        _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",_leftImageName]];
        _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",_rightImageName]];
        _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",_middleImageName]];
        
        [_btnCell setIsSkin:NO];
        [_btnCell setIsApply:NO];
        [_btnCell setDownloadState:NO];
        if (_disableImage != nil) {
            imageRect.origin = NSZeroPoint;
            imageRect.size = _disableImage.size;
            
            drawingRect.origin = NSMakePoint((dirtyRect.size.width - _disableImage.size.width) / 2, (dirtyRect.size.height - _disableImage.size.height) / 2);
            drawingRect.size = _disableImage.size;
            
            [_disableImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
    }
    
    [super drawRect:dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
        
        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _buttonType = MouseUp;
        [self setNeedsDisplay:YES];
        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
        NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
        
        BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
        if (mouseInside) {
            if (theEvent.clickCount == 1&&self.target != nil && self.action != nil && self.isEnabled) {
                if ([self.target respondsToSelector:self.action]) {
                    [self.target performSelector:self.action withObject:self];
                }
            }
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _buttonType = MouseEnter;
        [self setNeedsDisplay:YES];
        
        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
        
    }
}

-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered{
    if (_buttonName) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:_buttonName]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, _buttonName.length)];
        
        if (isEntered) {
            if (_isChange) {
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] range:NSMakeRange(0, _buttonName.length)];
            }else {
                if (_buttonType == MouseEnter) {
                    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] range:NSMakeRange(0, _buttonName.length)];
                }else if (_buttonType == MouseOut || _buttonType == MouseUp) {
                    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:NSMakeRange(0, _buttonName.length)];
                }else if (_buttonType == MouseDown) {
                    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] range:NSMakeRange(0, _buttonName.length)];
                }else {
                    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:NSMakeRange(0, _buttonName.length)];
                }
            }
        }else {
            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:NSMakeRange(0, _buttonName.length)];
        }
        return attributedTitles;
    }
    return nil;
}

- (void)setButtonName:(NSString *)buttonName {
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    _buttonName = [buttonName retain];
    [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
}

@end
