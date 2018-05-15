/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the "SlideCarrierView" class implementation.
*/

#import "CloudItemView.h"
#import "CloudItemBorderView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBSVGClickView.h"
#import "IMBWhiteView.h"
#import "IMBDriveModel.h"
#import "IMBAllCloudViewController.h"

#define ENTERY 10
@implementation CloudItemView
@synthesize isOpenMenu = _isOpenMenu;
@synthesize delegate = _delegate;
@synthesize model = _model;
@synthesize textFiled = _textFiled;
@synthesize isRename = _isRename;
#pragma mark Animation

// Override the default @"frameOrigin" animation for SlideCarrierViews, to use an "EaseInEaseOut" timing curve.
+ (id)defaultAnimationForKey:(NSString *)key {
    static CABasicAnimation *basicAnimation = nil;
    if ([key isEqual:@"frameOrigin"]) {
        if (basicAnimation == nil) {
            basicAnimation = [[CABasicAnimation alloc] init];
            [basicAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        }
        return basicAnimation;
    } else {
        return [super defaultAnimationForKey:key];
    }
}

- (void)awakeFromNib {
    [self setWantsLayer:YES];
    [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_color", nil)]];
    [_toolView setHidden:YES];
    [_toolView setCornerRadius:2];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    _selectedView = [[CloudItemSelectedView alloc] init];
    _selectedView.selectedColor = [StringHelper getColorFromString:CustomColor(@"Collection_selectedColor", nil)];
    _selectedView.frame = NSMakeRect(self.frame.size.width / 2.0, self.frame.size.height / 2.0, 1, 1);
//    _selectedLayer.anchorPoint = NSMakePoint(0.5, 0.5);
//    _selectedLayer.cornerRadius = 5.0;
//    _selectedLayer.masksToBounds = YES;
    [self addSubview:_selectedView positioned:NSWindowBelow relativeTo:_toolView];//addSubview:_selectedView];
    
    _SVGView = [[IMBSVGClickView alloc] initWithFrame:NSMakeRect(self.frame.size.width - 18, self.frame.size.height - 18, 18, 18)];
    [_SVGView setSVGImageName:@"checkbox"];
    _isRename = NO;
    _textFiled.editable = NO;
    [_textFiled setSelectable:NO];

    //在弹出窗口时，屏蔽详细页面的进入状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableEnterState:) name:DISABLE_ENTER_STATE object:nil];
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

#pragma mark Initializing

- (nonnull instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        highlightState = NSCollectionViewItemHighlightNone;
    }
    return self;
}

#pragma mark Property Accessors

- (NSCollectionViewItemHighlightState)highlightState {
    return highlightState;
}

- (void)setHighlightState:(NSCollectionViewItemHighlightState)newHighlightState {
    if (highlightState != newHighlightState) {
        highlightState = newHighlightState;

        // Cause our -updateLayer method to be invoked, so we can update our appearance to reflect the new state.
        [self setNeedsDisplay:YES];
    }
}

- (BOOL)isSelected {
    return selected;
}

- (void)setSelected:(BOOL)flag {
    if (selected != flag) {
        selected = flag;

        // Cause our -updateLayer method to be invoked, so we can update our appearance to reflect the new state.
        [self setNeedsDisplay:YES];
        
        if (_model.isForbiddden) {
            return;
        }
        
//        if (selected) {
//            [self addSubview:_SVGView];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
//                [_selectedView setFrame:rect];
//            });
            
            
//        }else {
//            [_SVGView removeFromSuperview];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSRect rect = NSMakeRect(self.frame.size.width / 2.0, self.frame.size.height / 2.0, 1, 1);
//                [_selectedView setFrame:rect];
//            });
//        }
        if (selected) {
            [self addSubview:_SVGView];
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
                [[_selectedView animator] setFrame:rect];
            } completionHandler:^{
                NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
                [_selectedView setFrame:rect];
            }];
        }else {
            [_SVGView removeFromSuperview];
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                NSRect rect = NSMakeRect(self.frame.size.width / 2.0, self.frame.size.height / 2.0, 1, 1);
                [[_selectedView animator] setFrame:rect];
            } completionHandler:^{
                NSRect rect = NSMakeRect(self.frame.size.width / 2.0, self.frame.size.height / 2.0, 1, 1);
                [_selectedView setFrame:rect];
            }];
        }
    }
}

#pragma mark Visual State

