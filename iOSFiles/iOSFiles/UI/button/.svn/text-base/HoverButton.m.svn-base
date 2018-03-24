                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       //
//  HoverButton.m
//  HoverButton
//

#import "HoverButton.h"
#import "IMBAnimation.h"
#import "StringHelper.h"

@implementation HoverButton
@synthesize MouseDownImage=_mouseDownImage;
@synthesize MouseEnteredImage=_mouseEnteredImage;
@synthesize MouseExitImage=_mouseExitImage;
@synthesize forBidImage = _forBidImage;
@synthesize isSelected = _isSelected;
@synthesize status = _status;
@synthesize hasPopover = _hasPopover;
@synthesize delegate = _delegate;
@synthesize isShowTips = _isShowTips;
@synthesize hasSpot = _hasSpot;
@synthesize isDrawRectLine = _isDrawRectLine;
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}



- (void)setForBidImage:(NSImage *)forBidImage
{
    if (_forBidImage != forBidImage) {
        [_forBidImage release];
        _forBidImage = [forBidImage retain];
//        [self setImage:_forBidImage];
        [self setNeedsDisplay:YES];
    }
}

- (void)setEnabled:(BOOL)flag
{
    [super setEnabled:flag];
    if (flag) {
//        [self setImage:_mouseExitImage];
        _status = 1;
        [self setAlphaValue:1.0];
    }else
    {
//        [self setImage:_forBidImage];
        _status = 4;
        [self setAlphaValue:0.5];
    }
    [self setNeedsDisplay:YES];
}

