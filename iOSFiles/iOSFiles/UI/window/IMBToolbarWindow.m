//
//  IMBToolbarWindow.m
//  iMobieTrans
//
//  Created by Pallas on 3/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBToolbarWindow.h"
#import "IMBWindowButton.h"
#import "IMBCustomButton.h"
#import "NSObject+Extension.h"

#import <objc/runtime.h>


#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1070
enum { NSWindowDocumentVersionsButton = 6, NSWindowFullScreenButton = 7 };
enum { NSFullScreenWindowMask = 1 << 14 };
extern NSString * const NSAccessibilityFullScreenButtonSubrole;
extern NSString * const NSWindowWillEnterFullScreenNotification;
extern NSString * const NSWindowDidEnterFullScreenNotification;
extern NSString * const NSWindowWillExitFullScreenNotification;
extern NSString * const NSWindowDidExitFullScreenNotification;
extern NSString * const NSWindowWillEnterVersionBrowserNotification;
extern NSString * const NSWindowDidEnterVersionBrowserNotification;
extern NSString * const NSWindowWillExitVersionBrowserNotification;
extern NSString * const NSWindowDidExitVersionBrowserNotification;
#define NSAppKitVersionNumber10_7 1138
#endif

/** Values chosen to match the defaults in OS X 10.9, which may change in future versions **/
const CGFloat INWindowDocumentIconButtonOriginY = 3.f;
const CGFloat INWindowDocumentVersionsButtonOriginY = 2.f;
const CGFloat INWindowDocumentVersionsDividerOriginY = 2.f;

/** Corner clipping radius **/
const CGFloat INCornerClipRadius = 4.0;

/** Padding used between traffic light/fullscreen buttons and title **/
const NSSize INTitleMargins = {8.0, 2.0};

/** Title offsets used when the document button is showing */
const NSSize INTitleDocumentButtonOffset = {4.0, 1.0};

/** X offset used when the document status label is showing */
const CGFloat INTitleDocumentStatusXOffset = -20.0;

/** X offset used when the versions button is showing */
const CGFloat INTitleVersionsButtonXOffset = -1.0;

NS_INLINE bool INRunningLion() {
	return floor(NSAppKitVersionNumber) >= NSAppKitVersionNumber10_7;
}

NS_INLINE CGFloat INMidHeight(NSRect aRect) {
	return (aRect.size.height * (CGFloat) 0.5);
}

CF_RETURNS_RETAINED
NS_INLINE CGPathRef INCreateClippingPathWithRectAndRadius(NSRect rect, CGFloat radius) {
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, NSMinX(rect), NSMinY(rect));
	CGPathAddLineToPoint(path, NULL, NSMinX(rect), NSMaxY(rect) - radius);
	CGPathAddArcToPoint(path, NULL, NSMinX(rect), NSMaxY(rect), NSMinX(rect) + radius, NSMaxY(rect), radius);
	CGPathAddLineToPoint(path, NULL, NSMaxX(rect) - radius, NSMaxY(rect));
	CGPathAddArcToPoint(path, NULL, NSMaxX(rect), NSMaxY(rect), NSMaxX(rect), NSMaxY(rect) - radius, radius);
	CGPathAddLineToPoint(path, NULL, NSMaxX(rect), NSMinY(rect));
	CGPathCloseSubpath(path);
	return path;
}

NS_INLINE void INApplyClippingPath(CGPathRef path, CGContextRef ctx) {
	CGContextAddPath(ctx, path);
	CGContextClip(ctx);
}

NS_INLINE void INApplyClippingPathInCurrentContext(CGPathRef path) {
	INApplyClippingPath(path, [[NSGraphicsContext currentContext] graphicsPort]);
}

CF_RETURNS_RETAINED
NS_INLINE CGColorRef INCreateCGColorFromNSColor(NSColor *color) {
	NSColor *rgbColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat components[4];
	[rgbColor getComponents:components];
    
	CGColorSpaceRef theColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef theColor = CGColorCreate(theColorSpace, components);
	CGColorSpaceRelease(theColorSpace);
	return theColor;
}

CF_RETURNS_RETAINED
NS_INLINE CGGradientRef INCreateGradientWithColors(NSColor *startingColor, NSColor *endingColor) {
	CGFloat locations[2] = {0.0f, 1.0f,};
	CGColorRef cgStartingColor = INCreateCGColorFromNSColor(startingColor);
	CGColorRef cgEndingColor = INCreateCGColorFromNSColor(endingColor);
	CFArrayRef colors = (__bridge CFArrayRef) [NSArray arrayWithObjects:(__bridge id) cgStartingColor, (__bridge id) cgEndingColor, nil];
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
	CGColorSpaceRelease(colorSpace);
	CGColorRelease(cgStartingColor);
	CGColorRelease(cgEndingColor);
	return gradient;
}

@interface IMBToolbarWindowDelegateProxy : NSProxy <NSWindowDelegate> {
@private
    id <NSWindowDelegate> _secondaryDelegate;
}
@property (nonatomic, assign) id <NSWindowDelegate> secondaryDelegate;

@end

@implementation IMBToolbarWindowDelegateProxy
@synthesize secondaryDelegate =_secondaryDelegate;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature *signature = [[self.secondaryDelegate class] instanceMethodSignatureForSelector:selector];
	if (!signature) {
		signature = [super methodSignatureForSelector:selector];
	}
	return signature;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	if ([self.secondaryDelegate respondsToSelector:aSelector]) {
		return YES;
	} else if (aSelector == @selector(window:willPositionSheet:usingRect:)) {
		return YES;
	}
	return NO;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	if ([self.secondaryDelegate respondsToSelector:[anInvocation selector]]) {
		[anInvocation invokeWithTarget:self.secondaryDelegate];
	}
}

- (NSRect)window:(IMBToolbarWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect
{
	// Somehow the forwarding machinery doesn't handle this.
	if ([self.secondaryDelegate respondsToSelector:_cmd]) {
		return [self.secondaryDelegate window:window willPositionSheet:sheet usingRect:rect];
	}
	rect.origin.y = NSHeight(window.frame) - window.titleBarHeight;
	return rect;
}

- (BOOL)isKindOfClass:(Class)aClass
{
	if (self.secondaryDelegate) {
		return [self.secondaryDelegate isKindOfClass:aClass];
	}
	return NO;
}

@end

@interface IMBToolbarWindow ()
- (void)_doInitialWindowSetup;
- (void)_createTitlebarView;
- (void)_setupTrafficLightsTrackingArea;
- (void)_recalculateFrameForTitleBarContainer;
- (void)_repositionContentView;
- (void)_layoutTrafficLightsAndContent;
- (CGFloat)_minimumTitlebarHeight;
- (void)_displayWindowAndTitlebar;
- (void)_hideTitleBarView:(BOOL)hidden;
- (CGFloat)_defaultTrafficLightLeftMargin;
- (CGFloat)_defaultTrafficLightSeparation;
- (NSRect)_contentViewFrame;
- (NSButton *)_closeButtonToLayout;
- (NSButton *)_minimizeButtonToLayout;
- (NSButton *)_zoomButtonToLayout;
- (NSButton *)_fullScreenButtonToLayout;
@end

@implementation IMBTitlebarView

- (void)drawNoiseWithOpacity:(CGFloat)opacity
{
	static CGImageRef noiseImageRef = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		NSUInteger width = 124, height = width;
		NSUInteger size = width * height;
		char *rgba = (char *) malloc(size);
		srand(120);
		for (NSUInteger i = 0; i < size; ++i) {rgba[i] = (char) arc4random() % 256;}
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
		CGContextRef bitmapContext =
        CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, (CGBitmapInfo) kCGImageAlphaNone);
		CFRelease(colorSpace);
		noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
		CFRelease(bitmapContext);
		free(rgba);
	});
    
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextSetAlpha(context, opacity);
	CGContextSetBlendMode(context, kCGBlendModeScreen);
    
	if ([[self window] respondsToSelector:@selector(backingScaleFactor)]) {
        //TODO:build in 10.6
        CGFloat scaleFactor = 1.0;
        if ([[self window] respondsToSelector:@selector(backingScaleFactor)]) {
//            scaleFactor = [[self window] backingScaleFactor];
        }
		CGContextScaleCTM(context, 1 / scaleFactor, 1 / scaleFactor);
	}
    
	CGRect imageRect = (CGRect) {CGPointZero, (CGSize) {CGImageGetWidth(noiseImageRef), CGImageGetHeight(noiseImageRef)}};
	CGContextDrawTiledImage(context, imageRect, noiseImageRef);
	CGContextRestoreGState(context);
}

