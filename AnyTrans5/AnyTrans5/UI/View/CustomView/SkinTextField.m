//
//  SkinTextField.m
//  AnyTrans
//
//  Created by m on 17/1/4.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "SkinTextField.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
@implementation SkinTextField
@synthesize isExplainColor = _isExplainColor;

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinChange:) name:NOTIFY_CHANGE_SKIN object:nil];
    [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)skinChange:(NSNotification *) noti {
    //此处默认为一般文字颜色
    if (_isExplainColor) {
        [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    }else {
        [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end
