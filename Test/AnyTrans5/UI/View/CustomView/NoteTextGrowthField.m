    //
//  TSTTextGrowth.m
//  autoGrowingExample
//
//  Created by Scott O'Brien on 1/01/13.
//  Fixed by Douglas Heriot on 1/01/13, inspired by
//  https://github.com/jerrykrinock/CategoriesObjC/blob/master/NS(Attributed)String%2BGeometrics/NS(Attributed)String%2BGeometrics.m
//  https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html
//  http://stackoverflow.com/questions/14107385/getting-a-nstextfield-to-grow-with-the-text-in-auto-layout
//  Copyright (c) 2013 Scott O'Brien. All rights reserved.
//

#import "NoteTextGrowthField.h"
//#import "IMBCommonDefine.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation NoteTextGrowthField
@synthesize isEditing = _isEditing;
@synthesize editAttributedString = _editAttributedString;
@synthesize bindingEntityKeyPath = _bindingEntityKeyPath;
@synthesize bindingEntity = _bindingEntity;
@synthesize canBeEditing = _canBeEditing;
@synthesize fontSize = _fontSize;
@synthesize isCalendarNote = _isCalendarNote;
@synthesize isFillet = _isFillet;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setDelegate:self];
        NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
        if([fieldEditor isKindOfClass:[NSTextView class]])
        {
            NSTextView *textView = (NSTextView *)fieldEditor;
            [textView setDelegate:self];
        }
        _isCalendarNote = NO;
        originSize = self.frame.size;
        focusQueue = dispatch_queue_create("focusQueue", NULL);
        _canBeEditing = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    }
    
    return self;
}

