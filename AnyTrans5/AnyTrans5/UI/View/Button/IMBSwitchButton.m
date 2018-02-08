//
//  IMBSwitchButton.m
//  MacClean
//
//  Created by LuoLei on 15-5-6.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import "IMBSwitchButton.h"
#import <QuartzCore/QuartzCore.h>
// ----------------------------------------------------
#pragma mark - Preprocessor
// ----------------------------------------------------

#define kAnimationDuration 0.4f

#define kBorderLineWidth 1.f

#define kGoldenRatio 1.61803398875f
#define kDecreasedGoldenRatio 1.38

#define kEnabledOpacity 1.f
#define kDisabledOpacity 0.5f

#define kKnobBackgroundColor [NSColor colorWithCalibratedWhite:1.f alpha:1.f]

#define kDisabledBorderColor [NSColor colorWithCalibratedWhite:0.f alpha:0.2f]
#define kabledBorderColor [NSColor colorWithCalibratedWhite:0.f alpha:0.2f]
#define kDisabledBackgroundColor [NSColor clearColor]
#define kDefaultTintColor [NSColor colorWithDeviceRed:86.0/255 green:137.0/255 blue:230.0/255 alpha:1.0]
#define kInactiveBackgroundColor [NSColor colorWithCalibratedWhite:0 alpha:0.3]



// ---------------------------------------------------------------------------------------
#pragma mark - NSColor Addition for OS X <= 10.7 support
// ---------------------------------------------------------------------------------------

static inline CFTypeRef it_CFAutorelease(CFTypeRef obj) {
    id __autoreleasing result = CFBridgingRelease(obj);
    return (__bridge CFTypeRef)result;
}

@interface NSColor (ITSwitchCGColor)
@property (nonatomic, readonly) CGColorRef it_CGColor;
@end
@implementation NSColor (ITSwitchCGColor)

- (CGColorRef)it_CGColor {
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat *)&components];
    
    CGColorRef result = CGColorCreate(colorSpace, components);
    it_CFAutorelease(result);
    
    return result;
}

@end

#import "StringHelper.h"

@implementation IMBSwitchButton
@synthesize tintColor = _tintColor;
@synthesize tintBorderColor = _tintBorderColor;
@synthesize noTintColor = _noTintColor;
@synthesize noTintBorderColor = _noTintBorderColor;
@synthesize hasDragged;
@synthesize isOn = _isOn;
@synthesize isActive;
@synthesize isDraggingTowardsOn;
@synthesize rootLayer = _rootLayer;
@synthesize backgroundLayer = _backgroundLayer;
@synthesize knobLayer = _knobLayer;
@synthesize knobInsideLayer = _knobInsideLayer;


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    
    [self setUp];
    
    return self;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setUp];
    
    return self;
}

- (void)dealloc
{
    [_rootLayer release],_rootLayer = nil;
    [_backgroundLayer release],_backgroundLayer = nil;
    [_knobLayer release],_knobLayer = nil;
    [_knobInsideLayer release],_knobInsideLayer = nil;
    [_tintColor release],_tintColor = nil;
    [super dealloc];
    
}
- (void)setUp {
    
    self.enabled = YES;
    [self setUpLayers];
}

- (void)setUpLayers {
    
    _rootLayer = [[CALayer layer] retain];
    //_rootLayer.delegate = self;
    self.layer = _rootLayer;
    self.wantsLayer = YES;
    
    // 背景 layer
    _backgroundLayer = [[CALayer layer] retain];
    _backgroundLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    _backgroundLayer.bounds = _rootLayer.bounds;
    _backgroundLayer.anchorPoint = (CGPoint){ .x = 0.f, .y = 0.f };
    _backgroundLayer.borderWidth = kBorderLineWidth;
    [_rootLayer addSublayer:_backgroundLayer];
    
    // Knob layer
    _knobLayer = [[CALayer layer] retain];
    _knobLayer.frame = NSRectToCGRect([self rectForKnob]);
    _knobLayer.autoresizingMask = kCALayerHeightSizable;
    _knobLayer.backgroundColor = [kKnobBackgroundColor it_CGColor];
    _knobLayer.shadowColor = [[NSColor blackColor] it_CGColor];
    _knobLayer.shadowOffset = (CGSize){ .width = 0.f, .height = -2.f };
    _knobLayer.shadowRadius = 1.f;
    _knobLayer.shadowOpacity = 0.3f;
    [_rootLayer addSublayer:_knobLayer];
    
    _knobInsideLayer = [[CALayer layer] retain];
    _knobInsideLayer.frame = _knobLayer.bounds;
    _knobInsideLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    _knobInsideLayer.shadowColor = [[NSColor blackColor] it_CGColor];
    _knobInsideLayer.shadowOffset = (CGSize){ .width = 0.f, .height = 0.f };
    _knobInsideLayer.backgroundColor = [[StringHelper getColorFromString:CustomColor(@"switchBtn_insideColor", nil)] it_CGColor];
    _knobInsideLayer.shadowRadius = 1.f;
    _knobInsideLayer.shadowOpacity = 0.35f;
    [_knobLayer addSublayer:_knobInsideLayer];
    
    // 初始化
    [self reloadLayerSize];
    [self reloadLayer];
}

