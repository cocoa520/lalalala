//
//  IMBGridTextField.m
//  AllFiles
//
//  Created by iMobie on 2018/5/4.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBGridTextField.h"

@implementation IMBGridTextField

@synthesize dlg = _dlg;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
    }
    return self;
}

- (void)textDidChange:(NSNotification *)notification {
    if (self.stringValue.length > 24) {
        self.stringValue = [self.stringValue substringWithRange:NSMakeRange(0, 24)];
    }
}


- (BOOL)textView:(NSTextView *)inTextView doCommandBySelector:(SEL)inSelector{
    
    //tab 键
    if (inSelector == @selector(insertTab:)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:INSERT_TAB object:nil];
        return YES;
        
    }else if (inSelector == @selector(deleteBackward:)) {
        //删除按键
        [[NSNotificationCenter defaultCenter] postNotificationName:INSERT_BACKSPASE object:nil];
    }
    else if (inSelector == @selector(insertNewline:) || inSelector == @selector(insertNewlineIgnoringFieldEditor:)) {
        //回车键
        
        if ([self.dlg respondsToSelector:@selector(gridTextFieldInsertNewline)]) {
            [self.dlg gridTextFieldInsertNewline];
        }
        
        if (self.gridTextfieldInsertNewline) {
            self.gridTextfieldInsertNewline();
        }
        return YES;
    }
    return NO;
}
@end
