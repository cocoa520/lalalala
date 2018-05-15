//
//  IMBDeviceItem.m
//  iMobieTrans
//
//  Created by Pallas on 3/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBDeviceItem.h"
#import "CapacityView.h"
//#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "IMBMainViewController.h"
@implementation IMBDeviceItem
@synthesize index = _index;
@synthesize delegate = _delegate;
@synthesize target = _target;
@synthesize action = _action;
@synthesize cloudEntity = _cloudEntity;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _btnStatus = @"ExitStatus";
        nc = [NSNotificationCenter defaultCenter];
        _jumpHeadBtn = [[IMBDrawImageBtn alloc]initWithFrame:NSMakeRect(0, 0, 30, 20)];
        [_jumpHeadBtn setEnabled:YES];
        [_jumpHeadBtn setBordered:NO];
        [_jumpHeadBtn setTitle:@""];
        [_jumpHeadBtn setStringValue:@""];
        [_jumpHeadBtn mouseDownImage:[NSImage imageNamed:@"menu_top3"] withMouseUpImg:[NSImage imageNamed:@"menu_top2"] withMouseExitedImg:[NSImage imageNamed:@"menu_top"] mouseEnterImg:[NSImage imageNamed:@"menu_top2"]];
        [_jumpHeadBtn setTarget:self];
        [_jumpHeadBtn setAction:@selector(jumpHeadBtn:)];
    }
    return self;
}

- (void)updateTrackingAreas {
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

-(void)doChangeLanguage {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
    [[NSColor clearColor] set];
    [path fill];
    if (_cloudEntity.isBottomItem) {
        NSBezierPath *path1 = [NSBezierPath bezierPathWithRect:dirtyRect];
        [[StringHelper getColorFromString:CustomColor(@"choose_popoverBottomVIew_Color", nil)] set];
        [path1 fill];
        
//        NSColor *color = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_cloudEntity.name?:@""];
        [str addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:NSMakeRange(0, str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, str.length)];
        NSRect textRect2 = NSMakeRect(20 , -2, 166, 42);
        [str drawInRect:textRect2];
        if (str) {
            [str release];
            str = nil;
        }
    }else {
        if (_isSelected) {
            //背景
            NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
            [[StringHelper getColorFromString:CustomColor(@"choose_popoverView_clickColor", nil)] set];
            [path1 fill];
        }else {
            //背景
            NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
            if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
                [[StringHelper getColorFromString:CustomColor(@"choose_popoverView_enterColor", nil)] set];
            }else if (_mouseStatus == MouseDown) {
                [[StringHelper getColorFromString:CustomColor(@"choose_popoverView_clickColor", nil)] set];
            }else {
                [[NSColor clearColor] set];
            }
            [path1 fill];
        }

        if (_cloudEntity.image) {
//            if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp || _mouseStatus == MouseDown) {
//                NSRect imageFrame = NSMakeRect(10, 8, _cloudEntity.popoverHoverImage.size.width, _cloudEntity.popoverHoverImage.size.height);
//                [_cloudEntity.popoverHoverImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
//            }else {
                NSRect imageFrame = NSMakeRect(20, 6, 30, 30);
                [_cloudEntity.image drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
//            }
        }
        //画设备的名字
        if (_cloudEntity.name != nil) {
            NSSize size ;
            NSColor *color = nil;
            if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp || _mouseStatus == MouseDown) {
                color = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
            }else {
                color = [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)];
            }
            NSMutableAttributedString *attrStr = [self TruncatingTailForStringDrawing:_cloudEntity.name withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:100 withSize:&size withColor:color withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(20+18 + 20 + 6 , 10, size.width, 22);
            [attrStr drawInRect:textRect2];
        }
    }
}

- (void)drawLeftText:(NSString *)text withFrame:(NSRect)frame withFontSize:(float)withFontSize withColor:(NSColor *)color {
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:withFontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName ,sysFont ,NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
    
    NSSize textSize = [as.string sizeWithAttributes:attributes];
    NSSize maxSize = NSMakeSize(140, 20);
    if (textSize.width > maxSize.width ) {
        textSize = maxSize;
        NSAttributedString *as2 = [[NSAttributedString alloc]initWithString:@"..."];
        NSRect rect = NSMakeRect(frame.origin.x + textSize.width, frame.origin.y + (frame.size.height - textSize.height) / 2, 20, textSize.height);
        [as2.string drawInRect:rect withAttributes:attributes];
        [as2 release];
        as2 = nil;
    }
    NSRect f = NSMakeRect(frame.origin.x , frame.origin.y + (frame.size.height - textSize.height) / 2, textSize.width, textSize.height);
    [as.string drawInRect:f withAttributes:attributes];
    
    [as release];
    [style release];
}

//末尾是省略号。。。
- (NSMutableAttributedString*)TruncatingTailForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size withColor:(NSColor*)color withAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *retStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:lineSpacing];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [textParagraph setAlignment:alignment];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, font, NSFontAttributeName, color,NSForegroundColorAttributeName, [NSColor clearColor], NSBackgroundColorAttributeName, nil];
    
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:lineSpacing];
    [retStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    NSSize tmpSize = [layoutManager usedRectForTextContainer:textContainer].size;
    (*size).width = ceil(tmpSize.width);
    (*size).height = ceil(tmpSize.height);
    return retStr;
}

- (void)mouseUp:(NSEvent *)theEvent {
    _btnStatus = @"ExitStatus";
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner) {
        if (self.target != nil && self.action != nil) {
            if ([self.target respondsToSelector:self.action]) {
                [self.target performSelector:self.action withObject:self.cloudEntity];
            }
        }
    }
}

-(void)mouseDown:(NSEvent *)theEvent {
    _mouseStatus = MouseDown;
    [self setNeedsDisplay:YES];
}

-(void)mouseExited:(NSEvent *)theEvent {
    if ([_jumpHeadBtn superview]) {
         [_jumpHeadBtn removeFromSuperview];
    }
    _mouseStatus = MouseOut;
    [self setNeedsDisplay:YES];
    
}

-(void)mouseEntered:(NSEvent *)theEvent {
    if (![_cloudEntity.name isEqualToString:CustomLocalizedString(@"AddCloud_Button_Content", nil)]) {
        [_jumpHeadBtn setFrame:NSMakeRect(self.frame.size.width - 30 - 20 , 12, 30, 20)];
        [self addSubview:_jumpHeadBtn];
    }
    _mouseStatus = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseMoveOutView:(NSNotification *)sender {
    NSDictionary *userInfo= [sender userInfo];
    NSEvent *event = [userInfo objectForKey:@"MouseEvent"];
    [self mouseMoved:event];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint mouseLocation = [self.window mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation fromView: nil];
    
    if (NSPointInRect(mouseLocation, [self bounds])) {
        _btnStatus = @"EnteredStatus";
        [self setNeedsDisplay:YES];
    } else {
        _btnStatus = @"ExitStatus";
        [self setNeedsDisplay:YES];
    }
}

- (void)jumpHeadBtn:(id)sender {
    [(IMBMainViewController *)_delegate choosePopCloudBtnDown:_cloudEntity];
}

- (void)dealloc {
    [_trackingArea release],_trackingArea = nil;
    [super dealloc];
}


@end
