//
//  IMBTextField.m
//  iMobieTrans
//
//  Created by iMobie on 5/29/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBTextField.h"
#import "StringHelper.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"

@implementation IMBTextField
@synthesize maxPreferenceWidth = _maxPreferenceWidth;
@synthesize initialWidth = _initialWidth;
@synthesize initialHeight = _initialHeight;
@synthesize handleDelegate = _handleDelegate;
@synthesize fontSize = _fontSize;
@synthesize drawFontColor = _drawFontColor;
@synthesize viewBeyondBasic = _viewBeyondBasic;
@synthesize isEmpty = _isEmpty;
@synthesize bindingEntity = _bindingEntity;
@synthesize bindingEntityKeyPath = _bindingEntityKeyPath;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.delegate = self;
        [self setBezelStyle:NSTextFieldSquareBezel];
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        self.delegate = self;
        [self setBezelStyle:NSTextFieldRoundedBezel];

    }
    return self;
}



- (void)dealloc{
    if (_shapeLayer != nil) {
        [_shapeLayer release];
        _shapeLayer = nil;
    }
    if (_drawFontColor != nil) {
        [_drawFontColor release];
        _drawFontColor = nil;
    }
    if (_bindingEntity != nil) {
        [_bindingEntity release];
        _bindingEntity = nil;
    }
    if (_bindingEntityKeyPath != nil) {
        [_bindingEntityKeyPath release];
        _bindingEntityKeyPath = nil;
    }
    [super dealloc];
}

- (void)awakeFromNib{
    isInitFromNib = YES;
    [self initView];
}

- (void)viewDidMoveToSuperview{
    [self initView];
    [super viewDidMoveToSuperview];
}

- (BOOL)isFlipped{
    return NO;
}

- (void)setFontSize:(float)fontSize{
    _fontSize = fontSize;
    [super setFont:[NSFont fontWithName:@"Helvetica Neue" size:fontSize]];
//    [self textDidChange:nil];
}

- (void)setDrawFontColor:(NSColor *)drawFontColor{
    _drawFontColor = [drawFontColor retain];
    [self setTextColor:_drawFontColor];
}

- (void)initView{
    _isEditing = false;
    [self setAlignment:NSNaturalTextAlignment];
    [self setBezeled:_isEditing];
    [self setBordered:_isEditing];
//    [self setDrawsBackground:NO];
    [self setBezelStyle:NSTextFieldAndStepperDatePickerStyle];
    [self setNeedsDisplay:YES];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setFocusRingType:NSFocusRingTypeNone];
    if(_fontSize <= 0){
        _fontSize = 11.0;
    }
    _drawFontColor = [[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] retain];
    [self setFont:[NSFont fontWithName:@"Helvetica Neue" size:_fontSize]];
    [self.cell setWraps:YES];
    [self.cell setLineBreakMode:NSLineBreakByWordWrapping];
    [self.cell setAlignment:NSLeftTextAlignment];
    [self setContinuous:YES];
    if(_maxPreferenceWidth <= 0)
    {
        [self setMaxPreferenceWidth:self.frame.size.width];
    }
    [self setAutoresizesSubviews:YES];
    initRect = self.bounds;
    if ([self acceptsFirstResponder]) {
        _isEditing = true;
        [self setNeedsDisplay:true];
    }
    _initialHeight = self.bounds.size.height;
    _initialWidth = self.bounds.size.width;
}

- (void)setInitialWidth:(float)initialWidth{
    if (_initialWidth != initialWidth) {
        _initialWidth = initialWidth;
        [self textDidChange:nil];

    }
}

-(void)mouseDown:(NSEvent *)event {
    if (!self.isEnabled) {
        return;
    }
    [super mouseDown:event];

    if(!_isEditing)
    {
        _isEditing = true;
        [self setNeedsDisplay:YES];
//        NSRange range = NSMakeRange(0, self.stringValue.length);
//        [self.cell selectWithFrame:[self bounds] inView:self editor:self.currentEditor delegate:self start:range.location length:range.length];
    }
}

- (void)setMaxPreferenceWidth:(float)maxPreferenceWidth{
    _maxPreferenceWidth = maxPreferenceWidth;
    if (_maxPreferenceWidth == 458) {
        NSLog(@"123");
    }
    if (self.frame.size.width > maxPreferenceWidth) {
        NSRect rect = self.frame;
        rect.size.width = maxPreferenceWidth;
        
        [self setFrame:rect];
        [self setNeedsDisplay];
    }
    [self setPreferredMaxLayoutWidth:_maxPreferenceWidth];
}

- (void)keyDown:(NSEvent *)theEvent{

}

- (void)textDidBeginEditing:(NSNotification *)notification{
    [super textDidBeginEditing:notification];
    _isEditing = YES;
}

