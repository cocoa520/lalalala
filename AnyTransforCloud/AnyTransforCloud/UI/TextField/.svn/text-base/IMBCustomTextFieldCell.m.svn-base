//
//  IMBCustomTextFieldCell.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/10/21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCustomTextFieldCell.h"

@implementation IMBCustomTextFieldCell
@synthesize cursorColor = _cursorColor;
- (id)copyWithZone:(NSZone *)zone {
    IMBCustomTextFieldCell *cell = (IMBCustomTextFieldCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->_cursorColor = [_cursorColor retain];
    return cell;
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj
{
    if (_cursorColor) {
        NSText *text = [super setUpFieldEditorAttributes:textObj];
        [(NSTextView*)text setInsertionPointColor:_cursorColor];
        return text;
    }else{
        return [super setUpFieldEditorAttributes:textObj];
    }
}

- (void)dealloc
{
    [_cursorColor release], _cursorColor = nil;
    [super dealloc];
}

@end
