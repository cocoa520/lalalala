//
//  customTextFieldCell.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/10/21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "customTextFieldCell.h"
#import "StringHelper.h"
@implementation customTextFieldCell
@synthesize cursorColor = _cursorColor;
- (id)copyWithZone:(NSZone *)zone {
    customTextFieldCell *cell = (customTextFieldCell *)[super copyWithZone:zone];
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

//- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
//{
//    NSBezierPath *path = [NSBezierPath bezierPathWithRect:cellFrame];
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
//    [path fill];
//    [super drawInteriorWithFrame:cellFrame inView:controlView];
//}


- (void)dealloc
{
    [_cursorColor release], _cursorColor = nil;
    [super dealloc];
}

@end