// A AAPLSlideCarrierView wants to receive -updateLayer so it can set its backing layer's contents property, instead of being sent -drawRect: to draw its content procedurally.
- (BOOL)wantsUpdateLayer {
    return YES;
}

// Returns the slide's CloudItemBorderView (if it currently has one).
- (CloudItemBorderView *)borderView {
    for (NSView *subview in self.subviews) {
        if ([subview isKindOfClass:[CloudItemBorderView class]]) {
            return (CloudItemBorderView *)subview;
        }
    }
    return nil;
}

// Invoked from our -updateLayer override.  Adds a CloudItemBorderView subview with appropriate properties (or removes an existing CloudItemBorderView), as appropriate to visually indicate the slide's "highlightState" and whether the slide is "selected".
- (void)updateBorderView {
    NSColor *borderColor = nil;
    if (highlightState == NSCollectionViewItemHighlightForSelection) {

        // Item is a candidate to become selected: Show an orange border around it.
        borderColor = [StringHelper getColorFromString:CustomColor(@"Collection_borderColor", nil)];//[NSColor orangeColor];

    } else if (highlightState == NSCollectionViewItemHighlightAsDropTarget) {

        // Item is a candidate to receive dropped items: Show a red border around it.
        borderColor = [NSColor redColor];

    } else if (selected && highlightState != NSCollectionViewItemHighlightForDeselection) {

        // Item is selected, and is not indicated for proposed deselection: Show an Aqua border around it.
        borderColor = [StringHelper getColorFromString:CustomColor(@"Collection_borderColor", nil)];//[NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:1.0]; // Aqua

    } else {
        // Item is either not selected, or is selected but not highlighted for deselection: Sbhow no border around it.
        if (_mouseState == MouseEnter || _mouseState == MouseUp || _mouseState == MouseDown) {
            borderColor = [StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)];
        }else  {
            borderColor = nil;
        }
    }

    // Add/update or remove a CloudItemBorderView subview, according to whether borderColor != nil.
    CloudItemBorderView *borderView = self.borderView;
    if (borderColor) {
        if (borderView == nil) {
            NSRect bounds = self.bounds;
//            NSRect shapeBox = NSInsetRect(bounds, (SLIDE_SHADOW_MARGIN - 0.5 * SLIDE_BORDER_WIDTH), (SLIDE_SHADOW_MARGIN - 0.5 * SLIDE_BORDER_WIDTH));
            borderView = [[CloudItemBorderView alloc] initWithFrame:bounds];
            [self addSubview:borderView];
        }
        borderView.borderColor = borderColor;
//        borderView.selectColor = [StringHelper getColorFromString:CustomColor(@"Collection_selectedColor", nil)];
    } else {
        [borderView removeFromSuperview];
    }
}

- (void)updateLayer {
    // Provide the SlideCarrierView's backing layer's contents directly, instead of via -drawRect:.
//    self.layer.contents = [NSImage imageNamed:@"SlideCarrier"];
    
    // Use this as an opportunity to update our CloudItemBorderView.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBorderView];
    });
}

// Used by our -hitTest: method, below.  Returns the slide's rounded-rectangle hit-testing shape, expressed as an NSBezierPath.
- (NSBezierPath *)slideShape {
    NSRect bounds = self.bounds;
    NSRect shapeBox = NSInsetRect(bounds, SLIDE_SHADOW_MARGIN, SLIDE_SHADOW_MARGIN);
    return [NSBezierPath bezierPathWithRoundedRect:shapeBox xRadius:SLIDE_CORNER_RADIUS yRadius:SLIDE_CORNER_RADIUS];
}

