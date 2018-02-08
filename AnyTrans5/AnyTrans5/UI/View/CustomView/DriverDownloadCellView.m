//
//  DriverDownloadCellView.m
//  AnyTrans
//
//  Created by LuoLei on 2017-02-17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "DriverDownloadCellView.h"
#import "StringHelper.h"
@implementation DriverDownloadCellView
@synthesize checkBox = _checkBox;
@synthesize icon = _icon;
@synthesize titleField = _titleField;
@synthesize sizeField = _sizeField;
@synthesize progressField = _progressField;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [_checkBox init];//初始化
    [_titleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_sizeField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_progressField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}

@end
