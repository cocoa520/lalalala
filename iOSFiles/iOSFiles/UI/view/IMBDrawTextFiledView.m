//
//  IMBDrawTextFiledView.m
//  PhoneRescue
//
//  Created by long on 16-6-24.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBDrawTextFiledView.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"
#import "IMBCommonTool.h"


#define LINE 5


@implementation IMBDrawTextFiledView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [IMBCommonTool setViewBgWithView:self color:COLOR_MAIN_WINDOW_TEXTFIELD_BG delta:0 radius:4.0f dirtyRect:dirtyRect];
    // Drawing code here.
    
    
}


@end
