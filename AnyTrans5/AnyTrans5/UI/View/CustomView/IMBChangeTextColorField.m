//
//  IMBChangeTextColorField.m
//  AnyTrans
//
//  Created by iMobie on 10/17/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBChangeTextColorField.h"
#import "StringHelper.h"

@implementation IMBChangeTextColorField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)textDidChange:(NSNotification *)notification {
    [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [super textDidChange:notification];
}

@end
