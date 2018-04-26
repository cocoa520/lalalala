//
//  IMBMainBigSizeDropboxView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainBigSizeDropboxView.h"
#import "IMBCommonDefine.h"


@implementation IMBMainBigSizeDropboxView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    _titleLabel.stringValue = CustomLocalizedString(@"NotConnectDropBoxTitle", nil);
    [_titleLabel setFont:[NSFont fontWithName:IMBCommonFont size:18.0]];
    [_titleLabel setTextColor:COLOR_TEXT_ORDINARY];
    
    [_messageLabel setStringValue:CustomLocalizedString(@"NotConnectDropBoxTips", nil)];
    [_messageLabel setFont:[NSFont fontWithName:IMBCommonFont size:12.0]];
    [_messageLabel setTextColor:COLOR_TEXT_EXPLAIN];
    
    [_goNowBtn setButtonTitle:CustomLocalizedString(@"DropBox_Login", nil)];
    [_goNowBtn setFont:[NSFont fontWithName:IMBCommonFont size:14.0]];
}

@end