- (void)changeSkin:(NSNotification *)notifi {
    [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)viewDidMoveToSuperview{
    [self setIsEditing:YES];
    NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
    if (fieldEditor == nil) {
        dispatch_async(focusQueue, ^{
            [self findEditor];
        });
    }
}

- (void)viewDidUnhide{
    
}

- (void)mouseDown:(NSEvent *)theEvent{
    if (_isCalendarNote) {
        _isEditing = YES;
        [super mouseDown:theEvent];
    } else {
        if (!self.isEnabled) {
            return;
        }
        else{
            if ([self.window firstResponder] != self) {
                [self.window makeFirstResponder:self];
            }
        }
    }
    
}

- (void)setCanBeEditing:(BOOL)canBeEditing{
    _canBeEditing = canBeEditing;
    NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
    if([fieldEditor isKindOfClass:[NSTextView class]])
    {
        NSTextView *textView = (NSTextView *)fieldEditor;
        [textView setEditable:_canBeEditing];
        [textView setSelectable:_canBeEditing];
    }
    [self setEditable:canBeEditing];
    [self setSelectable:canBeEditing];
}

- (BOOL)becomeFirstResponder{
    BOOL isFirstResponder = [super becomeFirstResponder];
        if (isFirstResponder) {
            _isEditing = YES;
            NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
            if (fieldEditor == nil) {
                dispatch_async(focusQueue, ^{
                    [self findEditor];
                });
                return isFirstResponder;
            }
            NSTextView *_textView = nil;
            if([fieldEditor isKindOfClass:[NSTextView class]])
            {
                NSTextView *textView = (NSTextView *)fieldEditor;
                [textView setDelegate:self];
                _textView = textView;
            }
            if (self.stringValue.length > 0) {
                [_textView setSelectedRange:NSMakeRange(0, 0)];
                [_textView.textStorage addAttributes:[self attributes] range:NSMakeRange(0, self.stringValue.length)];
            }
            [self intrinsicContentSize];
        }

    return isFirstResponder;
}


- (void)findEditor{
    
    if (!_isCalendarNote) {
        NSText *fieldEditor = nil;
        do{
            fieldEditor = [self.window fieldEditor:NO forObject:self];
            if (fieldEditor == nil) {
                [self.window makeFirstResponder:self];
                usleep(20);
            }
        }
        while (fieldEditor == nil) ;
        if (fieldEditor && [fieldEditor isKindOfClass:[NSTextView class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //            NSTextView *textView = (NSTextView *)fieldEditor;
                NSString *drawString = self.stringValue;
                if (drawString.length == 0) {
                    drawString = @"";
                }
                NSMutableString *string = [drawString mutableCopy];
                [string appendString:@"\n"];
                [self setStringValue:string];
                [self setStringValue:drawString];
                [string release];
            });
            
        }
    }
   
}

- (BOOL)resignFirstResponder{
    BOOL isFirstResponder = [super resignFirstResponder];
    return isFirstResponder;
}


- (BOOL)acceptsFirstResponder {
    BOOL isFirstResponder = [super acceptsFirstResponder];
    return isFirstResponder;
}

- (void)textDidBeginEditing:(NSNotification *)notification
{
	[super textDidBeginEditing:notification];
	_isEditing = YES;
    [self setAttributedStringValue:[self textAttributeString]];
	[self intrinsicContentSize];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
//	[super textDidEndEditing:notification];
    if (_isCalendarNote) {
        [self setAttributedStringValue:[self textAttributeString]];
        [self intrinsicContentSize];
    }
	_isEditing = NO;
}

- (void)textDidChange:(NSNotification *)notification
{
    if (notification != nil && _canBeEditing) {
        [super textDidChange:notification];
    }
    [self setAttributedStringValue:[self textAttributeString]];
	[self intrinsicContentSize];
    if (_bindingEntityKeyPath.length > 0 && _bindingEntity != nil) {
        [_bindingEntity unbind:_bindingEntityKeyPath];
        [_bindingEntity bind:_bindingEntityKeyPath toObject:self withKeyPath:@"stringValue" options:nil];
    }
}

- (void)setBindingEntity:(id)bindingEntiy andPath:(NSString *)bindingPath{
    if (_bindingEntityKeyPath.length > 0 && _bindingEntity != nil) {
        [_bindingEntity unbind:_bindingEntityKeyPath];
    }
    [_bindingEntity release];_bindingEntity = nil;
    [_bindingEntityKeyPath release];_bindingEntityKeyPath = nil;
    _bindingEntity = [bindingEntiy retain];
    _bindingEntityKeyPath = [bindingPath retain];
    [_bindingEntity bind:_bindingEntityKeyPath toObject:self withKeyPath:@"stringValue" options:nil];
}

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector{
    BOOL retval = NO;
    
    if (commandSelector == @selector(insertNewline:)) {
        
        retval = YES; // causes Apple to NOT fire the default enter action
        
        // Do your special handling of the "enter" key here
        NSRange range = [textView selectedRange];
        if (range.location != NSNotFound) {
            NSString *findString = [self.stringValue stringByReplacingCharactersInRange:range withString:@"\n"];
            
            [self setStringValue:findString];
            if (range.location + 1 <= self.stringValue.length) {
                [textView setSelectedRange:NSMakeRange(range.location + 1, 0)];
            }
        }
        else{
            NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:@"\n"] autorelease];
            [textView.textStorage appendAttributedString:string];
        }
        [self intrinsicContentSize];
        
    }
    return retval;

}

- (NSAttributedString *)textAttributeString {
    NSMutableAttributedString *attributeString = [[[NSMutableAttributedString alloc] initWithString:self.stringValue attributes:[self attributes]] autorelease];
    return attributeString;
}

- (NSDictionary *)attributes{
    float fontSize = 0;
    if (_fontSize > 0) {
        fontSize = _fontSize;
    }else {
        fontSize = 15.0;
    }

    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:4.0];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];

    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:fontSize],NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)],NSForegroundColorAttributeName,nil];
    return fontDic;
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (_isEditing) {
        [self becomeFirstResponder];
    }
}

- (void)setStringValue:(NSString *)aString{
    if (aString.length == 0) {
        aString = @"";
    }
    if (![aString isEqualToString:@"\n"]) {
        [super setStringValue:aString];
    }
    [self textDidChange:nil];
}

