//
//  IMBiCloudButton.m
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBiCloudButton.h"
#import "StringHelper.h"

@implementation IMBiCloudButton
@synthesize buttonName = _buttonName;
@synthesize isTableRowSelected = _isTableRowSelected;
@synthesize isMouseEnter = _isMouseEnter;
- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:buttonName];
        _btnCell = [[IMBHoverBtnCell alloc] init];
        [self setCell:_btnCell];
        _buttonName = [buttonName retain];
        _buttonType = exitButton;
        [self setButtonType:NSMomentaryPushInButton];
        [self setBezelStyle:NSTexturedSquareBezelStyle];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
        [self setBordered:NO];
        // [self sizeToFit];
        [self getButtonImageName:prefixImageName];
        [self setAttributedTitle:[self attributedTitle:NO]];
        [self setNeedsDisplay:YES];
    }
    return self;
}
- (void)setButtonNameWithprefixImageName:(NSString *)buttonName prefixImageName:(NSString *)prefixImageName {
    if (self) {
        [self setTitle:buttonName];
        _btnCell = [[IMBHoverBtnCell alloc] init];
        [self setCell:_btnCell];
        _buttonName = [buttonName retain];
        _buttonType = exitButton;
        [self setButtonType:NSMomentaryPushInButton];
        [self setBezelStyle:NSTexturedSquareBezelStyle];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
        [self setBordered:NO];
        // [self sizeToFit];
        [self getButtonImageName:prefixImageName];
        [self setAttributedTitle:[self attributedTitle:NO]];
        [self setNeedsDisplay:YES];
    }
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
    if (_btnCell != nil) {
        [_btnCell release];
        _btnCell = nil;
    }
    [super dealloc];
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
	_trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)getButtonImageName:(NSString *)prefixImageName {
    _leftImageName = [[NSString stringWithFormat:@"%@_left",prefixImageName] retain];
    _rightImageName = [[NSString stringWithFormat:@"%@_right",prefixImageName] retain];
    _middleImageName = [[NSString stringWithFormat:@"%@_middle",prefixImageName] retain];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self.isEnabled) {
        if (_buttonType == enteredButton) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_middleImageName]];
        }else if (_buttonType == exitButton) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }else if (_buttonType == upButton) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }else if (_buttonType == downButton) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_middleImageName]];
        }else {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }
    }else {
        _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",_leftImageName]];
        _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",_rightImageName]];
        _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",_middleImageName]];
    }
    
    [super drawRect:dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _buttonType = downButton;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _buttonType = upButton;
    [self setNeedsDisplay:YES];
    
    NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
    BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
    if (mouseInside) {
        if (self.target != nil && self.action != nil && self.isEnabled) {
            if ([self.target respondsToSelector:self.action]) {
                [self.target performSelector:self.action withObject:self];
            }
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _buttonType = enteredButton;
    _isMouseEnter = YES;
     [self setAttributedTitle:[self attributedTitle:YES]];
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _isMouseEnter = NO;
    _buttonType = exitButton;
     [self setAttributedTitle:[self attributedTitle:NO]];
    [self setNeedsDisplay:YES];
}

-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered{
    if (_buttonName) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:_buttonName]autorelease];
//        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
//        if (isEntered) {
//             [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:75.f/255 green:195.f/255 blue:158.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
////            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, _buttonName.length)];
//        }else {
//            if ([_buttonName isEqualToString:CustomLocalizedString(@"button_id_4", nil)]) {
////                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, _buttonName.length)];
//                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:75.f/255 green:195.f/255 blue:158.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
//            }
//            else {
////                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, _buttonName.length)];
//                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:18.0/255 green:200.0/255 blue:143.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
//            }
//        }
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"icloud_button_text_color", nil)] range:NSMakeRange(0, _buttonName.length)];
        return attributedTitles;
    }
    return nil;
}

- (void)setTablerowSelectRowFontColor{
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:_buttonName]autorelease];
//    if (_isTableRowSelected) {
//        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, _buttonName.length)];
//    }else{
//        if (_isMouseEnter) {
//            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, _buttonName.length)];
//        }else{
//            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:18.0/255 green:200.0/255 blue:143.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
//        }
//
//    }
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"icloud_button_text_color", nil)] range:NSMakeRange(0, _buttonName.length)];
    
    [self setAttributedTitle:attributedTitles];
//    [self setNeedsDisplay:YES];
}

@end