// ----------------------------------------------------
#pragma mark - NSView
// ----------------------------------------------------

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    
    [self reloadLayerSize];
}

- (void)drawFocusRingMask {
	CGFloat cornerRadius = NSHeight([self bounds])/2.0;
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:cornerRadius yRadius:cornerRadius];
	[[NSColor blackColor] set];
	[path fill];
}

- (BOOL)canBecomeKeyView {
	return [NSApp isFullKeyboardAccessEnabled];
}

- (NSRect)focusRingMaskBounds {
	return [self bounds];
}


// ----------------------------------------------------
#pragma mark - Update Layer
// ----------------------------------------------------

- (void)reloadLayer {
    [CATransaction begin];
    [CATransaction setAnimationDuration:kAnimationDuration];
    {
        if ((self.hasDragged && self.isDraggingTowardsOn) || (!self.hasDragged && self.isOn)) {
            _backgroundLayer.borderColor = [self.tintBorderColor it_CGColor];
            _backgroundLayer.backgroundColor = [self.tintColor it_CGColor];
            _knobInsideLayer.backgroundColor = [[StringHelper getColorFromString:CustomColor(@"switchBtn_insideColor", nil)] it_CGColor];
        } else {
            _backgroundLayer.borderColor = [self.noTintBorderColor  it_CGColor];
            _backgroundLayer.backgroundColor = [self.noTintColor it_CGColor];
            _knobInsideLayer.backgroundColor = [[StringHelper getColorFromString:CustomColor(@"switchBtn_insideCloseColor", nil)] it_CGColor];
        }
        
        _rootLayer.opacity = (self.isEnabled) ? kEnabledOpacity : kDisabledOpacity;
        if (!self.hasDragged) {
            CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0.25f :1.5f :0.5f :1.f];
            [CATransaction setAnimationTimingFunction:function];
        }
        
        self.knobLayer.frame = NSRectToCGRect([self rectForKnob]);
        self.knobInsideLayer.frame = self.knobLayer.bounds;
    }
    [CATransaction commit];
}

- (void)reloadLayerSize {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    {
        self.knobLayer.frame = NSRectToCGRect([self rectForKnob]);
        self.knobInsideLayer.frame = self.knobLayer.bounds;
        
        [_backgroundLayer setCornerRadius:_backgroundLayer.bounds.size.height / 2.f];
        [_knobLayer setCornerRadius:_knobLayer.bounds.size.height / 2.f];
        [_knobInsideLayer setCornerRadius:_knobLayer.bounds.size.height / 2.f];
        
    }
    [CATransaction commit];
}

- (CGFloat)knobHeightForSize:(NSSize)size
{
    return size.height - (kBorderLineWidth * 2.f);
}

- (NSRect)rectForKnob {
//    float herght = [self knobHeightForSize:NSMakeSize(_backgroundLayer.bounds.size.width, _backgroundLayer.bounds.size.height)];
    
    CGFloat height = [self knobHeightForSize:NSMakeSize(_backgroundLayer.bounds.size.width, _backgroundLayer.bounds.size.height)] / 1.3;
    CGFloat width = !self.isActive ? (_backgroundLayer.bounds.size.height - 2.f * kBorderLineWidth) * 1.f /1.3 :
    (_backgroundLayer.bounds.size.width - 2.f * kBorderLineWidth) * 1.f / 1.3*kDecreasedGoldenRatio-2;
    CGFloat x = ((!self.hasDragged && !self.isOn) || (self.hasDragged && !self.isDraggingTowardsOn)) ?
    kBorderLineWidth :
    _backgroundLayer.bounds.size.width - width - kBorderLineWidth;
    if (_isOn) {
        x -= 4;
    }else {
        x += 4;
    }
    return (NSRect) {
        .size.width = width,
        .size.height = height,
        .origin.x = x ,
        .origin.y = kBorderLineWidth+3,
    };
}