- (NSView *)hitTest:(NSPoint)aPoint {
    // Hit-test against the slide's rounded-rect shape.
    NSPoint pointInSelf = [self convertPoint:aPoint fromView:self.superview];
    NSRect bounds = self.bounds;
    if (!NSPointInRect(pointInSelf, bounds)) {
        return nil;
    } else if (![self.slideShape containsPoint:pointInSelf]) {
        return nil;
    } else {
        return [super hitTest:aPoint];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    if (!_isDisable && !_model.isForbiddden) {
        if (!_isRename) {
            if (_mouseState != MouseEnter) {
                _mouseState = MouseEnter;
                if (self.isSelected) {
                    [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_selectColor", nil)]];
                } else {
                    [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_color", nil)]];
                }
                
                [_toolView setCornerRadius:2];
                [_toolView setHidden:NO];
                [self setMouseEnterAnimation];
                [self updateBorderView];
            }
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    if (!_isOpenMenu) {
        if (_mouseState != MouseOut) {
            _mouseState = MouseOut;
            [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_color", nil)]];
            [_toolView setHidden:YES];
            [self setMouseOutAnimation];
            [self updateBorderView];
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSInteger clickCout = theEvent.clickCount;
    if (clickCout == 2) {
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewDoubleClick:)] && (_model.fileTypeEnum == Folder)) {
            [_delegate collectionViewDoubleClick:_model];
        }
    }else if(clickCout == 1) {
//        [self setSelected:!self.selected];
        [super mouseDown:theEvent];
        _mouseState = MouseDown;
        if (self.isSelected) {
            [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_selectColor", nil)]];
        } else {
            [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_color", nil)]];
        }
        [_toolView setCornerRadius:2];
        [_toolView setHidden:NO];
        [self updateBorderView];
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSInteger clickCout = theEvent.clickCount;
    if(clickCout == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(collectionViewRightMouseDownClick:)]) {
            [_delegate collectionViewRightMouseDownClick:_model];
        }
        
        _mouseState = MouseDown;
        if (self.isSelected) {
            [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_selectColor", nil)]];
        } else {
            [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_color", nil)]];
        }
        [_toolView setCornerRadius:2];
        [_toolView setHidden:NO];
        [self updateBorderView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super rightMouseDown:theEvent];
        });
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    _mouseState = MouseUp;
    if (self.isSelected) {
        [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_selectColor", nil)]];
    } else {
        [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_color", nil)]];
    }
    [_toolView setCornerRadius:2];
    [_toolView setHidden:NO];
    [self updateBorderView];
}

- (void)setIsOpenMenu:(BOOL)isOpenMenu {
    _isOpenMenu = isOpenMenu;
    if (!_isOpenMenu) {
//        if (_mouseState == MouseOut) {
            _mouseState = MouseOut;
        [_toolView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"collection_toolView_color", nil)]];
            [_toolView setHidden:YES];
            [self setMouseOutAnimation];
            [self updateBorderView];
//        }
    }
}

- (void)setMouseEnterAnimation {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        NSPoint point1 = NSMakePoint(28, 49 + 10 + ENTERY);
        [[_imageView animator] setFrameOrigin:point1];
        context.duration = 0.2;
    } completionHandler:^{
        NSPoint point1 = NSMakePoint(28, 49 + 10 + ENTERY);
        NSPoint point2 = NSMakePoint(28, 49);
        if (_mouseState == MouseOut) {
            [[_imageView animator] setFrameOrigin:point2];
        }else {
            [[_imageView animator] setFrameOrigin:point1];
        }
    }];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        NSPoint point1 = NSMakePoint(8, 18 + 16 + ENTERY);
        [[_textFiled animator] setFrameOrigin:point1];
        context.duration = 0.4;
    } completionHandler:^{
        NSPoint point1 = NSMakePoint(8, 18 + 16 + ENTERY);
        NSPoint point2 = NSMakePoint(8, 18);
        if (_mouseState == MouseOut) {
            [[_textFiled animator] setFrameOrigin:point2];
        }else {
            [[_textFiled animator] setFrameOrigin:point1];
        }
    }];
}

- (void)setMouseOutAnimation {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        NSPoint point1 = NSMakePoint(28, 49);
        [[_imageView animator] setFrameOrigin:point1];
        context.duration = 0.2;
    } completionHandler:^{
        NSPoint point1 = NSMakePoint(28, 49);
        NSPoint point2 = NSMakePoint(28, 49 + 10 + ENTERY);
        if (_mouseState == MouseOut) {
             [[_imageView animator] setFrameOrigin:point1];
        }else {
            [[_imageView animator] setFrameOrigin:point2];
        }
    }];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        NSPoint point1 = NSMakePoint(8, 18);
        [[_textFiled animator] setFrameOrigin:point1];
        context.duration = 0.4;
    } completionHandler:^{
        NSPoint point1 = NSMakePoint(8, 18);
        NSPoint point2 = NSMakePoint(8, 18 + 16 + ENTERY);
        if (_mouseState == MouseOut) {
            [[_textFiled animator] setFrameOrigin:point1];
        }else {
            [[_textFiled animator] setFrameOrigin:point2];
        }
    }];
}

- (void)disableEnterState:(NSNotification *)notification {
    _isDisable = [notification.object boolValue];
}

- (void)dealloc {
    if (_selectedView) {
        [_selectedView release];
        _selectedView = nil;
    }
    if(_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_SVGView) {
        [_SVGView release];
        _SVGView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
