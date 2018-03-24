//
//  customTextFiled.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "customTextFiled.h"
#import "IMBNotificationDefine.h"
#import "IMBCommonDefine.h"
#import "IMBCommonTool.h"
#import "StringHelper.h"
@implementation customTextFiled
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeKeyWindow:) name:@"MainWindowBecomeKeyWindow" object:nil];
//    if (self.placeholderString) {
//        NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
//        [textAttr setValue:COLOR_MAIN_WINDOW_TEXTFIELD_PLACEHOLDER forKey:NSForegroundColorAttributeName];
//        NSMutableAttributedString *textAttrString = [[NSMutableAttributedString alloc] initWithString:self.placeholderString attributes:textAttr];
//        [self setPlaceholderAttributedString:textAttrString];
////        [textAttr release];
////        textAttr = nil;
//    }
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

- (void)textDidChange:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TEXTFILED_INPUT_CHANGE object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REGISTER_TEXTFILED_INPUT_CHANGE object:self userInfo:nil];
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
}



- (BOOL)textView:(NSTextView *)inTextView doCommandBySelector:(SEL)inSelector{
    
    //tab 键
    if (inSelector == @selector(insertTab:)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:INSERT_TAB object:nil];
		return YES;
        //回车键
	} else if (inSelector == @selector(insertNewline:) || inSelector == @selector(insertNewlineIgnoringFieldEditor:)) {
		if (self.target && [self.target respondsToSelector:self.action])
			[self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
		return YES;
	}
	return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MainWindowBecomeKeyWindow" object:nil];
    [super dealloc];
}
@end
