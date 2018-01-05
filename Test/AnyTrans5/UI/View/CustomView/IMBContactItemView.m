//
//  IMBContactItemView.m
//  NewMacTestApp
//
//  Created by iMobie on 6/25/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBContactItemView.h"

@implementation IMBContactItemView
@synthesize isEmpty = _isEmpty;
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)isFlipped{
    return YES;
}

- (void)setIsEditing:(BOOL)isEditing{}

- (void)setEmptyValue{
    NSArray *arr = [self subviews];
    BOOL _isEmptyItem = true;
    for (NSView *view in arr) {
        if ([view isKindOfClass:[IMBTextField class]]) {
            IMBTextField *textField = (IMBTextField *)view;
            if (textField.stringValue.length != 0) {
                _isEmptyItem = false;
                break;
            }
        }
        else if([view isKindOfClass:[IMBDatePicker class]]){
            IMBDatePicker *datePicker = (IMBDatePicker *)view;
            if(!datePicker.isEmpty){
                _isEmptyItem = false;
                break;
            }
        }
    }
    _isEmpty = _isEmptyItem;
}

- (void)setIsEmpty:(BOOL)isEmpty{
    NSArray *arr = [self subviews];

    for (NSView *view in arr) {
        if ([view isKindOfClass:[IMBTextField class]]) {
            IMBTextField *textField = (IMBTextField *)view;
            [textField setIsEmpty:isEmpty];
        }
    }
    _isEmpty = isEmpty;
}

- (void)emptyFieldInItemViewHasEdit:(id)sender{
    [self setEmptyValue];
    if (!_isEmpty) {
        if (_isEditing) {
            [_deleteBtn setHidden:NO];
        }
        else{
            [_deleteBtn setHidden:YES];
        }
        
        if ([_delegate respondsToSelector:@selector(emptyItemInBlockViewHasEdit:)]) {
            [_delegate emptyItemInBlockViewHasEdit:self];
        }
    }
    else{
        [_deleteBtn setHidden:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