- (void)drawWindowBackgroundGradient:(NSRect)drawingRect showsBaselineSeparator:(BOOL)showsBaselineSeparator clippingPath:(CGPathRef)clippingPath
{
	IMBToolbarWindow *window = (IMBToolbarWindow *)[self window];
    
	INApplyClippingPathInCurrentContext(clippingPath);
    
	if ((window.styleMask & NSTexturedBackgroundWindowMask) == NSTexturedBackgroundWindowMask) {
		// If this is a textured window, we can draw the real background gradient and noise pattern
		CGFloat contentBorderThickness = window.titleBarHeight;
		if (((window.styleMask & NSFullScreenWindowMask) != NSFullScreenWindowMask)) {
			contentBorderThickness -= window._minimumTitlebarHeight;
		}
        
		[window setAutorecalculatesContentBorderThickness:NO forEdge:NSMaxYEdge];
		[window setContentBorderThickness:contentBorderThickness forEdge:NSMaxYEdge];
        
		NSDrawWindowBackground(drawingRect);
	} else {
		// Not textured, we have to fake the background gradient and noise pattern
		BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
        
		NSColor *startColor = drawsAsMainWindow ? window.titleBarStartColor : window.inactiveTitleBarStartColor;
		NSColor *endColor = drawsAsMainWindow ? window.titleBarEndColor : window.inactiveTitleBarEndColor;
        
		startColor = startColor ? startColor : [IMBToolbarWindow defaultTitleBarStartColor:drawsAsMainWindow];
		endColor = endColor ? endColor : [IMBToolbarWindow defaultTitleBarEndColor:drawsAsMainWindow];
        
		CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
		CGGradientRef gradient = INCreateGradientWithColors(startColor, endColor);
		CGContextDrawLinearGradient(context, gradient, CGPointMake(NSMidX(drawingRect), NSMinY(drawingRect)), CGPointMake(NSMidX(drawingRect), NSMaxY(drawingRect)), 0);
		CGGradientRelease(gradient);
        
		if (INRunningLion() && drawsAsMainWindow) {
            NSRect noiseRect = NSInsetRect(drawingRect, 1.0, 1.0);
            
			if (!showsBaselineSeparator) {
				CGFloat separatorHeight = self.baselineSeparatorFrame.size.height;
				noiseRect.origin.y -= separatorHeight;
				noiseRect.size.height += separatorHeight;
			}
            
			CGContextSaveGState(context);
            
			CGPathRef noiseClippingPath = INCreateClippingPathWithRectAndRadius(noiseRect, INCornerClipRadius);
			CGContextAddPath(context, noiseClippingPath);
			CGContextClip(context);
			CGPathRelease(noiseClippingPath);
            
			[self drawNoiseWithOpacity:0.1];
            
			CGContextRestoreGState(context);
		}
	}
	
	if (showsBaselineSeparator) {
		[self drawBaselineSeparator:self.baselineSeparatorFrame];
	}
}

- (void)drawBaselineSeparator:(NSRect)separatorFrame
{
	IMBToolbarWindow *window = (IMBToolbarWindow *) [self window];
	BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    
	NSColor *bottomColor = drawsAsMainWindow ? window.baselineSeparatorColor : window.inactiveBaselineSeparatorColor;
    
	bottomColor = bottomColor ? bottomColor : [IMBToolbarWindow defaultBaselineSeparatorColor:drawsAsMainWindow];
    
	[bottomColor set];
	NSRectFill(separatorFrame);
    
	if (INRunningLion()) {
		separatorFrame.origin.y += separatorFrame.size.height;
		separatorFrame.size.height = 1.0;
		[[NSColor colorWithDeviceWhite:1.0 alpha:0.12] setFill];
		[[NSBezierPath bezierPathWithRect:separatorFrame] fill];
	}
}

