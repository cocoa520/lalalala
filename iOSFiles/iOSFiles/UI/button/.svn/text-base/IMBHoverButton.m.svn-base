//
//  IMBHoverButton.m
//  DataRecovery
//
//  Created by iMobie on 5/5/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBHoverButton.h"
#import "StringHelper.h"

@implementation IMBHoverButton
@synthesize buttonName = _buttonName;

- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:buttonName];
        _btnCell = [[IMBHoverBtnCell alloc] init];
        [self setCell:_btnCell];
        _buttonName = [buttonName retain];
        _buttonType = ExitButton;
        [self setButtonType:NSMomentaryPushInButton];
        [self setBezelStyle:NSTexturedSquareBezelStyle];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
        [self setBordered:NO];
       // [self sizeToFit];
        [self getButtonImageName:prefixImageName];
        [self setAttributedTitle:[self attributedTitle:NO]];
        [self.superview setNeedsDisplay:YES];
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
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)getButtonImageName:(NSString *)prefixImageName {
    _leftImageName = [[NSString stringWithFormat:@"%@_left",prefixImageName] retain];
    _rightImageName = [[NSString stringWithFormat:@"%@_right",prefixImageName] retain];
    _middleImageName = [[NSString stringWithFormat:@"%@_middle",prefixImageName] retain];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self.isEnabled) {
        if (_buttonType == EnteredButton) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_middleImageName]];
        }else if (_buttonType == ExitButton) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }else if (_buttonType == UpButton) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }else if (_buttonType == DownButton) {
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
    _buttonType = DownButton;
    [self.superview setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _buttonType = UpButton;
    [self.superview setNeedsDisplay:YES];
    
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
    _buttonType = EnteredButton;
    [self.superview setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _buttonType = ExitButton;
    [self.superview setNeedsDisplay:YES];
}

-(NSMutableAttributedString *)attributedTitle:(BOOL)isEntered{
    if (_buttonName) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:_buttonName]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
        if (isEntered) {
            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:77.0/255 green:131.0/255 blue:213.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
        }else {
//            if ([_buttonName isEqualToString:@"Recover from Backup"]) {
//                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, _buttonName.length)];
//                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
//            }else if ([_buttonName isEqualToString:@"Start Scan"]) {
//                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, _buttonName.length)];
//                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
//            }else
            if ([_buttonName isEqualToString:@"Add Playlist"]) {
                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, _buttonName.length)];
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:75.f/255 green:195.f/255 blue:158.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
            }
//                else if ([_buttonName isEqualToString:@"Connect your iOS Device"]) {
//                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, _buttonName.length)];
//                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
//            }else if ([_buttonName isEqualToString:@"Start Now"]) {
//                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, _buttonName.length)];
//                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
//            }
            else {
                [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, _buttonName.length)];
                [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
            }
        }
        return attributedTitles;
    }
    return nil;
}

@end
