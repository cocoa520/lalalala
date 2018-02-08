//
//  IMBGeneralButton.m
//  PhoneClean
//
//  Created by iMobie on 6/17/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import "IMBGeneralButton.h"
@implementation IMBGeneralButton
@synthesize isBackupSettingView = _isBackupSettingView;
@synthesize buttonName = _buttonName;
@synthesize isChange = _isChange;
@synthesize isCompleteView = _isCompleteView;
@synthesize isBigBtn = _isBigBtn;
@synthesize isRegisteredView = _isRegisteredView;
@synthesize isReslutVeiw = _isReslutVeiw;
@synthesize btnCell = _btnCell;
@synthesize bgImage = _bgImage;
@synthesize dic = _dic;
@synthesize disableColor = _disableColor;
- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName {
    self = [super initWithFrame:frame];
    if (self) {
        _isChange = NO;
        [self setTitle:buttonName];
        _btnCell = [[IMBGeneralBtnCell alloc] init];
        if (_isBigBtn) {
            _btnCell.isBigBtn = YES;
        }
        [self setCell:_btnCell];
        _buttonName = [buttonName retain];
        _buttonType = MouseOut;
//        [self setButtonType:NSMomentaryPushInButton];
//        [self setBezelStyle:NSTexturedSquareBezelStyle];
//        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
        [self setBordered:NO];
        [self setButtonImageName:prefixImageName];
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (void)setDic:(NSMutableDictionary *)dic {
    if (_dic != nil) {
        [_dic release];
        _dic = nil;
    }
    _dic = [[NSMutableDictionary alloc] initWithDictionary:dic];
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
    if (_disableImage != nil) {
        [_disableImage release];
        _disableImage = nil;
    }
    if (_defaultImage != nil) {
        [_defaultImage release];
        _defaultImage = nil;
    }
    if (_btnCell != nil) {
        [_btnCell release];
        _btnCell = nil;
    }
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    if (_dic != nil) {
        [_dic release];
        _dic = nil;
    }
    if (_disableColor != nil) {
        [_disableColor release];
        _disableColor = nil;
    }
    [super dealloc];
}

- (void)reSetInit:(NSString *)btnName WithPrefixImageName:(NSString *)prefixImageName {
    _isChange = NO;
    [self setTitle:btnName];
    _buttonName = [btnName retain];
    _buttonType = MouseOut;
    _btnCell = [[IMBGeneralBtnCell alloc] init];
    [self setCell:_btnCell];
//    [self setButtonType:NSMomentaryPushInButton];
//    [self setBezelStyle:NSTexturedSquareBezelStyle];
//    [self setAlignment:NSCenterTextAlignment];
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
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)setButtonImageName:(NSString *)prefixImageName {
    _leftImageName = [[NSString stringWithFormat:@"%@_left",prefixImageName] retain];
    _rightImageName = [[NSString stringWithFormat:@"%@_right",prefixImageName] retain];
    _middleImageName = [[NSString stringWithFormat:@"%@_min",prefixImageName] retain];
}

- (void)setIconImageName:(NSString *)iconName {
    _isChange = YES;
    _btnCell.isChange = YES;
    _defaultImage = [[NSImage imageNamed:[NSString stringWithFormat:@"%@1",iconName]] retain];
    _disableImage = [[NSImage imageNamed:[NSString stringWithFormat:@"%@2",iconName]] retain];
}

- (void)setDisableColor:(NSColor *)disableColor {
    if (_disableColor != nil) {
        [_disableColor release];
        _disableColor = nil;
    }
    _disableColor = [disableColor retain];
}

- (void)setEnabled:(BOOL)flag {
    [super setEnabled:flag];
    [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self.isEnabled) {
        if (_buttonType == MouseEnter) {
            _btnCell.leftImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@2",_leftImageName]];
            _btnCell.rightImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@2",_rightImageName]];
            _btnCell.middleImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@2",_middleImageName]];
        }else if (_buttonType == MouseOut) {
            _btnCell.leftImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }else if (_buttonType == MouseUp) {
            _btnCell.leftImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }else if (_buttonType == MouseDown) {
            _btnCell.leftImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@3",_leftImageName]];
            _btnCell.rightImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@3",_rightImageName]];
            _btnCell.middleImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@3",_middleImageName]];
        }else {
            _btnCell.leftImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }
    }else {
        _btnCell.leftImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@4",_leftImageName]];
        _btnCell.rightImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@4",_rightImageName]];
        _btnCell.middleImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@4",_middleImageName]];
    }
    
    [super drawRect:dirtyRect];
    
    NSRect drawingRect;
    NSRect imageRect;
    if (_isChange) {
        if (self.isEnabled) {
            if (_defaultImage != nil) {
                imageRect.origin = NSZeroPoint;
                imageRect.size = _defaultImage.size;
                
                drawingRect.origin = NSMakePoint(dirtyRect.size.width - 39, (self.bounds.size.height - _defaultImage.size.height) / 2);
                drawingRect.size = _defaultImage.size;
                
                [_defaultImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }else {
            if (_disableImage != nil) {
                imageRect.origin = NSZeroPoint;
                imageRect.size = _disableImage.size;
                
                drawingRect.origin = NSMakePoint(8, (self.bounds.size.height - _disableImage.size.height) / 2);
                drawingRect.size = _disableImage.size;
                
                [_disableImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }
    }
    
    if (_bgImage != nil) {
        imageRect.origin = NSZeroPoint;
        imageRect.size = _bgImage.size;
        drawingRect.origin = NSMakePoint(dirtyRect.size.width - imageRect.size.width, 0);
        drawingRect.size = imageRect.size;
        [_bgImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _evNum = theEvent.eventNumber;
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
        if (mouseInside && _evNum == theEvent.eventNumber) {
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
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
        
//        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
        
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];

    }
}

- (void)setFontSize:(float)size {
    _size = size;
    [self setNeedsDisplay:YES];
    [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
}

-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered{
    if (_buttonName) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:_buttonName]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
        if (_size) {
            [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:_size] range:NSMakeRange(0, _buttonName.length)];
        }else {
           [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:12] range:NSMakeRange(0, _buttonName.length)];
        }
    
        if (isEntered) {
            if (_buttonType == MouseEnter) {
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];//[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)]
            }else if (_buttonType == MouseOut || _buttonType == MouseUp) {
                if (_isReslutVeiw) {
                    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
                    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];//[StringHelper getColorFromString:CustomColor(@"generalBtn_other_exitColor", nil)]
                }else{
                    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
                    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];//[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)]
                }
             
            }else if (_buttonType == MouseDown) {

                [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];//[StringHelper getColorFromString:CustomColor(@"generalBtn_downColor", nil)]
            }else {
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];//[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)]
            }
        }else {
            if (_disableColor != nil) {
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:_disableColor range:NSMakeRange(0, _buttonName.length)];
            } else {
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];//[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]
            }
            
        }
        if (!_isChange) {
             [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
        }
       
        return attributedTitles;
    }
    return nil;
}

- (void)setButtonName:(NSString *)buttonName {
    _buttonName = [buttonName retain];
    [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
}



@end