- (void)textDidChange:(NSNotification *)notification{
    if (notification != nil) {
        [super textDidChange:notification];
    }
//	[self invalidateIntrinsicContentSize];
    if (!isInitFromNib) {
        NSRect calcuateRect = [self calcuTextBounds:self.stringValue fontSize:_fontSize width:_maxPreferenceWidth];
        int newheight = calcuateRect.size.height;
        int newwidth = calcuateRect.size.width;
        if (newwidth >= self.frame.size.width - 6 && self.frame.size.width <= _maxPreferenceWidth) {
            NSRect rect = self.frame;
            rect.size.width = newwidth + 6;
            if (rect.size.width > _maxPreferenceWidth) {
                rect.size.width = _maxPreferenceWidth;
            }
            [self setFrame:rect];
            NSRect newCalculateRect = [self calcuTextBounds:self.stringValue fontSize:_fontSize width:_maxPreferenceWidth];
            int newnewHeigt = newCalculateRect.size.height;
            NSRect otherrect = self.frame;
            otherrect.size.height = newnewHeigt;
            [self setFrame:otherrect];
            [[self currentEditor] setFrame:self.frame];
            [self setNeedsDisplay:YES];
            if ([_handleDelegate respondsToSelector:@selector(textFieldFrameChanged:)]) {
                [_handleDelegate textFieldFrameChanged:self];
            }
        }
        else{
            if (newwidth <= _maxPreferenceWidth - 6 && newwidth >= _initialWidth) {
                NSRect rect = self.frame;
                rect.size.width = newwidth + 6;
                [self setFrame:rect];
                NSRect newCalculateRect = [self calcuTextBounds:self.stringValue fontSize:_fontSize width:_maxPreferenceWidth];
                int newnewHeigt = newCalculateRect.size.height;
                NSRect otherrect = self.frame;
                otherrect.size.height = newnewHeigt;
                [self setFrame:otherrect];
                [[self currentEditor] setFrame:self.frame];
                
                [self setNeedsDisplay:YES];
            }
            else{
                NSRect rect = self.frame;
                if (newwidth + 6 < _initialWidth) {
                    rect.size.width = _initialWidth;
                }
                else{
                    rect.size.width = newwidth + 6;
                }
                rect.size.height = newheight;
                [self setFrame:rect];
                [[self currentEditor] setFrame:self.frame];
                [self setNeedsDisplay:YES];
            }
            if ([_handleDelegate respondsToSelector:@selector(textFieldFrameChanged:)]) {
                [_handleDelegate textFieldFrameChanged:self];
            }
            BOOL isNowEmpty = [self stringValue].length == 0;
            if (isNowEmpty != _isEmpty) {
                _isEmpty = isNowEmpty;
                if ([_handleDelegate respondsToSelector:@selector(emptyFieldInItemViewHasEdit:)]) {
                    [_handleDelegate emptyFieldInItemViewHasEdit:self];
                }
            }
        }
        [self manuallySetAttributedString:self.stringValue];
        if (_bindingEntityKeyPath.length > 0 && _bindingEntity != nil) {
            [_bindingEntity unbind:_bindingEntityKeyPath];
            [_bindingEntity bind:_bindingEntityKeyPath toObject:self withKeyPath:@"stringValue" options:nil];
        }
    }
    else{
        [self invalidateIntrinsicContentSize];
    }
}

- (CGFloat)singleLineHeight{
    if (self.stringValue.length == 0) {
        return _initialHeight;
    }
    else{
        NSString *string = [self.stringValue substringToIndex:1];
        NSSize size = [self calcuTextBounds:string fontSize:12.0 width:200].size;
        return size.height;
    }
}

- (void)textDidEndEditing:(NSNotification *)notification{

    [super textDidEndEditing:notification];
    _isEditing = NO;
    [self setNeedsDisplay:YES];

}


- (void)manuallySetAttributedString:(NSString *)aString{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:aString];
    if (aString != nil) {
        [attributeString addAttributes:[self attributesWithSize:_fontSize color:_drawFontColor] range:NSMakeRange(0, aString.length)];
        [self setAttributedStringValue:attributeString];
    }
    [attributeString release];
}

