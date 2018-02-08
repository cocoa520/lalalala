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

#import "IMBAutoGrowthNSTextField.h"

@interface IMBAutoGrowthNSTextField()

@end

@implementation IMBAutoGrowthNSTextField
@synthesize documentView = documentView;
@synthesize labelTextField = labelTextField;
@synthesize heightMin = heightMin;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    currntHeight = self.frame.size.height;
    heightMin = 22;
    currntHeight = heightMin;
    [self setBordered:NO];
    [self setDelegate:self];
    NSText *fieldEditor = [self.window fieldEditor:NO forObject:self];
    if([fieldEditor isKindOfClass:[NSTextView class]])
    {
        NSTextView *textView = (NSTextView *)fieldEditor;
        [textView setDelegate:self];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
  
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [[NSColor blackColor] setStroke];
    [path addClip];
    [path stroke];

}
- (void)dsfd:(NSView *)_documentView
{
    documentView = _documentView;
    documentViewinitHeight = documentView.frame.size.height;
    currentDocumentHeight = documentViewinitHeight;
}

- (void)textDidBeginEditing:(NSNotification *)notification
{
	[super textDidBeginEditing:notification];
	_isEditing = YES;
}

- (void)textDidEndEditing:(NSNotification *)notification
{
	[super textDidEndEditing:notification];
	_isEditing = NO;
}

- (void)textDidChange:(NSNotification *)notification
{
	[super textDidChange:notification];
	[self invalidateIntrinsicContentSize];
}

- (void)setStringValue:(NSString *)str
{
    [super setStringValue:str];
   
    isInit = YES;
    _hasLastIntrinsicSize = NO;
    CGFloat height = [self getHeight:str];
    if (height>=heightMin&&!isenter) {
        [documentView setFrameSize:NSMakeSize(documentView.frame.size.width, documentView.frame.size.height+(height - 22))];
        [self setFrameSize:NSMakeSize(self.frame.size.width, height)];
         currntHeight = height;
        currentDocumentHeight = documentView.frame.size.height;
    }else if (isenter)
    {
        [documentView setFrameSize:NSMakeSize(documentView.frame.size.width, documentView.frame.size.height
                                              +(height - currntHeight))];
        [self setFrameSize:NSMakeSize(self.frame.size.width, height)];
        currntHeight = height;
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
		if([fieldEditor isKindOfClass:[NSTextView class]]&&!isInit)
		{
			NSTextView *textView = (NSTextView *)fieldEditor;
			NSRect usedRect = [textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer];
           usedRect.size.height += 5.0; // magic number! (the field editor TextView is offset within the NSTextField. It’s easy to get the space above (it’s origin), but it’s difficult to get the default spacing for the bottom, as we may be changing the height
            if (usedRect.size.height>currntHeight) {
                [documentView setFrameSize:NSMakeSize(documentView.frame.size.width, documentView.frame.size.height+(usedRect.size.height - currntHeight))];
                currentDocumentHeight = documentView.frame.size.height;
            }else
            {
                CGFloat height = documentView.frame.size.height-(currntHeight - usedRect.size.height);
               [documentView setFrameSize:NSMakeSize(documentView.frame.size.width, height)];
                currentDocumentHeight = documentView.frame.size.height;
            }
                
            currntHeight = usedRect.size.height;
			intrinsicSize.height = usedRect.size.height;
            _lastIntrinsicSize = intrinsicSize;
            _hasLastIntrinsicSize = YES;

		}else if (isInit)
        {
            CGFloat height = [self getHeight:self.stringValue];
            if (height>=currntHeight) {
                currntHeight = height;
            }
            intrinsicSize.height = currntHeight;
            isInit = NO;
            _lastIntrinsicSize = intrinsicSize;
            _hasLastIntrinsicSize = YES;

        }
	}
    return intrinsicSize;
}

- (CGFloat)getHeight:(NSString *)str
{
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:13],NSFontAttributeName,nil];
    NSRect rect = [str boundingRectWithSize:NSMakeSize(418, 8000) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
   return rect.size.height+5;
}

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector{
    BOOL retval = NO;
    if (commandSelector == @selector(insertNewline:)) {
        
        retval = YES; // causes Apple to NOT fire the default enter action
        
        // Do your special handling of the "enter" key here
        NSRange range = [textView selectedRange];
        if (range.location != NSNotFound) {
            NSString *findString = [self.stringValue stringByReplacingCharactersInRange:range withString:@"\n"];
            isenter = YES;
            [self setStringValue:findString];
            isenter = NO;
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

@end
