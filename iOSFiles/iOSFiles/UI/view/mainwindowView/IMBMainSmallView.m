//
//  IMBMainSmallView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainSmallView.h"
#import "IMBCommonDefine.h"


@implementation IMBMainSmallView
#pragma mark -
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;

#pragma mark - 
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
//    _titleLabel.stringValue = CustomLocalizedString(@"MainWindow_BigSize_Dropbox_TitleString", nil);
    [_titleLabel setFont:[NSFont fontWithName:IMBCommonFont size:18.0]];
    [_titleLabel setTextColor:COLOR_TEXT_ORDINARY];
}

@end
