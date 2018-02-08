//
//  IMBCheckBoxTableColumnCell.m
//  PhoneClean3.0
//
//  Created by Pallas on 8/12/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBCheckBoxTableColumnCell.h"

@implementation IMBCheckBoxTableColumnCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {

    if (_checkBox != nil) {
//        [[_checkBox cell]drawWithFrame:[self cellRectForBounds:cellFrame] inView:controlView];
        NSArray *array = [[controlView subviews] copy];
        if ([array containsObject:_checkBox]) {
            return;
        }
        [_checkBox setFrame:NSMakeRect(cellFrame.origin.x + (cellFrame.size.width - _checkBox.frame.size.width)/2.0 ,cellFrame.origin.y + (cellFrame.size.height - _checkBox.frame.size.height)/2.0, _checkBox.frame.size.width, _checkBox.frame.size.height)];

        [controlView addSubview:_checkBox];
        
    } else {
        [super drawWithFrame:cellFrame inView:controlView];
    }
}


- (NSRect)cellRectForBounds:(NSRect)cellFrame {
    
    NSRect result;
    if (_checkBox != nil) {
        result.size = NSMakeSize(self.checkBox.frame.size.width, self.checkBox.frame.size.height);
        result.origin = cellFrame.origin;
        result.origin.x = cellFrame.origin.x + (cellFrame.size.width - 16)/2;
        result.origin.y = cellFrame.origin.y + (cellFrame.size.height -16) /2;
        _cellFrames = result;
    } else {
        result = NSZeroRect;
    }
    return result;
}

- (IMBCheckBtn *)checkBox {
    return _checkBox;
}

- (void)setCheckBox:(IMBCheckBtn *)checkBox {
    if (_checkBox != checkBox) {
        [_checkBox release];
        _checkBox = [checkBox retain];
    }
}

@end