// ----------------------------------------------------
#pragma mark - NSResponder
// ----------------------------------------------------

- (BOOL)acceptsFirstResponder {
	return [NSApp isFullKeyboardAccessEnabled];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (!self.isEnabled) return;
    
    self.isActive = YES;
    [self reloadLayer];
   
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if (!self.isEnabled) return;
    
    self.hasDragged = YES;
    
    NSPoint draggingPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    self.isDraggingTowardsOn = draggingPoint.x >= NSWidth(self.bounds) / 2.f;
    [self reloadLayer];
  
}



- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    if (!self.isEnabled) return;
    
    self.isActive = NO;
    
    BOOL isOn = (!self.hasDragged) ? !self.isOn : self.isDraggingTowardsOn;
    BOOL invokeTargetAction = (isOn != _isOn);
    
    self.isOn = isOn;
    if (invokeTargetAction) [self _invokeTargetAction];
    // Reset
    self.hasDragged = NO;
    self.isDraggingTowardsOn = NO;
    [self reloadLayer];
}

- (void)moveLeft:(id)sender {
	if (self.isOn) {
		self.isOn = NO;
		[self _invokeTargetAction];
	}
}

- (void)moveRight:(id)sender {
	if (self.isOn == NO) {
		self.isOn = YES;
		[self _invokeTargetAction];
	}
}

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent {
	BOOL handledKeyEquivalent = NO;
	if ([[self window] firstResponder] == self) {
		NSInteger ch = [theEvent keyCode];
		
		if (ch == 49) //Space
		{
			self.isOn = !self.isOn;
			[self _invokeTargetAction];
			handledKeyEquivalent = YES;
		}
	}
	return handledKeyEquivalent;
}

// ----------------------------------------------------
#pragma mark - NSControl
// ----------------------------------------------------

- (id)target {
    return _target;
}

- (void)setTarget:(id)target {
    _target = target;
}

- (SEL)action {
    return _action;
}

- (void)setAction:(SEL)action {
    _action = action;
}



// ----------------------------------------------------
#pragma mark - Accessors
// ----------------------------------------------------

- (void)setOn:(BOOL)isOn {
    if (_isOn != isOn) {
        [self willChangeValueForKey:@"isOn"];
        {
            _isOn = isOn;
        }
        [self didChangeValueForKey:@"isOn"];
    }
    
    [self reloadLayer];
}

- (NSColor *)tintColor {
//    if (!_tintColor) return kDefaultTintColor;
//    
//    return _tintColor;
    return [StringHelper getColorFromString:CustomColor(@"switchBtn_openBgColor", nil)];
}

- (void)setTintColor:(NSColor *)tintColor {
    if (_tintColor != tintColor) {
        [_tintColor release];
        _tintColor = [tintColor retain];
        [self reloadLayer];
    }
}

- (NSColor *)noTintColor{
//    if (!_noTintColor) {
//        return kDisabledBackgroundColor;
//    }
//    return _noTintColor;
    return [StringHelper getColorFromString:CustomColor(@"switchBtn_closeBgColor", nil)];
}

- (void)setNoTintColor:(NSColor *)noTintColor{
    if (_noTintColor != noTintColor) {
        [_noTintColor release];
        _noTintColor = [noTintColor retain];
        [self reloadLayer];
    }
}

- (NSColor *)noTintBorderColor{
//    if (!_noTintBorderColor) {
//        return kDisabledBorderColor;
//    }
//    return _noTintBorderColor;
    return [StringHelper getColorFromString:CustomColor(@"switchBtn_borderColor", nil)];
}

- (NSColor *)tintBorderColor{
    return [StringHelper getColorFromString:CustomColor(@"switchBtn_openBgColor", nil)];
}

- (void)setNoTintBorderColor:(NSColor *)noTintBorderColor{
    if (_noTintBorderColor != noTintBorderColor) {
        [_noTintBorderColor release];
        _noTintBorderColor = [noTintBorderColor retain];
        [self reloadLayer];
    }
}

- (BOOL)isEnabled {
    return super.isEnabled;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self reloadLayer];
}