- (void)setIsDrawBorder:(BOOL)isDraw {
    if (_isDrawBorder != isDraw) {
        _isDrawBorder = isDraw;
        [self setNeedsDisplay:YES];
    }
}

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	if (trackingArea)
	{
		[self removeTrackingArea:trackingArea];
		[trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited |NSTrackingMouseMoved| NSTrackingActiveInKeyWindow;
	trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}


-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3 forBidImage:(NSImage *)forBidImage {
   
    if (_status != 1 && _status != 2 && _status != 3 && _status != 4) {
        _status = 1;
    }
    [self setTitle:@""];
    [self setButtonType:NSMomentaryPushInButton];
    [self setAlignment:NSCenterTextAlignment];
    [self setImagePosition:NSImageOnly];
    [self setBordered:NO];
    [self.cell setHighlightsBy:NSNoCellMask];
    _mouseEnteredImage=[image1 retain];
    _mouseExitImage=[image2 retain];
    _mouseDownImage=[image3 retain];
    _forBidImage = [forBidImage retain];
//    [self setImage:image2];
    [self setNeedsDisplay:YES];
}

-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3
{
    if (_status != 1 && _status != 2 && _status != 3 && _status != 4) {
        _status = 1;
    }
    [self setTitle:@""];
    [self setButtonType:NSMomentaryPushInButton];
    [self setAlignment:NSCenterTextAlignment];
    [self setImagePosition:NSImageOnly];
    [self setBordered:NO];
    [self.cell setHighlightsBy:NSNoCellMask];
    self.MouseEnteredImage=[image1 retain];
    self.MouseExitImage=[image2 retain];
    self.MouseDownImage=[image3 retain];
    [self setNeedsDisplay:YES];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected) {
//            [self setImage:_mouseEnteredImage];
            _status = 2;
        }else
        {
//            [self setImage:_mouseExitImage];
            _status = 1;
        }
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent *)event
{
    [IMBAnimation pauseAnimation:self.layer];
    if (self.isSelected) {
        return;
    }
    if (self.isEnabled&&_mouseEnteredImage != nil) {
//        [self setImage:_mouseEnteredImage];
        _status = 2;
    }else if(_mouseEnteredImage != nil)
    {
//        [self setImage:_forBidImage];
        _status = 4;
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)event
{
    if (_hasPopover) {
        if ([_delegate respondsToSelector:@selector(closePopover:)]) {
            _isShowTips = NO;
            [_delegate closePopover:nil];
        }
    }
    _hasExite = YES;
    
    [IMBAnimation resumeAnimation:self.layer];
    if (self.isSelected) {
        return;
    }
    if (self.isEnabled) {
        _status = 1;
//        [self setImage:_mouseExitImage];
    }else
    {
        _status = 4;
//        [self setImage:_forBidImage];
    }

    [self setNeedsDisplay:YES];
}

-(void)mouseDown:(NSEvent *)theEvent{
    
    if (_isShowTips) {
        _isShowTips = NO;
        if (_hasPopover) {
            if ([_delegate respondsToSelector:@selector(closePopover:)]) {
                [_delegate closePopover:self];
            }
        }
    }else if (_hasExite) {
        _isShowTips = YES;
        if (_hasPopover && [self becomeFirstResponder]) {
            if ([_delegate respondsToSelector:@selector(showPopover:)]) {
                [_delegate showPopover:self];
            }
        }
        
    }
    _hasExite = NO;
    if (self.tag == 4) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"SkinSpot"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"VideoSpot"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    if (self.isSelected) {
        return;
    }
    if (self.isEnabled) {
//        [self setImage:_mouseDownImage];
        [self setStatus:3];
    }else
    {
//        [self setImage:_forBidImage];
        _status = 4;
    }
//    if (!self.isSelected&&self.isEnabled) {
//        [self setImage:_mouseExitImage];
//    }
    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isSelected) {
        return;
    }
    if (self.isEnabled) {
//        [self setImage:_mouseExitImage];
        [self setStatus:1];
    }else
    {
//        [self setImage:_forBidImage];
        _status = 4;
    }
    [self setNeedsDisplay:YES];
    
    if (self.isEnabled &&theEvent.clickCount == 1) {
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
    [super mouseMoved:theEvent];
    NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
    NSRect bounds = self.bounds;
    NSRect boundRect = NSMakeRect(bounds.origin.x + 3, bounds.origin.y + 3, 28, 28);
    BOOL mouseInside = NSPointInRect(localPoint, boundRect);
    if (mouseInside) {
        if (!_isShowTips) {
            _isShowTips = YES;
            if (_hasPopover) {
                if ([_delegate respondsToSelector:@selector(showPopover:)]) {
                    [_delegate showPopover:self];
                }
            }

        }
    }else {
        _isShowTips = NO;
        if (_hasPopover) {
            if ([_delegate respondsToSelector:@selector(closePopover:)]) {
                [_delegate closePopover:self];
            }
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSBezierPath *clipPath = nil;
    clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [clipPath closePath];
    
    if (_status == 1) {
        [IMBGrayColor(255) setFill];
        [clipPath fill];
    }else if (_status == 2) {
        [IMBRgbColor(216, 235, 223) setFill];
        [clipPath fill];
    }else if (_status == 3) {
        [IMBRgbColor(196, 224, 206) setFill];
        [clipPath fill];
    }else if (_status == 4) {
        [IMBGrayColor(255) setFill];
        [clipPath fill];
    }
//    if (_isDrawBorder) {
//         if (!_isDrawRectLine) {
//            clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
//            [clipPath setWindingRule:NSEvenOddWindingRule];
//            [clipPath addClip];
//            [clipPath setLineWidth:2];
//        }else{
//            clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:15 yRadius:15];
//            [clipPath setWindingRule:NSEvenOddWindingRule];
//            [clipPath addClip];
//            [clipPath setLineWidth:0];
//        }
//            [clipPath closePath];
//       
//        if (_status == 1) {
//            [IMBGrayColor(255) setFill];
//            [clipPath fill];
//            [IMBRgbColor(216, 235, 223) setStroke];
//            [clipPath stroke];
//        }else if (_status == 2) {
//            [IMBRgbColor(216, 235, 223) setFill];
//            [clipPath fill];
//            [IMBRgbColor(216, 235, 223) setStroke];
//            [clipPath stroke];
//        }else if (_status == 3) {
//            [IMBRgbColor(196, 224, 206) setFill];
//            [clipPath fill];
//            [IMBRgbColor(216, 235, 223) setStroke];
//            [clipPath stroke];
//        }else if (_status == 4) {
//            [IMBGrayColor(255) setFill];
//            [clipPath fill];
//            [IMBRgbColor(216, 235, 223) setStroke];
//            [clipPath stroke];
//        }
//    }

    NSImage *image = nil;
    if (_status == 1) {
        image = _mouseExitImage;
    }else if (_status == 2) {
        image = _mouseEnteredImage;
    }else if (_status == 3) {
        image = _mouseDownImage;
    }else if (_status == 4) {
        image = _mouseExitImage;
    }
    if (image) {
        NSRect souRect;
        souRect.origin = NSZeroPoint;
        souRect.size = image.size;
        NSRect tarRect;
        tarRect.origin = NSMakePoint((dirtyRect.size.width - image.size.width) / 2, (dirtyRect.size.height - image.size.height) / 2);
        tarRect.size = image.size;
        [image drawInRect:tarRect fromRect:souRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    //判断是否显示Skin的小圆点
    if ((![[[NSUserDefaults standardUserDefaults] objectForKey:@"SkinSpot"] boolValue] && _hasSpot) ||(![[[NSUserDefaults standardUserDefaults] objectForKey:@"VideoSpot"] boolValue] && _hasSpot) ) {
        NSBezierPath *spotPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(dirtyRect.origin.x+dirtyRect.size.width-11, dirtyRect.origin.y+dirtyRect.size.height - 23, 6, 6) xRadius:3 yRadius:3];
        [IMBRgbColor(56, 176, 100) setFill];
        [spotPath fill];
    }
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [self mouseExited:theEvent];
    [super scrollWheel:theEvent];
}

- (void)dealloc{
    if (_mouseEnteredImage) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_mouseExitImage) {
        [_mouseExitImage release];
        _mouseExitImage = nil;
    }
    if (_mouseDownImage) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    [_forBidImage release],_forBidImage = nil;
    [super dealloc];
}

@end