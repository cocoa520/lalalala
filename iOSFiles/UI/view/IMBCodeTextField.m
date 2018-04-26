//
//  IMBCodeTextField.m
//  AnyTrans
//
//  Created by smz on 18/2/28.
//  Copyright (c) 2018年 imobie. All rights reserved.
//

#import "IMBCodeTextField.h"
#import "StringHelper.h"
#import "BRNumberFormatter.h"


#pragma mark - 通知string
NSString * const IMBCodeTextFieldCodeTagKey = @"IMBCodeTextFieldCodeTag";

NSString * const IMBCodeTextFieldDeleteCodeNotification = @"IMBCodeTextFieldDeleteCodeNotification";
NSString * const IMBCodeTextFieldCodeEditCodeNotifation = @"IMBCodeTextFieldCodeEditCodeNotifation";


@implementation IMBCodeTextField

#pragma mark - setup
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setFocusRingType:NSFocusRingTypeNone];
        [self setup];
    }
    return self;
}

- (void)setup {
    [super setFormatter:[[BRNumberFormatter alloc] init]];
    [(NSTextFieldCell*)self.cell setAllowedInputSourceLocales:@[NSAllRomanInputSourcesLocaleIdentifier]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

#pragma mark - keyboard event
//用来监听键盘的点击事件
- (BOOL)textView:(NSTextView *)inTextView doCommandBySelector:(SEL)inSelector {
    
    //删除键
    if (inSelector == @selector(deleteBackward:)) {
        _isDeleting = YES;
        if (self.stringValue.length < 1) {
            NSDictionary *dic = @{IMBCodeTextFieldCodeTagKey:[NSNumber numberWithInt:self.codeTag]};
            [[NSNotificationCenter defaultCenter] postNotificationName:IMBCodeTextFieldDeleteCodeNotification object:dic];
            _isDeleting = NO;
        }
    }
    return NO;
}

- (void)textDidChange:(NSNotification *)notification {
    NSString *str = self.stringValue;
    if (str.length > 1) {
        self.stringValue = [str substringToIndex:1];
    }
    if (str.length == 1) {
        NSDictionary *dic = @{IMBCodeTextFieldCodeTagKey:[NSNumber numberWithInt:self.codeTag]};
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBCodeTextFieldCodeEditCodeNotifation object:dic];
    }
    if (_isDeleting) {
        NSDictionary *dic = @{IMBCodeTextFieldCodeTagKey:[NSNumber numberWithInt:self.codeTag]};
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBCodeTextFieldDeleteCodeNotification object:dic];
        _isDeleting = NO;
    }
}

@end
