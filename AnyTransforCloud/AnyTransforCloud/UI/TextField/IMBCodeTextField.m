//
//  IMBCodeTextField.m
//  AnyTrans
//
//  Created by smz on 18/2/28.
//  Copyright (c) 2018年 imobie. All rights reserved.
//

#import "IMBCodeTextField.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "IMBInputNumberFormat.h"
@implementation IMBCodeTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setFocusRingType:NSFocusRingTypeNone];
        [self setup];
    }
    return self;
}

- (void)setup {
    [super setFormatter:[[IMBInputNumberFormat alloc] init]];
    [(NSTextFieldCell*)self.cell setAllowedInputSourceLocales:@[NSAllRomanInputSourcesLocaleIdentifier]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

//用来监听键盘的点击事件
- (BOOL)textView:(NSTextView *)inTextView doCommandBySelector:(SEL)inSelector {
    
    //删除键
    if (inSelector == @selector(deleteBackward:)) {
        _isDeleting = YES;
        if (self.stringValue.length < 1) {
            NSDictionary *dic = @{@"codeTag":[NSNumber numberWithInt:self.codeTag]};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DELETE_CODE object:dic];
            _isDeleting = NO;
        }
    } else if (inSelector == @selector(insertNewline:)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CODE_ENTERKEY object:nil];
    }
    return NO;
}

- (void)textDidChange:(NSNotification *)notification {
    NSString *str = self.stringValue;
    if (str.length > 1) {
        self.stringValue = [str substringToIndex:1];
    }
    if (str.length == 1) {
        NSDictionary *dic = @{@"codeTag":[NSNumber numberWithInt:self.codeTag]};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_EDIT_CODE object:dic];
    }
    if (_isDeleting) {
        NSDictionary *dic = @{@"codeTag":[NSNumber numberWithInt:self.codeTag]};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DELETE_CODE object:dic];
        _isDeleting = NO;
    }
}

@end
