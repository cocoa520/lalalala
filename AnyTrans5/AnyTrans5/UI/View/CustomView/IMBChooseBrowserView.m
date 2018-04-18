//
//  IMBChooseBrowserView.m
//  AnyTrans
//
//  Created by hym on 25/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "IMBChooseBrowserView.h"
#import "StringHelper.h"
@implementation IMBChooseBrowserView
@synthesize target = _target;
@synthesize action = _action;
@synthesize tag = _tag;
@synthesize isSelected = _isSelected;
@synthesize isExist = _isExist;

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

- (void)setImage:(NSImage *)image withTitle:(NSString *)title {
    if (_image) {
        [_image release];
        _image = nil;
    }
    _image = [image retain];
    if (_title) {
        [_title release];
        _title = nil;
    }
    _title = [title retain];
}


-(void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [path setWindingRule:NSEvenOddWindingRule];
    if (_mouseStatus == MouseDown) {
        [[StringHelper getColorFromString:CustomColor(@"functionBtn_enter_bgColor", nil)] set];
    }else {
        [[NSColor clearColor] set];
    }
    [path fill];
    
    if (_mouseStatus == MouseEnter ||  _mouseStatus == MouseUp) {
        NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
        [path1 addClip];
        [path1 setLineWidth:2];
        [path1 stroke];
        [path1 closePath];
//        if (!_isSelected) {
//            NSRect drawingRect;
//            NSImage *selectImage = [StringHelper imageNamed:@"itunes_checkbox1"];
//            NSRect imageRect;
//            imageRect.origin = NSZeroPoint;
//            imageRect.size = NSMakeSize(14, 14);
//            drawingRect.origin.x = 64;
//            drawingRect.origin.y = 56;
//            drawingRect.size.width = imageRect.size.width;
//            drawingRect.size.height = imageRect.size.height;
//            [selectImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
//        }
    }else if (_mouseStatus == MouseDown){
        NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [[StringHelper getColorFromString:CustomColor(@"tableView_oddBgColor", nil)] setFill];
        [path1 addClip];
        [path1 fill];
        
        [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
        [path1 addClip];
        [path1 setLineWidth:2];
        [path1 stroke];
        [path1 closePath];
    }
    
    if (_image != nil) {
        NSRect drawingRect;
        // 用来苗素图片信息
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = NSMakeSize(64, 64);
        drawingRect.origin.x = (dirtyRect.size.width - 64) / 2.0;
        drawingRect.origin.y = 52;
        drawingRect.size.width = imageRect.size.width;
        drawingRect.size.height = imageRect.size.height;
        [_image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
    
    if (_title != nil) {
        NSSize size ;
        NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_title withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:85 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
        NSRect textRect2 = NSMakeRect(ceil((dirtyRect.size.width - size.width)/ 2.0) , 19, size.width, 22);
        [attrStr drawInRect:textRect2];
    }
    

    
//    if (_isSelected) {
//        NSRect drawingRect;
//        NSImage *selectImage = [StringHelper imageNamed:@"itunes_checkbox2"];
//        NSRect imageRect;
//        imageRect.origin = NSZeroPoint;
//        imageRect.size = NSMakeSize(14, 14);
//        drawingRect.origin.x = 64;
//        drawingRect.origin.y = 56;
//        drawingRect.size.width = imageRect.size.width;
//        drawingRect.size.height = imageRect.size.height;
//        [selectImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
//    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseStatus = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseStatus = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseStatus = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseStatus = MouseUp;
    _isSelected = YES;
    [NSApp sendAction:self.action to:self.target from:self];
    [self setNeedsDisplay:YES];
}


- (void)dealloc {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_image) {
        [_image release];
        _image = nil;
    }
    if (_title) {
        [_title release];
        _title = nil;
    }
    [super dealloc];
}

@end