- (void)drawRect:(NSRect)dirtyRect
{
	IMBToolbarWindow *window = (IMBToolbarWindow *)[self window];
	BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    
	// Start by filling the title bar area with black in fullscreen mode to match native apps
	// Custom title bar drawing blocks can simply override this by not applying the clipping path
	if ((([window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)) {
		[[NSColor blackColor] setFill];
		[[NSBezierPath bezierPathWithRect:self.bounds] fill];
	}
    
	CGPathRef clippingPath = NULL;
	NSRect drawingRect = [self bounds];
    
	if (window.titleBarDrawingBlock) {
		clippingPath = INCreateClippingPathWithRectAndRadius(drawingRect, INCornerClipRadius);
		window.titleBarDrawingBlock(drawsAsMainWindow, NSRectToCGRect(drawingRect), clippingPath);
	} else {
		// There's a thin whitish line between the darker gray window border line
		// and the gray noise textured gradient; preserve that when drawing a native title bar
		NSRect clippingRect = drawingRect;
		clippingRect.size.height -= 1;
		clippingPath = INCreateClippingPathWithRectAndRadius(clippingRect, INCornerClipRadius);
        
		[self drawWindowBackgroundGradient:drawingRect showsBaselineSeparator:window.showsBaselineSeparator clippingPath:clippingPath];
	}
    
	CGPathRelease(clippingPath);
    
	if ([window showsTitle] && (([window styleMask] & NSFullScreenWindowMask) == 0 || window.showsTitleInFullscreen)) {
		NSRect titleTextRect;
		NSDictionary *titleTextStyles = nil;
		[self getTitleFrame:&titleTextRect textAttributes:&titleTextStyles forWindow:window];
        
		if (window.verticallyCenterTitle) {
			titleTextRect.origin.y = floor(NSMidY(drawingRect) - (NSHeight(titleTextRect) / 2.f) + 1);
		}
        
		[window.title drawInRect:titleTextRect withAttributes:titleTextStyles];
	}
}

- (NSRect)baselineSeparatorFrame
{
	const NSRect windowBounds = self.bounds;
	return NSMakeRect(0, NSMinY(windowBounds), NSWidth(windowBounds), 1);
}

- (void)getTitleFrame:(out NSRect *)frame textAttributes:(out NSDictionary **)attributes forWindow:(in IMBToolbarWindow *)window
{
	BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
	
	NSShadow *titleTextShadow = drawsAsMainWindow ? window.titleTextShadow : window.inactiveTitleTextShadow;
	if (titleTextShadow == nil) {
		titleTextShadow = [[NSShadow alloc] init];
		titleTextShadow.shadowBlurRadius = 0.0;
		titleTextShadow.shadowOffset = NSMakeSize(0, -1);
		titleTextShadow.shadowColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.5];
	}
	
	NSColor *titleTextColor = drawsAsMainWindow ? window.titleTextColor : window.inactiveTitleTextColor;
	titleTextColor = titleTextColor ? titleTextColor : [IMBToolbarWindow defaultTitleTextColor:drawsAsMainWindow];
	
	NSFont *titleFont = window.titleFont ?: [NSFont titleBarFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]];
	
	NSMutableParagraphStyle *titleParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[titleParagraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	NSDictionary *titleTextStyles = @{NSFontAttributeName : titleFont,
									  NSForegroundColorAttributeName : titleTextColor,
									  NSShadowAttributeName : titleTextShadow,
									  NSParagraphStyleAttributeName : titleParagraphStyle};
	NSSize titleSize = [window.title sizeWithAttributes:titleTextStyles];
	NSRect titleTextRect;
	titleTextRect.size = titleSize;
	
	NSButton *docIconButton = [window standardWindowButton:NSWindowDocumentIconButton];
	NSButton *versionsButton = [window standardWindowButton:NSWindowDocumentVersionsButton];
	NSButton *closeButton = [window _closeButtonToLayout];
	NSButton *minimizeButton = [window _minimizeButtonToLayout];
	NSButton *zoomButton = [window _zoomButtonToLayout];
	if (docIconButton) {
		NSRect docIconButtonFrame = [self convertRect:docIconButton.frame fromView:docIconButton.superview];
		titleTextRect.origin.x = NSMaxX(docIconButtonFrame) + INTitleDocumentButtonOffset.width;
		titleTextRect.origin.y = NSMidY(docIconButtonFrame) - titleSize.height / 2 + INTitleDocumentButtonOffset.height;
	} else if (versionsButton) {
		NSRect versionsButtonFrame = [self convertRect:versionsButton.frame fromView:versionsButton.superview];
		titleTextRect.origin.x = NSMinX(versionsButtonFrame) - titleSize.width + INTitleVersionsButtonXOffset;
		
		NSDocument *document = (NSDocument *) [(NSWindowController *) self.window.windowController document];
		if ([document hasUnautosavedChanges] || [document isDocumentEdited]) {
			titleTextRect.origin.x += INTitleDocumentStatusXOffset;
		}
	} else if (closeButton || minimizeButton || zoomButton) {
		CGFloat closeMaxX = NSMaxX(closeButton.frame);
		CGFloat minimizeMaxX = NSMaxX(minimizeButton.frame);
		CGFloat zoomMaxX = NSMaxX(zoomButton.frame);
		
		CGFloat adjustedX = MAX(MAX(closeMaxX, minimizeMaxX), zoomMaxX) + INTitleMargins.width;
		CGFloat proposedX = NSMidX(self.bounds) - titleSize.width / 2;
		
		titleTextRect.origin.x = (proposedX < adjustedX) ? adjustedX : proposedX;
	} else {
		titleTextRect.origin.x = NSMidX(self.bounds) - titleSize.width / 2;
	}
	
	NSButton *fullScreenButton = [window _fullScreenButtonToLayout];
	if (fullScreenButton) {
		CGFloat fullScreenX = fullScreenButton.frame.origin.x;
		CGFloat maxTitleX = NSMaxX(titleTextRect);
		if ((fullScreenX - INTitleMargins.width) < NSMaxX(titleTextRect)) {
			titleTextRect.size.width = titleTextRect.size.width - (maxTitleX - fullScreenX) - INTitleMargins.width;
		}
	}
	
	titleTextRect.origin.y = NSMaxY(self.bounds) - titleSize.height - INTitleMargins.height;
	
	if (frame) {
		*frame = titleTextRect;
	}
	if (attributes) {
		*attributes = titleTextStyles;
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	if ([theEvent clickCount] == 2) {
		// Get settings from "System Preferences" >	 "Appearance" > "Double-click on windows title bar to minimize"
		NSString *const MDAppleMiniaturizeOnDoubleClickKey = @"AppleMiniaturizeOnDoubleClick";
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		BOOL shouldMiniaturize = [[userDefaults objectForKey:MDAppleMiniaturizeOnDoubleClickKey] boolValue];
		if (shouldMiniaturize) {
			[[self window] performMiniaturize:self];
		}
	}
}

@end

@interface IMBTitlebarContainer : NSView {
@private
    CGFloat _mouseDragDetectionThreshold;
}
@property (nonatomic) CGFloat mouseDragDetectionThreshold;

@end

@implementation IMBTitlebarContainer
@synthesize mouseDragDetectionThreshold = _mouseDragDetectionThreshold;

- (instancetype)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	if (self) {
		_mouseDragDetectionThreshold = 1;
	}
	return self;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSWindow *window = [self window];
	if ([window isMovableByWindowBackground] || ([window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask) {
		[super mouseDragged:theEvent];
		return;
	}
    
	NSPoint where = [window convertBaseToScreen:[theEvent locationInWindow]];
	NSPoint origin = [window frame].origin;
	CGFloat deltaX = 0.0;
	CGFloat deltaY = 0.0;
	while ((theEvent = [NSApp nextEventMatchingMask:NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSLeftMouseUpMask untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES]) && ([theEvent type] != NSLeftMouseUp)) {
		@autoreleasepool {
			NSPoint now = [window convertBaseToScreen:[theEvent locationInWindow]];
			deltaX += now.x - where.x;
			deltaY += now.y - where.y;
			if (fabs(deltaX) >= _mouseDragDetectionThreshold || fabs(deltaY) >= _mouseDragDetectionThreshold) {
				// This part is only called if drag occurs on container view!
				origin.x += deltaX;
				origin.y += deltaY;
				[window setFrameOrigin:origin];
				deltaX = 0.0;
				deltaY = 0.0;
			}
            // this should be inside above if but doing that results in jittering while moving the window...
			where = now;
		}
	}
}

@end

@interface IMBToolbarWindowContentView : NSView
@end

@implementation IMBToolbarWindowContentView

- (void)setFrame:(NSRect)frameRect
{
	frameRect = [(IMBToolbarWindow *) self.window _contentViewFrame];
	[super setFrame:frameRect];
}

- (void)setFrameSize:(NSSize)newSize
{
	newSize = [(IMBToolbarWindow *)self.window _contentViewFrame].size;
	[super setFrameSize:newSize];
}

@end

@implementation IMBToolbarWindow
@synthesize windowTitleColor = _windowTitleColor;
@synthesize titleBarHeight =_titleBarHeight;
@synthesize titleBarView = _titleBarView;
@synthesize centerFullScreenButton = _centerFullScreenButton;
@synthesize centerTrafficLightButtons = _centerTrafficLightButtons;
@synthesize verticalTrafficLightButtons = _verticalTrafficLightButtons;
@synthesize verticallyCenterTitle = _verticallyCenterTitle;
@synthesize hideTitleBarInFullScreen = _hideTitleBarInFullScreen;
@synthesize showsBaselineSeparator = _showsBaselineSeparator;
@synthesize trafficLightButtonsLeftMargin = _trafficLightButtonsLeftMargin;
@synthesize trafficLightButtonsTopMargin = _trafficLightButtonsTopMargin;
@synthesize fullScreenButtonRightMargin = _fullScreenButtonRightMargin;
@synthesize fullScreenButtonTopMargin = _fullScreenButtonTopMargin;
@synthesize trafficLightSeparation = _trafficLightSeparation;
@synthesize mouseDragDetectionThreshold = _mouseDragDetectionThreshold;
@synthesize showsTitle = _showsTitle;
@synthesize showsTitleInFullscreen = _showsTitleInFullscreen;
@synthesize showsDocumentProxyIcon = _showsDocumentProxyIcon;
@synthesize closeButton = _closeButton;
@synthesize minimizeButton = _minimizeButton;
@synthesize zoomButton = _zoomButton;
@synthesize fullScreenButton =_fullScreenButton;
@synthesize registerButton = _registerButton;
@synthesize titleFont = _titleFont;
@synthesize titleBarStartColor = _titleBarStartColor;
@synthesize titleBarEndColor = _titleBarEndColor;
@synthesize baselineSeparatorColor = _baselineSeparatorColor;
@synthesize titleTextColor = _titleTextColor;
@synthesize titleTextShadow = _titleTextShadow;
@synthesize inactiveTitleBarStartColor = _inactiveTitleBarStartColor;
@synthesize inactiveTitleBarEndColor = _inactiveTitleBarEndColor;
@synthesize inactiveBaselineSeparatorColor = _inactiveBaselineSeparatorColor;
@synthesize inactiveTitleTextColor = _inactiveTitleTextColor;
@synthesize inactiveTitleTextShadow = _inactiveTitleTextShadow;
@synthesize titleBarDrawingBlock = _titleBarDrawingBlock;
@synthesize cachedTitleBarHeight = _cachedTitleBarHeight;
@synthesize setFullScreenButtonRightMargin = _setFullScreenButtonRightMargin;
@synthesize preventWindowFrameChange = _preventWindowFrameChange;
@synthesize delegateProxy = _delegateProxy;
@synthesize titlebarContainer = _titlebarContainer;
@synthesize regTarget = _regTarget;
@synthesize regAction = _regAction;

#pragma mark -
#pragma mark Initialization

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		[self _doInitialWindowSetup];
	}
	return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen])) {
		[self _doInitialWindowSetup];
	}
	return self;
}

