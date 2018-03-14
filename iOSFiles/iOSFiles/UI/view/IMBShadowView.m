//
//  IMBShadowView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBShadowView.h"
#import "IMBCommonDefine.h"
#import "IMBCommonTool.h"


@implementation IMBShadowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [IMBCommonTool setViewBgWithView:self color:COLOR_MAIN_WINDOW_VIEW_SHADOW delta:5.0 radius:6.0f dirtyRect:dirtyRect];
}



@end
