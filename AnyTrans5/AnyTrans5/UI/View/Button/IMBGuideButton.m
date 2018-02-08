//
//  IMBGuideButton.m
//  AnyTrans
//
//  Created by iMobie on 10/20/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBGuideButton.h"
#import "StringHelper.h"
#import "IMBGeneralBtnCell.h"
#import "IMBSoftWareInfo.h"
@implementation IMBGuideButton
@synthesize buttonName = _buttonName;
@synthesize isChange = _isChange;
- (id)initWithFrame:(NSRect)frame WithButtonName:(NSString *)buttonName {
    self = [super initWithFrame:frame];
    if (self) {
        IMBGeneralBtnCell *cell = [[IMBGeneralBtnCell alloc] init];
        [self setCell:cell];
        [cell release];
        _isChange = NO;
        [self setButtonName:buttonName];
        [self setImagePosition:NSNoImage];
        [self setBordered:NO];
        [self setButtonImage];
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (void)dealloc
{
    if (_arrowImage != nil) {
        [_arrowImage release];
        _arrowImage = nil;
    }
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    if (_mouseDownImg != nil) {
        [_mouseDownImg release];
        _mouseDownImg = nil;
    }
    if (_mouseEnterImg != nil) {
        [_mouseEnterImg release];
        _mouseEnterImg = nil;
    }
    if (_mouseExiteImg != nil) {
        [_mouseExiteImg release];
        _mouseExiteImg = nil;
    }
    [super dealloc];
}

- (void)reSetInit:(NSString *)btnName isChange:(BOOL)isChange {
    IMBGeneralBtnCell *cell = [[IMBGeneralBtnCell alloc] init];
    [self setCell:cell];
    //系统为阿拉伯语的时候skip按钮的位置修改
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [cell setIsSkip:NO];
    }else {
       [cell setIsSkip:isChange];
    }
    
    [cell release];
    _isChange = isChange;
    [self setButtonName:btnName];
    [self setImagePosition:NSNoImage];
    [self setBordered:NO];
    [self setButtonImage];
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

- (void)mouseDownImg:(NSImage *)mouseDownImg mouseEnterImg:(NSImage *)mouseEnterImg mouseExiteImg:(NSImage *)mouseExiteImg
{
    _mouseDownImg = [mouseDownImg retain];
    _mouseEnterImg = [mouseEnterImg retain];
    _mouseExiteImg = [mouseExiteImg retain];
}

- (void)setButtonImage {
//    _bgImage = [[StringHelper imageNamed:@"guide_btn_bg"] retain];
    _arrowImage = [[StringHelper imageNamed:@"reg_buy_arrow1"] retain];
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
        if (!_isChange) {
//            if (_bgImage != nil) {
//                imageRect.origin = NSZeroPoint;
//                imageRect.size = _bgImage.size;
//                
//                drawingRect.origin = NSZeroPoint;
//                drawingRect.size = dirtyRect.size;
//                [_bgImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
//            }
            if (_buttonType == MouseOut||_buttonType == MouseUp) {
                if (_mouseExiteImg != nil) {
                    imageRect.origin = NSZeroPoint;
                    imageRect.size = _mouseExiteImg.size;

                    drawingRect.origin = NSZeroPoint;
                    drawingRect.size = dirtyRect.size;
                    [_mouseExiteImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }else if (_buttonType == MouseEnter){
                if (_mouseEnterImg != nil) {
                    imageRect.origin = NSZeroPoint;
                    imageRect.size = _mouseEnterImg.size;
                    
                    drawingRect.origin = NSZeroPoint;
                    drawingRect.size = dirtyRect.size;
                    [_mouseEnterImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }else if (_buttonType == MouseDown){
                if (_mouseDownImg != nil) {
                    imageRect.origin = NSZeroPoint;
                    imageRect.size = _mouseDownImg.size;
                    
                    drawingRect.origin = NSZeroPoint;
                    drawingRect.size = dirtyRect.size;
                    [_mouseDownImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }else{
                if (_mouseExiteImg != nil) {
                    imageRect.origin = NSZeroPoint;
                    imageRect.size = _mouseExiteImg.size;
                    
                    drawingRect.origin = NSZeroPoint;
                    drawingRect.size = dirtyRect.size;
                    [_mouseExiteImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }
        }
//        if (_arrowImage != nil) {
//            imageRect.origin = NSZeroPoint;
//            imageRect.size = _arrowImage.size;
//            
//            drawingRect.origin = NSMakePoint(dirtyRect.size.width - _arrowImage.size.width - 20, (dirtyRect.size.height - _arrowImage.size.height) / 2);
//            drawingRect.size = _arrowImage.size;
//            
//            [_arrowImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
//        }
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
        
//        BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
//        if (mouseInside) {
//            if (theEvent.clickCount == 1&&self.target != nil && self.action != nil && self.isEnabled) {
                if ([self.target respondsToSelector:self.action]) {
                    [self.target performSelector:self.action withObject:self];
                }
//            }
//        }
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
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:16] range:NSMakeRange(0, _buttonName.length)];
        if (_isChange) {
            if (_buttonType == MouseOut||_buttonType == MouseUp) {
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] range:NSMakeRange(0, _buttonName.length)];
            }else if (_buttonType == MouseDown){
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] range:NSMakeRange(0, _buttonName.length)];
            }else if (_buttonType == MouseEnter){
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] range:NSMakeRange(0, _buttonName.length)];
            }else{
          [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] range:NSMakeRange(0, _buttonName.length)];
            }
        }else{
            if (isEntered) {
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)] range:NSMakeRange(0, _buttonName.length)];
            }
            [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
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