// -----------------------------------
#pragma mark - Helpers
// -----------------------------------

- (void)_invokeTargetAction {
    if (self.target && self.action) {
        NSMethodSignature *signature = [[self.target class] instanceMethodSignatureForSelector:self.action];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self.target];
        [invocation setSelector:self.action];
//        [invocation setArgument:(void *)&self atIndex:2];
        
        [invocation invoke];
    }
}

// -----------------------------------
#pragma mark - Accessibility
// -----------------------------------

- (BOOL)accessibilityIsIgnored {
	return NO;
}

- (id)accessibilityHitTest:(NSPoint)point {
	return self;
}

- (NSArray *)accessibilityAttributeNames {
	static NSArray *attributes = nil;
	if (attributes == nil)
	{
		NSMutableArray *mutableAttributes = [[super accessibilityAttributeNames] mutableCopy];
		if (mutableAttributes == nil)
			mutableAttributes = [NSMutableArray new];
		
		// Add attributes
		if (![mutableAttributes containsObject:NSAccessibilityValueAttribute])
			[mutableAttributes addObject:NSAccessibilityValueAttribute];
		
		if (![mutableAttributes containsObject:NSAccessibilityEnabledAttribute])
			[mutableAttributes addObject:NSAccessibilityEnabledAttribute];
		
		if (![mutableAttributes containsObject:NSAccessibilityDescriptionAttribute])
			[mutableAttributes addObject:NSAccessibilityDescriptionAttribute];
		
		// Remove attributes
		if ([mutableAttributes containsObject:NSAccessibilityChildrenAttribute])
			[mutableAttributes removeObject:NSAccessibilityChildrenAttribute];
		
		attributes = [mutableAttributes copy];
	}
	return attributes;
}

- (id)accessibilityAttributeValue:(NSString *)attribute {
	id retVal = nil;
	if ([attribute isEqualToString:NSAccessibilityRoleAttribute])
		retVal = NSAccessibilityCheckBoxRole;
	else if ([attribute isEqualToString:NSAccessibilityValueAttribute])
		retVal = [NSNumber numberWithInt:self.isOn];
	else if ([attribute isEqualToString:NSAccessibilityEnabledAttribute])
		retVal = [NSNumber numberWithBool:self.enabled];
	else
		retVal = [super accessibilityAttributeValue:attribute];
	return retVal;
}

- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute {
	BOOL retVal;
	if ([attribute isEqualToString:NSAccessibilityValueAttribute])
		retVal = YES;
	else if ([attribute isEqualToString:NSAccessibilityEnabledAttribute])
		retVal = NO;
	else if ([attribute isEqualToString:NSAccessibilityDescriptionAttribute])
		retVal = NO;
	else
		retVal = [super accessibilityIsAttributeSettable:attribute];
	return retVal;
}

- (void)accessibilitySetValue:(id)value forAttribute:(NSString *)attribute {
	if ([attribute isEqualToString:NSAccessibilityValueAttribute]) {
		BOOL invokeTargetAction = self.isOn != [value boolValue];
		self.isOn = [value boolValue];
		if (invokeTargetAction) {
			[self _invokeTargetAction];
		}
	}
	else {
		[super accessibilitySetValue:value forAttribute:attribute];
	}
}

- (NSArray *)accessibilityActionNames {
	static NSArray *actions = nil;
	if (actions == nil)
	{
		NSMutableArray *mutableActions = [[super accessibilityActionNames] mutableCopy];
		if (mutableActions == nil)
			mutableActions = [NSMutableArray new];
		if (![mutableActions containsObject:NSAccessibilityPressAction])
			[mutableActions addObject:NSAccessibilityPressAction];
		actions = [mutableActions copy];
	}
	return actions;
}

- (void)accessibilityPerformAction:(NSString *)actionString {
	if ([actionString isEqualToString:NSAccessibilityPressAction]) {
		self.isOn = !self.isOn;
		[self _invokeTargetAction];
	}
	else {
		[super accessibilityPerformAction:actionString];
	}
}

// -----------------------------------
#pragma mark - 将NSImage转换为CGImageRef
// -----------------------------------

- (CGImageRef)nsImageToCGImageRef:(NSImage*)image;
{
    NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef;
    if(imageData)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData,  NULL);
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        if (imageSource) {
            CFRelease(imageSource);
            imageSource = NULL;
        }
        
    }
    return imageRef;
}


@end