- (void)setFrame:(NSRect)frameRect{
    [super setFrame:frameRect];
    if (_maxPreferenceWidth == 0) {
        [self setMaxPreferenceWidth:frameRect.size.width];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
//    [[NSColor whiteColor] set];
//    NSRectFill(dirtyRect);
    NSPoint origin = { 0.0,0.0 };
    NSRect rect;
    rect.origin = origin;
    rect.size.width  = [self bounds].size.width;
    rect.size.height = [self bounds].size.height;
//    [[NSColor colorWithCalibratedWhite:1.0 alpha:0.394] set];
//    [path fill];
    if (_isEditing) {
        [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
    }
    else{
        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];

    }
    
    if (([[self window] firstResponder] == [self currentEditor]) && [NSApp isActive])
    {
        NSBezierPath * path;
        path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
        [path setLineWidth:1];
        [path fill];
        
        NSBezierPath * path1;
        path1 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
        [path1 setLineWidth:1];
        [path1 stroke];

        [CATransaction setDisableActions:YES];
        if (!isAddShapeLayer) {
            isAddShapeLayer = true;
            [self setWantsLayer:YES];
            if(_shapeLayer == nil){
                NSRect shadowRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width + 0.5 , rect.size.height + 3);
                NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRect:shadowRect];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                [shapeLayer setShadowColor:CGColorCreateGenericRGB(242/255, 242/255, 242/255, 0.4)];
                [shapeLayer setShadowOffset:CGSizeMake(0.5, 3)];
                [shapeLayer setShadowOpacity:1.0];
                [shapeLayer setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width + 0.5, rect.size.height + 3)];
                [shapeLayer setShadowPath:[shadowPath quartzPath]];
                _shapeLayer = [shapeLayer retain];
                [_shapeLayer removeAllAnimations];
            }
            [self.superview setWantsLayer:YES];
            [_shapeLayer setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width + 0.5, rect.size.height + 3)];
            [self.superview.layer insertSublayer:_shapeLayer atIndex:0];
            [self.superview.layer removeAllAnimations];
        }
        else{
            NSRect shadowRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width + 0.5 , rect.size.height + 3);
            NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRect:shadowRect];
            [_shapeLayer setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width + 0.5, rect.size.height + 3)];
            [_shapeLayer setShadowPath:[shadowPath quartzPath]];
        }
        
        NSRect newRect = rect;
        newRect.origin.x += 1;
        newRect.size.width -= 2;
        /*
         //        if (self.attributedStringValue.length > 0) {
         //            [[self attributedStringValue] drawInRect:newRect];
         //        }
         //        else{
         //            NSString *string = [[self cell] placeholderString];
         //            if (string != nil) {
         //                NSDictionary *dictionary = [self attributesWithSize:_fontSize color:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
         //                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:dictionary];
         //                [attrString drawInRect:dirtyRect];
         //            }
         //        }
         */

    }
    else
    {
        isAddShapeLayer = false;
        [_shapeLayer removeFromSuperlayer];
        NSRect newRect = rect;
        newRect.origin.x += 1;
        newRect.size.width -= 2;
        if (self.attributedStringValue.length > 0) {
            [[self attributedStringValue] drawInRect:newRect];
        }
        else{
            NSString *string = [[self cell] placeholderString];
            if (string != nil) {
                NSDictionary *dictionary = [self attributesWithSize:_fontSize color:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:dictionary];
                [attrString drawInRect:dirtyRect];
            }
        }
    }
}




-(NSSize)intrinsicContentSize
{
	NSSize intrinsicSize = _lastIntrinsicSize;
	
	// Only update the size if we’re editing the text, or if we’ve not set it yet
	// If we try and update it while another text field is selected, it may shrink back down to only the size of one line (for some reason?)
	if(_isEditing || !_hasLastIntrinsicSize)
	{
		intrinsicSize = [super intrinsicContentSize];
		
		// If we’re being edited, get the shared NSTextView field editor, so we can get more info
		NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
		if([fieldEditor isKindOfClass:[NSTextView class]])
		{
			NSTextView *textView = (NSTextView *)fieldEditor;
			NSRect usedRect = [textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer];
			
			usedRect.size.height += 5.0; // magic number! (the field editor TextView is offset within the NSTextField. It’s easy to get the space above (it’s origin), but it’s difficult to get the default spacing for the bottom, as we may be changing the height
			
			intrinsicSize.height = usedRect.size.height;
		}
		
		_lastIntrinsicSize = intrinsicSize;
		_hasLastIntrinsicSize = YES;
        [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, intrinsicSize.height)];

	}
	
    return intrinsicSize;
}

- (NSDictionary *)attributesWithSize:(float)fontSize color:(NSColor *)color{
    NSColor *thisColor;
    if (color == nil) {
        thisColor = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    }
    else{
        thisColor =color;
    }
    NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineSpacing:1.0];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,thisColor,NSForegroundColorAttributeName,
                                nil];
    return attributes;
}

- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize width:(CGFloat)width{
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSSize textSize = [as.string sizeWithAttributes:[self attributesWithSize:fontSize color:nil]];
        
        float textWidth = textSize.width;
        float height = textSize.height;
        if (_maxPreferenceWidth == 0) {
            _maxPreferenceWidth = self.frame.size.width == 0 ? 200:0;
        }
        if (textWidth > _maxPreferenceWidth - 4) {
            textWidth =  _maxPreferenceWidth -4;
            height = [self heightForStringDrawing:text fontSize:fontSize myWidth:textWidth] + 5;
        }
        else{
            height = [self heightForStringDrawing:text fontSize:fontSize myWidth:textWidth] + 5;
        }
        height = MAX(_initialHeight, height);
        
        textBounds = NSMakeRect(0, 0, textWidth, height);
    }
    return textBounds;
}

- (float)heightForStringDrawing:(NSString *)myString fontSize:(float)fontSize myWidth:(float) myWidth {
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage setAttributes:[self attributesWithSize:fontSize color:nil] range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager
            usedRectForTextContainer:textContainer].size.height;
}


@end