- (void)setFontSize:(float)fontSize {
    if (fontSize > 0) {
        _fontSize = fontSize;
    } else {
        _fontSize = 14.0;
    }
}

-(NSSize)intrinsicContentSize
{
	NSSize intrinsicSize = _lastIntrinsicSize;
	
	// Only update the size if we’re editing the text, or if we’ve not set it yet
	// If we try and update it while another text field is selected, it may shrink back down to only the size of one line (for sodsme reason?)
	if(_isEditing || !_hasLastIntrinsicSize)
	{
		intrinsicSize = [super intrinsicContentSize];
		
		// If we’re being edited, get the shared NSTextView field editor, so we can get more info
		NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
        NSTextView *editableTextView = nil;
		if([fieldEditor isKindOfClass:[NSTextView class]])
		{
            NSTextView *textView = (NSTextView *)fieldEditor;
            editableTextView = [textView retain];
            [textView setEditable:_canBeEditing];
            [textView setSelectable:_canBeEditing];
            if (textView.textStorage.length < self.stringValue.length) {
                return NSMakeSize(0, 0);
            }
            [textView.textStorage addAttributes:[self attributes] range:NSMakeRange(0, self.stringValue.length)];
//			(void)[textView.textContainer.layoutManager glyphRangeForTextContainer:textView.textContainer];//加上这句在10.11.6系统上展示note数据会崩溃
            self.editAttributedString = textView.attributedString;
            NSRect usedRect = [textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer];
            if (_isCalendarNote) {
                intrinsicSize.height = usedRect.size.height;
                if (intrinsicSize.height < 112) {
                    intrinsicSize.height = 112;
                }
            } else {
                intrinsicSize.height = usedRect.size.height + 15;
            }
            
		}

        
        if (intrinsicSize.height != _lastIntrinsicSize.height) {
            if (intrinsicSize.height < 27) {
                intrinsicSize.height = 400;
            }
            [self setFrameSize:NSMakeSize(self.frame.size.width, intrinsicSize.height+20)];
            [self.superview setFrameSize:NSMakeSize(self.superview.frame.size.width, self.frame.origin.y + self.frame.size.height + 50)];
            if (editableTextView != nil) {
                NSUInteger cursorPosition ;
                cursorPosition = [[[editableTextView selectedRanges] firstObject] rangeValue].location ;
                [editableTextView scrollRangeToVisible:NSMakeRange(cursorPosition, 0)] ;
            }
        }
        else{
            if(self.superview.frame.size.height > self.frame.origin.y + self.frame.size.height + 10){
                if (_isCalendarNote) {
                    [self.superview setFrameSize:NSMakeSize(self.superview.frame.size.width, self.frame.origin.y + self.frame.size.height + 50)];
                } else {
                    [self.superview setFrameSize:NSMakeSize(self.superview.frame.size.width, self.frame.origin.y + self.frame.size.height +200)];
                }
                
            }
        }
        
        if (editableTextView != nil) {
            [editableTextView release];
            editableTextView = nil;
        }
		_lastIntrinsicSize = intrinsicSize;
		_hasLastIntrinsicSize = YES;
	}
	
    return intrinsicSize;
}

- (float)heightForStringDrawingWithWidth:(float) myWidth {
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:[self stringValue]] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    NSDictionary *fontDic = [self attributes];
    NSRect rect = [[self stringValue] boundingRectWithSize:NSMakeSize(myWidth, 8000) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
    return rect.size.height;
}

- (void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    if (_isFillet) {
        [self setBordered:NO];
        NSBezierPath *roundRect = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [roundRect addClip];
        [[NSColor clearColor] set];
        [roundRect fill];
        [roundRect setLineWidth:2];
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        [roundRect stroke];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_release(focusQueue),focusQueue = nil;
    [_bindingEntity release],_bindingEntity = nil;
    [_bindingEntityKeyPath release],_bindingEntityKeyPath = nil;
    [super dealloc];
}

@end
