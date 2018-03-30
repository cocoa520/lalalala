//
//  IMBSortPopoverViewController.m
//  iOSFiles
//
//  Created by hym on 30/03/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBSortPopoverViewController.h"
#import "IMBCommonDefine.h"
#define DEVICEITEMHEIGHT 20

@implementation IMBSortPopoverViewController
@synthesize delegate = _delegate;
@synthesize action = _action;
@synthesize target = _target;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSortTypeAry:(NSMutableArray *)typeAry {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _typeAry = [typeAry retain];
    }
    return self;
}


- (void)awakeFromNib {
    NSRect f = self.view.frame;
    f.size.height = _typeAry.count * DEVICEITEMHEIGHT + 10;
    f.size.width = 80;
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)loadDeviceInfo {
    NSRect f = self.view.frame;
    if (_typeAry != nil && _typeAry.count > 0) {
        int allCount = (int)_typeAry.count;
        for (int i = 0; i < allCount; i++) {
            NSString *str = [_typeAry objectAtIndex:i];
            NSRect itemRect;
            itemRect.origin.x = f.origin.x;
            itemRect.origin.y = (allCount - i - 1) * DEVICEITEMHEIGHT+ 5;
            itemRect.size.width = f.size.width;
            itemRect.size.height = DEVICEITEMHEIGHT;
            IMBSortView *sortView = [[IMBSortView alloc] initWithFrame:itemRect withTitle:str];
            [sortView setDelegate:_delegate];
            [sortView setTarget:self.target];
            [sortView setAction:self.action];
            [self.view addSubview:sortView];
            [sortView release];
            sortView = nil;
        }
    }
}


@end

@implementation IMBSortView
@synthesize delegate = _delegate;
@synthesize action = _action;
@synthesize target = _target;
@synthesize title = _title;


- (instancetype)initWithFrame:(NSRect)frameRect withTitle:(NSString *)title {
    if (self = [super initWithFrame:frameRect]) {
        _title = [title retain];
       
    }
    return self;
}


- (void)viewDidMoveToSuperview {
     [self loadView];
}

- (void)loadView {
    _textField = [[NSTextField alloc] init];
    [_textField setBordered:NO];
    [_textField setEditable:NO];
    [_textField setBackgroundColor:[NSColor clearColor]];
    [_textField setStringValue:_title];
    [_textField setTextColor:COLOR_TEXT_ORDINARY];
    [_textField setFrame:NSMakeRect(10, 0, self.frame.size.width - 20, self.frame.size.height)];
    [self addSubview:_textField];
    [_textField release];
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseMoved|NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    _mouseSatue = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    _mouseSatue = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    _mouseSatue = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
     _mouseSatue = MouseUp;
    [self setNeedsDisplay:YES];
    [self.target performSelector:self.action withObject:_title];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_mouseSatue == MouseEnter || _mouseSatue == MouseUp) {
        [COLOR_TABLEVIEW_ENTER setFill];
    }else if (_mouseSatue == MouseDown ) {
        [COLOR_TABLEVIEW_CLICK setFill];
    }else {
        [[NSColor whiteColor] setFill];
    }
    [path fill];
}


- (void)dealloc {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end
