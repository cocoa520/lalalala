        //
//  IMBCustomTextFiled.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCustomTextFiled.h"

@implementation IMBCustomTextFiled
@synthesize needPasteboardContent = _needPasteboardContent;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.

    }
    return self;
}

-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeKeyWindow:) name:@" " object:nil];
}

- (void)becomeKeyWindow:(NSNotification *)notification
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *types = [pasteboard types];
    if ([types containsObject:NSPasteboardTypeString]) {
        NSString *s = [pasteboard stringForType:NSPasteboardTypeString];
        if (s != nil&&_needPasteboardContent) {
            if ([s hasPrefix:@"http"]&&self.isEnabled) {
                [self setStringValue:s];
            }
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
//    [IMBCommonTool setViewBgWithView:self color:COLOR_MAIN_WINDOW_TEXTFIELD_BG delta:0 radius:4.0f dirtyRect:dirtyRect];
    [super drawRect:dirtyRect];
    // Drawing code here.
    
}

-(BOOL)acceptsFirstResponder {
    return YES;
}

- (void)textDidChange:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TEXTFILED_INPUT_CHANGE object:self userInfo:nil];
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
}

//- (void)textDidEndEditing:(NSNotification *)notification {
//    _isEditing = NO;
//    [super textDidEndEditing:notification];
//    [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_END object:self];
//}

- (BOOL)textView:(NSTextView *)inTextView doCommandBySelector:(SEL)inSelector{
    
    //tab 键
    if (inSelector == @selector(insertTab:)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:INSERT_TAB object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_END object:self];
		return YES;
        //回车键
	}
//    else if (inSelector == @selector(insertNewline:) || inSelector == @selector(insertNewlineIgnoringFieldEditor:)) {
//		if (self.target && [self.target respondsToSelector:self.action])
//			[self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
//		return YES;
//	}
	return NO;
}

- (void)textDidBeginEditing:(NSNotification *)notification {
    [super textDidBeginEditing:notification];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:TEXTFILED_MOUSE_DOWN object:self];
    [super mouseDown:theEvent];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MainWindowBecomeKeyWindow" object:nil];
    [super dealloc];
}
@end