- (void)setRepresentedURL:(NSURL *)url
{
	[super setRepresentedURL:url];
	if (_showsDocumentProxyIcon == NO) {
		[[self standardWindowButton:NSWindowDocumentIconButton] setImage:nil];
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark -
#pragma mark NSWindow Overrides

- (void)becomeKeyWindow
{
	[super becomeKeyWindow];
	[self _updateTitlebarView];
	[self _layoutTrafficLightsAndContent];
	[self _setupTrafficLightsTrackingArea];
}

- (void)resignKeyWindow
{
	[super resignKeyWindow];
	[self _updateTitlebarView];
	[self _layoutTrafficLightsAndContent];
}

- (void)becomeMainWindow
{
	[super becomeMainWindow];
	[self _updateTitlebarView];
}

- (void)resignMainWindow
{
	[super resignMainWindow];
	[self _updateTitlebarView];
}

- (void)setContentView:(NSView *)aView
{
	// Remove performance-optimized content view class when changing content views
	NSView *oldView = [self contentView];
	if (oldView && object_getClass(oldView) == [IMBToolbarWindowContentView class]) {
		object_setClass(oldView, [NSView class]);
	}
    
	[super setContentView:aView];
    
	// Swap in performance-optimized content view class
	if (aView && object_getClass(aView) == [NSView class]) {
		object_setClass(aView, [IMBToolbarWindowContentView class]);
	}
    
	[self _repositionContentView];
}

- (void)setTitle:(NSString *)aString
{
	[super setTitle:aString];
	[self _layoutTrafficLightsAndContent];
	[self _displayWindowAndTitlebar];
}

- (void)setMaxSize:(NSSize)size
{
	[super setMaxSize:size];
	[self _layoutTrafficLightsAndContent];
}

- (void)setMinSize:(NSSize)size
{
	[super setMinSize:size];
	[self _layoutTrafficLightsAndContent];
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleBarView:(NSView *)newTitleBarView
{
	if ((_titleBarView != newTitleBarView) && newTitleBarView) {
		[_titleBarView removeFromSuperview];
		_titleBarView = newTitleBarView;
		[_titleBarView setFrame:[_titlebarContainer bounds]];
		[_titleBarView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		[_titlebarContainer addSubview:_titleBarView];
	}
}

- (NSView *)titleBarView
{
	return _titleBarView;
}

- (void)setTitleBarHeight:(CGFloat)newTitleBarHeight
{
	[self setTitleBarHeight:newTitleBarHeight adjustWindowFrame:YES];
}

- (void)setTitleBarHeight:(CGFloat)newTitleBarHeight adjustWindowFrame:(BOOL)adjustWindowFrame
{
	if (_titleBarHeight != newTitleBarHeight) {
		NSRect windowFrame = self.frame;
		if (adjustWindowFrame)
		{
			windowFrame.origin.y -= newTitleBarHeight - _titleBarHeight;
			windowFrame.size.height += newTitleBarHeight - _titleBarHeight;
		}
        
		_cachedTitleBarHeight = newTitleBarHeight;
		_titleBarHeight = _cachedTitleBarHeight;
        
		[self setFrame:windowFrame display:YES];
        
		[self _layoutTrafficLightsAndContent];
		[self _displayWindowAndTitlebar];
        
		if ((self.styleMask & NSTexturedBackgroundWindowMask) == NSTexturedBackgroundWindowMask)
			[self.contentView displayIfNeeded];
	}
}

- (CGFloat)titleBarHeight
{
	return _titleBarHeight;
}

- (void)setShowsBaselineSeparator:(BOOL)showsBaselineSeparator
{
	if (_showsBaselineSeparator != showsBaselineSeparator) {
		_showsBaselineSeparator = showsBaselineSeparator;
		[self.titleBarView setNeedsDisplay:YES];
	}
}

- (BOOL)showsBaselineSeparator
{
	return _showsBaselineSeparator;
}

- (void)setTrafficLightButtonsLeftMargin:(CGFloat)newTrafficLightButtonsLeftMargin
{
	if (_trafficLightButtonsLeftMargin != newTrafficLightButtonsLeftMargin) {
		_trafficLightButtonsLeftMargin = newTrafficLightButtonsLeftMargin;
		[self _layoutTrafficLightsAndContent];
		[self _displayWindowAndTitlebar];
		[self _setupTrafficLightsTrackingArea];
	}
}

- (CGFloat)trafficLightButtonsLeftMargin
{
	return _trafficLightButtonsLeftMargin;
}


- (void)setFullScreenButtonRightMargin:(CGFloat)newFullScreenButtonRightMargin
{
	if (_fullScreenButtonRightMargin != newFullScreenButtonRightMargin) {
		_setFullScreenButtonRightMargin = YES;
		_fullScreenButtonRightMargin = newFullScreenButtonRightMargin;
		[self _layoutTrafficLightsAndContent];
		[self _displayWindowAndTitlebar];
	}
}

- (CGFloat)fullScreenButtonRightMargin
{
	return _fullScreenButtonRightMargin;
}

- (void)setShowsTitle:(BOOL)showsTitle
{
	if (_showsTitle != showsTitle) {
		_showsTitle = showsTitle;
		[self _displayWindowAndTitlebar];
	}
}

- (void)setShowsDocumentProxyIcon:(BOOL)showsDocumentProxyIcon
{
	if (_showsDocumentProxyIcon != showsDocumentProxyIcon) {
		_showsDocumentProxyIcon = showsDocumentProxyIcon;
		[self _displayWindowAndTitlebar];
	}
}

- (void)setCenterFullScreenButton:(BOOL)centerFullScreenButton
{
	if (_centerFullScreenButton != centerFullScreenButton) {
		_centerFullScreenButton = centerFullScreenButton;
		[self _layoutTrafficLightsAndContent];
	}
}

- (void)setCenterTrafficLightButtons:(BOOL)centerTrafficLightButtons
{
	if (_centerTrafficLightButtons != centerTrafficLightButtons) {
		_centerTrafficLightButtons = centerTrafficLightButtons;
		[self _layoutTrafficLightsAndContent];
		[self _setupTrafficLightsTrackingArea];
	}
}

- (void)setVerticalTrafficLightButtons:(BOOL)verticalTrafficLightButtons
{
	if (_verticalTrafficLightButtons != verticalTrafficLightButtons) {
		_verticalTrafficLightButtons = verticalTrafficLightButtons;
		[self _layoutTrafficLightsAndContent];
		[self _setupTrafficLightsTrackingArea];
	}
}

- (void)setVerticallyCenterTitle:(BOOL)verticallyCenterTitle
{
	if (_verticallyCenterTitle != verticallyCenterTitle) {
		_verticallyCenterTitle = verticallyCenterTitle;
		[self _displayWindowAndTitlebar];
	}
}

- (void)setTrafficLightSeparation:(CGFloat)trafficLightSeparation
{
	if (_trafficLightSeparation != trafficLightSeparation) {
		_trafficLightSeparation = trafficLightSeparation;
		[self _layoutTrafficLightsAndContent];
		[self _setupTrafficLightsTrackingArea];
	}
}

- (void)setMouseDragDetectionThreshold:(CGFloat)mouseDragDetectionThreshold
{
	_titlebarContainer.mouseDragDetectionThreshold = mouseDragDetectionThreshold;
}

- (CGFloat)mouseDragDetectionThreshold
{
	return _titlebarContainer.mouseDragDetectionThreshold;
}

- (void)setDelegate:(id <NSWindowDelegate>)anObject
{
	[_delegateProxy setSecondaryDelegate:anObject];
	[super setDelegate:nil];
	[super setDelegate:_delegateProxy];
}

- (id <NSWindowDelegate>)delegate
{
	return [_delegateProxy secondaryDelegate];
}

- (void)setCloseButton:(IMBWindowButton *)closeButton
{
	
    if (_closeButton != closeButton) {
		[_closeButton removeFromSuperview];
		_closeButton = closeButton;
		if (_closeButton) {
			_closeButton.target = self;
			_closeButton.action = @selector(performClose:);
//			[_closeButton setFrameOrigin:[[self standardWindowButton:NSWindowCloseButton] frame].origin];
            [_closeButton setFrameOrigin:NSMakePoint([[self standardWindowButton:NSWindowCloseButton] frame].origin.x, [[self standardWindowButton:NSWindowCloseButton] frame].origin.y +8) ] ;
			[_closeButton.cell accessibilitySetOverrideValue:NSAccessibilityCloseButtonSubrole forAttribute:NSAccessibilitySubroleAttribute];
			[_closeButton.cell accessibilitySetOverrideValue:NSAccessibilityRoleDescription(NSAccessibilityButtonRole, NSAccessibilityCloseButtonSubrole) forAttribute:NSAccessibilityRoleDescriptionAttribute];
			[[self themeFrameView] addSubview:_closeButton];
		}
	}
}

- (void)setMinimizeButton:(IMBWindowButton *)minimizeButton
{
	if (_minimizeButton != minimizeButton) {
		[_minimizeButton removeFromSuperview];
		_minimizeButton = minimizeButton;
		if (_minimizeButton) {
			_minimizeButton.target = self;
			_minimizeButton.action = @selector(performMiniaturize:);
			[_minimizeButton setFrameOrigin:[[self standardWindowButton:NSWindowMiniaturizeButton] frame].origin];
			[_minimizeButton.cell accessibilitySetOverrideValue:NSAccessibilityMinimizeButtonSubrole forAttribute:NSAccessibilitySubroleAttribute];
			[_minimizeButton.cell accessibilitySetOverrideValue:NSAccessibilityRoleDescription(NSAccessibilityButtonRole, NSAccessibilityMinimizeButtonSubrole) forAttribute:NSAccessibilityRoleDescriptionAttribute];
            
			[[self themeFrameView] addSubview:_minimizeButton];
		}
	}
}

- (void)setZoomButton:(IMBWindowButton *)zoomButton
{
	if (_zoomButton != zoomButton) {
		[_zoomButton removeFromSuperview];
		_zoomButton = zoomButton;
		if (_zoomButton) {
			_zoomButton.target = self;
			_zoomButton.action = @selector(performZoom:);
			[_zoomButton setFrameOrigin:[[self standardWindowButton:NSWindowZoomButton] frame].origin];
			[_zoomButton.cell accessibilitySetOverrideValue:NSAccessibilityZoomButtonSubrole forAttribute:NSAccessibilitySubroleAttribute];
			[_zoomButton.cell accessibilitySetOverrideValue:NSAccessibilityRoleDescription(NSAccessibilityButtonRole, NSAccessibilityZoomButtonSubrole) forAttribute:NSAccessibilityRoleDescriptionAttribute];
			[[self themeFrameView] addSubview:_zoomButton];
		}
	}
}

- (void)setFullScreenButton:(IMBWindowButton *)fullScreenButton
{
	if (_fullScreenButton != fullScreenButton) {
		[_fullScreenButton removeFromSuperview];
		_fullScreenButton = fullScreenButton;
		if (_fullScreenButton) {
			_fullScreenButton.target = self;
			_fullScreenButton.action = @selector(toggleFullScreen:);
			[_fullScreenButton setFrameOrigin:[[self standardWindowButton:NSWindowFullScreenButton] frame].origin];
			[_fullScreenButton.cell accessibilitySetOverrideValue:NSAccessibilityFullScreenButtonSubrole forAttribute:NSAccessibilitySubroleAttribute];
			[_fullScreenButton.cell accessibilitySetOverrideValue:NSAccessibilityRoleDescription(NSAccessibilityButtonRole, NSAccessibilityFullScreenButtonSubrole) forAttribute:NSAccessibilityRoleDescriptionAttribute];
			[[self themeFrameView] addSubview:_fullScreenButton];
		}
	}
}

- (void)setRegisterButton:(IMBCustomButton*)registerButton {
    if (registerButton != nil) {
        int margin = 26;
        if (_registerButton != registerButton) {
            [_registerButton removeFromSuperview];
            _registerButton = registerButton;
            if (_registerButton) {
                _registerButton.target = self.regTarget;
                _registerButton.action = self.regAction;
                NSButton *fullBtn = [self standardWindowButton:NSWindowFullScreenButton];
                float x = 0;
                float y = 0;
                if (fullBtn != nil) {
                    x = fullBtn.frame.origin.x - registerButton.frame.size.width - self.fullScreenButtonRightMargin - margin;
                    y = fullBtn.frame.origin.y;
                } else {
                    NSButton *closeBtn = [self standardWindowButton:NSWindowCloseButton];
                    x = [self themeFrameView].frame.size.width - registerButton.frame.size.width - margin;
                    y = closeBtn.frame.origin.y;
                }
                [_registerButton setFrameOrigin:NSMakePoint(x, y)];
                [[self themeFrameView] addSubview:_registerButton];
            }
        } else {
            NSButton *fullBtn = [self standardWindowButton:NSWindowFullScreenButton];
            float x = 0;
            float y = 0;
            if (fullBtn != nil) {
                x = fullBtn.frame.origin.x - registerButton.frame.size.width - self.fullScreenButtonRightMargin - margin;
                y = fullBtn.frame.origin.y;
            } else {
                NSButton *closeBtn = [self standardWindowButton:NSWindowCloseButton];
                x = [self themeFrameView].frame.size.width - registerButton.frame.size.width - margin;
                y = closeBtn.frame.origin.y;
            }
            [_registerButton setFrameOrigin:NSMakePoint(x, y)];
        }
    } else {
        if (_registerButton != nil) {
            [_registerButton removeFromSuperview];
            _registerButton = registerButton;
        }
    }
}

- (void)resetRegisterButtonPos {
    int margin = 26;
    if (self.registerButton != nil) {
        NSButton *fullBtn = [self standardWindowButton:NSWindowFullScreenButton];
        float x = 0;
        float y = 0;
        if (fullBtn != nil) {
            x = fullBtn.frame.origin.x - self.registerButton.frame.size.width - self.fullScreenButtonRightMargin - margin;
            y = fullBtn.frame.origin.y;
        } else {
            NSButton *closeBtn = [self standardWindowButton:NSWindowCloseButton];
            x = [self themeFrameView].frame.size.width - self.registerButton.frame.size.width - margin;
            y = closeBtn.frame.origin.y;
        }
        [self.registerButton setFrameOrigin:NSMakePoint(x, y)];
    }
}


- (void)setStyleMask:(NSUInteger)styleMask
{
	_preventWindowFrameChange = YES;
    
	// Prevent drawing artifacts when turning off NSTexturedBackgroundWindowMask before
	// exiting from full screen and then resizing the title bar; the problem is that internally
	// the content border is still set to the previous value, which confuses the system
	if (((self.styleMask & NSTexturedBackgroundWindowMask) == NSTexturedBackgroundWindowMask) &&
        ((styleMask & NSTexturedBackgroundWindowMask) != NSTexturedBackgroundWindowMask)) {
		[self setContentBorderThickness:0 forEdge:NSMaxYEdge];
		[self setAutorecalculatesContentBorderThickness:YES forEdge:NSMaxYEdge];
	}
    
	[super setStyleMask:styleMask];
	[self _displayWindowAndTitlebar];
	[self.contentView display]; // force display, the view doesn't think it needs it, but it does
	_preventWindowFrameChange = NO;
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)flag
{
	if (!_preventWindowFrameChange)
		[super setFrame:frameRect display:flag];
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animateFlag
{
	if (!_preventWindowFrameChange)
		[super setFrame:frameRect display:displayFlag animate:animateFlag];
}

#pragma mark -
#pragma mark Private

- (void)_doInitialWindowSetup
{
	_showsBaselineSeparator = YES;
	_centerTrafficLightButtons = YES;
	_titleBarHeight = [self _minimumTitlebarHeight];
	_cachedTitleBarHeight = _titleBarHeight;
	_trafficLightButtonsLeftMargin = [self _defaultTrafficLightLeftMargin];
	_delegateProxy = [IMBToolbarWindowDelegateProxy alloc];
	_trafficLightButtonsTopMargin = 3.f;
	_fullScreenButtonTopMargin = 3.f;
	_trafficLightSeparation = [self _defaultTrafficLightSeparation];
	[super setDelegate:_delegateProxy];
    
	/** -----------------------------------------
	 - The window automatically does layout every time its moved or resized, which means that the traffic lights and content view get reset at the original positions, so we need to put them back in place
	 - NSWindow is hardcoded to redraw the traffic lights in a specific rect, so when they are moved down, only part of the buttons get redrawn, causing graphical artifacts. Therefore, the window must be force redrawn every time it becomes key/resigns key
	 ----------------------------------------- **/
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidResizeNotification object:self];
	[nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidMoveNotification object:self];
	[nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidEndSheetNotification object:self];
    
	[nc addObserver:self selector:@selector(_updateTitlebarView) name:NSApplicationDidBecomeActiveNotification object:nil];
	[nc addObserver:self selector:@selector(_updateTitlebarView) name:NSApplicationDidResignActiveNotification object:nil];
	if (INRunningLion()) {
		[nc addObserver:self selector:@selector(windowDidExitFullScreen:) name:NSWindowDidExitFullScreenNotification object:self];
		[nc addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object:self];
		[nc addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object:self];
	}
    
	[self _createTitlebarView];
	[self _layoutTrafficLightsAndContent];
	[self _setupTrafficLightsTrackingArea];
}

- (NSButton *)_windowButtonToLayout:(NSWindowButton)defaultButtonType orUserProvided:(NSButton *)userButton
{
	NSButton *defaultButton = [self standardWindowButton:defaultButtonType];
	if (userButton) {
		[defaultButton setHidden:YES];
		defaultButton = userButton;
	} else if ([defaultButton superview] != [self themeFrameView]) {
		[defaultButton setHidden:NO];
	}
	return defaultButton;
}

- (NSButton *)_closeButtonToLayout
{
	return [self _windowButtonToLayout:NSWindowCloseButton orUserProvided:self.closeButton];
}

- (NSButton *)_minimizeButtonToLayout
{
	return [self _windowButtonToLayout:NSWindowMiniaturizeButton orUserProvided:self.minimizeButton];
}

- (NSButton *)_zoomButtonToLayout
{
	return [self _windowButtonToLayout:NSWindowZoomButton orUserProvided:self.zoomButton];
}

- (NSButton *)_fullScreenButtonToLayout
{
	return [self _windowButtonToLayout:NSWindowFullScreenButton orUserProvided:self.fullScreenButton];
}

- (void)_layoutTrafficLightsAndContent
{
	// Reposition/resize the title bar view as needed
	[self _recalculateFrameForTitleBarContainer];
	NSButton *close = [self _closeButtonToLayout];
	NSButton *minimize = [self _minimizeButtonToLayout];
	NSButton *zoom = [self _zoomButtonToLayout];
    
	// Set the frame of the window buttons
	NSRect closeFrame = [close frame];
	NSRect minimizeFrame = [minimize frame];
	NSRect zoomFrame = [zoom frame];
	NSRect titleBarFrame = [_titlebarContainer frame];
	CGFloat buttonOrigin = 0.0;
	if (!self.verticalTrafficLightButtons) {
		if (self.centerTrafficLightButtons) {
			//buttonOrigin = round(NSMidY(titleBarFrame) - INMidHeight(closeFrame));
            buttonOrigin = floor(titleBarFrame.origin.y + titleBarFrame.size.height) - closeFrame.size.height - self.trafficLightButtonsTopMargin;
		} else {
			buttonOrigin = NSMaxY(titleBarFrame) - NSHeight(closeFrame) - self.trafficLightButtonsTopMargin;
		}
		closeFrame.origin.y = buttonOrigin;
		minimizeFrame.origin.y = buttonOrigin;
		zoomFrame.origin.y = buttonOrigin;
		closeFrame.origin.x = self.trafficLightButtonsLeftMargin;
		minimizeFrame.origin.x = NSMaxX(closeFrame) + self.trafficLightSeparation;
		zoomFrame.origin.x = NSMaxX(minimizeFrame) + self.trafficLightSeparation;
	} else {
		CGFloat groupHeight = NSHeight(closeFrame) + NSHeight(minimizeFrame) + NSHeight(zoomFrame) + 2.f * (self.trafficLightSeparation - 2.f);
		if (self.centerTrafficLightButtons) {
			buttonOrigin = round(NSMidY(titleBarFrame) - groupHeight / 2.f);
		} else {
			buttonOrigin = NSMaxY(titleBarFrame) - groupHeight - self.trafficLightButtonsTopMargin;
		}
		closeFrame.origin.x = self.trafficLightButtonsLeftMargin;
		minimizeFrame.origin.x = self.trafficLightButtonsLeftMargin;
		zoomFrame.origin.x = self.trafficLightButtonsLeftMargin;
		zoomFrame.origin.y = buttonOrigin;
		minimizeFrame.origin.y = NSMaxY(zoomFrame) + self.trafficLightSeparation - 2.f;
		closeFrame.origin.y = NSMaxY(minimizeFrame) + self.trafficLightSeparation - 2.f;
	}
	[close setFrame:closeFrame];
	[minimize setFrame:minimizeFrame];
	[zoom setFrame:zoomFrame];
    
	NSButton *docIconButton = [self standardWindowButton:NSWindowDocumentIconButton];
	if (docIconButton) {
		NSRect docButtonIconFrame = [docIconButton frame];
        
		if (self.verticallyCenterTitle) {
			docButtonIconFrame.origin.y = floor(NSMidY(titleBarFrame) - INMidHeight(docButtonIconFrame));
		} else {
			docButtonIconFrame.origin.y = NSMaxY(titleBarFrame) - NSHeight(docButtonIconFrame) - INWindowDocumentIconButtonOriginY;
		}
        
		[docIconButton setFrame:docButtonIconFrame];
	}
    
	// Set the frame of the FullScreen button in Lion if available
	if (INRunningLion()) {
		NSButton *fullScreen = [self _fullScreenButtonToLayout];
        [self setRegisterButton:_registerButton];
		if (fullScreen) {
			NSRect fullScreenFrame = [fullScreen frame];
			if (!_setFullScreenButtonRightMargin) {
				self.fullScreenButtonRightMargin = NSWidth([_titlebarContainer frame]) - NSMaxX(fullScreen.frame);
			}
			fullScreenFrame.origin.x = NSWidth(titleBarFrame) - NSWidth(fullScreenFrame) - _fullScreenButtonRightMargin;
			if (self.centerFullScreenButton) {
				//fullScreenFrame.origin.y = floor(NSMidY(titleBarFrame) - INMidHeight(fullScreenFrame));
                fullScreenFrame.origin.y = floor(titleBarFrame.origin.y + titleBarFrame.size.height) - fullScreenFrame.size.height - self.fullScreenButtonTopMargin;
			} else {
				fullScreenFrame.origin.y = NSMaxY(titleBarFrame) - NSHeight(fullScreenFrame) - self.fullScreenButtonTopMargin;
			}
			[fullScreen setFrame:fullScreenFrame];
		}
        
		NSButton *versionsButton = [self standardWindowButton:NSWindowDocumentVersionsButton];
		if (versionsButton) {
			NSRect versionsButtonFrame = [versionsButton frame];
            
			if (self.verticallyCenterTitle) {
				versionsButtonFrame.origin.y = floor(NSMidY(titleBarFrame) - INMidHeight(versionsButtonFrame));
			} else {
				versionsButtonFrame.origin.y = NSMaxY(titleBarFrame) - NSHeight(versionsButtonFrame) - INWindowDocumentVersionsButtonOriginY;
			}
            
			[versionsButton setFrame:versionsButtonFrame];
            
			// Also ensure that the title font is set
			if (self.titleFont) {
				[versionsButton setFont:self.titleFont];
			}
		}
        
		for (id subview in [[[self contentView] superview] subviews]) {
			if ([subview isKindOfClass:[NSTextField class]]) {
				NSTextField *textField = (NSTextField *) subview;
				NSRect textFieldFrame = [textField frame];
                
				if (self.verticallyCenterTitle) {
					textFieldFrame.origin.y = round(NSMidY(titleBarFrame) - INMidHeight(textFieldFrame));
				} else {
					textFieldFrame.origin.y = NSMaxY(titleBarFrame) - NSHeight(textFieldFrame) - INWindowDocumentVersionsDividerOriginY;
				}
                
				[textField setFrame:textFieldFrame];
                
				// Also ensure that the font is set
				if (self.titleFont) {
					[textField setFont:self.titleFont];
				}
			}
		}
	}
	[self _repositionContentView];
}

- (void)undoManagerDidCloseUndoGroupNotification:(NSNotification *)notification
{
	[self _displayWindowAndTitlebar];
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
	if (_hideTitleBarInFullScreen) {
		// Recalculate the views when entering from fullscreen
		_titleBarHeight = 0.0f;
		[self _layoutTrafficLightsAndContent];
		[self _displayWindowAndTitlebar];
        
		[self _hideTitleBarView:YES];
	}
}

- (void)windowWillExitFullScreen:(NSNotification *)notification
{
	if (_hideTitleBarInFullScreen) {
		_titleBarHeight = _cachedTitleBarHeight;
		[self _layoutTrafficLightsAndContent];
		[self _displayWindowAndTitlebar];
        
		[self _hideTitleBarView:NO];
	}
}

- (void)windowDidExitFullScreen:(NSNotification *)notification
{
	[self _layoutTrafficLightsAndContent];
	[self _setupTrafficLightsTrackingArea];
}

- (NSView *)themeFrameView
{
//    self.titlebarAppearsTransparent = YES;
	return [[self contentView] superview];
}

- (void)_createTitlebarView
{
	// Create the title bar view
	IMBTitlebarContainer *container = [[IMBTitlebarContainer alloc] initWithFrame:NSZeroRect];
	// Configure the view properties and add it as a subview of the theme frame
	NSView *firstSubview = [[[self themeFrameView] subviews] objectAtIndex:0];
	[self _recalculateFrameForTitleBarContainer];
    NSView *themeFrameView = [self themeFrameView];
	[themeFrameView addSubview:container positioned:NSWindowBelow relativeTo:firstSubview];
//    id themeFrameView = [self themeFrameView];
//    [themeFrameView performSelector:NSSelectorFromString(@"_addKnownSubview:positioned:relativeTo:") withObjects:container,NSWindowBelow,firstSubview,[ZLEndMark end]];
	_titlebarContainer = container;
	self.titleBarView = [[IMBTitlebarView alloc] initWithFrame:NSZeroRect];
}



- (void)_hideTitleBarView:(BOOL)hidden
{
	[self.titleBarView setHidden:hidden];
}

- (void)_setupTrafficLightsTrackingArea
{
	[[self themeFrameView] viewWillStartLiveResize];
	[[self themeFrameView] viewDidEndLiveResize];
}

- (void)_recalculateFrameForTitleBarContainer
{
	NSRect themeFrameRect = [[self themeFrameView] frame];
	NSRect titleFrame = NSMakeRect(0.0, NSMaxY(themeFrameRect) - _titleBarHeight, NSWidth(themeFrameRect), _titleBarHeight);
	[_titlebarContainer setFrame:titleFrame];
}

- (NSRect)_contentViewFrame
{
	NSRect windowFrame = self.frame;
	NSRect contentRect = [self contentRectForFrameRect:windowFrame];
    
	contentRect.size.height = NSHeight(windowFrame) - _titleBarHeight;
	contentRect.origin = NSZeroPoint;
    
	return contentRect;
}

- (void)_repositionContentView
{
	NSView *contentView = [self contentView];
	NSRect newFrame = [self _contentViewFrame];
    
	if (!NSEqualRects([contentView frame], newFrame)) {
		[contentView setFrame:newFrame];
		[contentView setNeedsDisplay:YES];
	}
}

- (CGFloat)_minimumTitlebarHeight
{
	static CGFloat minTitleHeight = 0.0;
	if (!minTitleHeight) {
		NSRect frameRect = [self frame];
		NSRect contentRect = [self contentRectForFrameRect:frameRect];
		minTitleHeight = NSHeight(frameRect) - NSHeight(contentRect);
	}
	return minTitleHeight;
}

- (CGFloat)_defaultTrafficLightLeftMargin
{
	static CGFloat trafficLightLeftMargin = 0.0;
	if (!trafficLightLeftMargin) {
		NSButton *close = [self _closeButtonToLayout];
		trafficLightLeftMargin = NSMinX(close.frame);
	}
	return trafficLightLeftMargin;
}

- (CGFloat)_defaultTrafficLightSeparation
{
	static CGFloat trafficLightSeparation = 0.0;
	if (!trafficLightSeparation) {
		NSButton *close = [self _closeButtonToLayout];
		NSButton *minimize = [self _minimizeButtonToLayout];
		trafficLightSeparation = NSMinX(minimize.frame) - NSMaxX(close.frame);
	}
	return trafficLightSeparation;
}

- (void)_displayWindowAndTitlebar
{
	// Redraw the window and titlebar
	[_titleBarView setNeedsDisplay:YES];
}

- (void)_updateTitlebarView
{
	[_titleBarView setNeedsDisplay:YES];
    
	// "validate" any controls in the titlebar view
	BOOL isMainWindowAndActive = ([self isMainWindow] && [[NSApplication sharedApplication] isActive]);
	for (NSView *childView in [_titleBarView subviews]) {
		if ([childView isKindOfClass:[NSControl class]]) {
			[(NSControl *) childView setEnabled:isMainWindowAndActive];
		}
	}
}

+ (NSColor *)defaultTitleBarStartColor:(BOOL)drawsAsMainWindow
{
	if (INRunningLion())
		return [NSColor whiteColor];//drawsAsMainWindow ? [NSColor colorWithDeviceWhite:0.66 alpha:1.0] : [NSColor colorWithDeviceWhite:0.878 alpha:1.0];
	else
		return [NSColor whiteColor];//drawsAsMainWindow ? [NSColor colorWithDeviceWhite:0.659 alpha:1.0] : [NSColor colorWithDeviceWhite:0.851 alpha:1.0];
}

+ (NSColor *)defaultTitleBarEndColor:(BOOL)drawsAsMainWindow
{
	if (INRunningLion())
		return [NSColor whiteColor];//drawsAsMainWindow ? [NSColor colorWithDeviceWhite:0.9 alpha:1.0] : [NSColor colorWithDeviceWhite:0.976 alpha:1.0];
	else
		return [NSColor whiteColor];//drawsAsMainWindow ? [NSColor colorWithDeviceWhite:0.812 alpha:1.0] : [NSColor colorWithDeviceWhite:0.929 alpha:1.0];
}

+ (NSColor *)defaultBaselineSeparatorColor:(BOOL)drawsAsMainWindow
{
	if (INRunningLion())
		return [NSColor whiteColor];//drawsAsMainWindow ? [NSColor colorWithDeviceWhite:0.408 alpha:1.0] : [NSColor colorWithDeviceWhite:0.655 alpha:1.0];
	else
		return [NSColor whiteColor];//drawsAsMainWindow ? [NSColor colorWithDeviceWhite:0.318 alpha:1.0] : [NSColor colorWithDeviceWhite:0.600 alpha:1.0];
}

+ (NSColor *)defaultTitleTextColor:(BOOL)drawsAsMainWindow
{
	return drawsAsMainWindow ? [NSColor colorWithDeviceWhite:56.0/255.0 alpha:1.0] : [NSColor colorWithDeviceWhite:56.0/255.0 alpha:0.5];
}

//luo lei add
//- (void)sendEvent:(NSEvent *)theEvent
//{
//    NSView *contentView = self.contentView;
//    for (int i = 0; i<5; i++) {
//        
//        NSArray *subArray = [contentView subviews];
//        if ([subArray count]>0) {
//            contentView = [subArray objectAtIndex:0];
//        }
//        if ([contentView isKindOfClass:[IMBDeviceInforView class]]) {
//            NSPoint point = [contentView convertPoint:theEvent.locationInWindow fromView:nil];
//            if (![[contentView hitTest:point] isKindOfClass:[IMBOneKeyButton class]]&&![[contentView hitTest:point] isKindOfClass:[IMBOneKeyfield class]]&&![[contentView hitTest:point] isKindOfClass:[IMBOneKeyImageView class]]&&![[contentView hitTest:point] isKindOfClass:[IMBFunctionButton class]]&&![[contentView hitTest:point] isKindOfClass:[NSButton class]])
//            {
//                
//                NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:theEvent,@"theEvent",@"other",@"classType", nil];
//                if (theEvent.type == 2) {
//                   
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CLOSE_POPUPVIEW object:nil userInfo:infor];
//                }
//                
//                
//            }
//        }
//        if ([contentView isKindOfClass:[IMBTabView class]] && ![[contentView hitTest:theEvent.locationInWindow] isKindOfClass:[IMBFunctionButton class]] && ![[contentView hitTest:theEvent.locationInWindow] isKindOfClass:[NSButton class]]) {
//            if (theEvent.type == 2) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NO_CLICK_CAGETORY_BTN object:nil userInfo:nil];
//            }
//        }
//    }
//    [super sendEvent:theEvent];
//}

@end
